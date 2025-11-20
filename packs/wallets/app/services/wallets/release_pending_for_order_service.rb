# frozen_string_literal: true

module Wallets
  class ReleasePendingForOrderService
    def self.call(order:)
      new(order: order).call
    end

    def initialize(order:)
      @order = order
      @franchise = order.franchise
    end

    def call
      return if @franchise.blank?

      wallet = @franchise.wallet
      return if wallet.blank?

      reference = "order_#{@order.id}_payment_#{@order.payment&.id}"
      pending_tx = wallet.wallet_transactions.find_by(reference: reference, kind: 'credit_pending')
      return if pending_tx.blank? || pending_tx.released_at.present?

      amount_cents = pending_tx.amount_cents
      wallet.with_lock do
        WalletTransaction.create!(
          wallet: wallet,
          amount_cents: amount_cents,
          kind: 'debit_pending',
          source: @order,
          reference: "release_#{pending_tx.id}_debit",
          metadata: { release_of: pending_tx.id }
        )
        WalletTransaction.create!(
          wallet: wallet,
          amount_cents: amount_cents,
          kind: 'credit_available',
          source: @order,
          reference: "release_#{pending_tx.id}_credit",
          metadata: { release_of: pending_tx.id }
        )
        wallet.update!(
          pending_balance_cents: wallet.pending_balance_cents - amount_cents,
          available_balance_cents: wallet.available_balance_cents + amount_cents
        )
        pending_tx.update_column(:released_at, Time.current)
      end
    end
  end
end
