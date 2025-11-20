# frozen_string_literal: true

module Wallets
  class CreditFromOrderService
    def self.call(payment:)
      new(payment: payment).call
    end

    def initialize(payment:)
      @payment = payment
      @order = payment.order
      @franchise = @order&.franchise
    end

    def call
      return if @franchise.blank?

      reference = "order_#{@order.id}_payment_#{@payment.id}"
      return if WalletTransaction.exists?(reference: reference)

      credit_base = (@order.order_total.to_d - @order.delivery_charge.to_d)
      return if credit_base <= 0

      service_charge_percent = (@franchise.service_charge_percent || 20).to_d
      credit_major = credit_base * (1 - (service_charge_percent / 100))
      amount_cents = (credit_major * 100).round
      return if amount_cents <= 0

      wallet = @franchise.wallet || @franchise.create_wallet!(
        available_balance_cents: 0,
        pending_balance_cents: 0
      )

      wallet.with_lock do
        wallet.wallet_transactions.create!(
          amount_cents: amount_cents,
          kind: 'credit_pending',
          source: @order,
          reference: reference,
          metadata: { service_charge_percent: service_charge_percent.to_f }
        )
        wallet.update!(pending_balance_cents: wallet.pending_balance_cents + amount_cents)
      end
    end
  end
end
