# frozen_string_literal: true

module Wallets
  class WithdrawToBankService
    class InsufficientBalance < StandardError; end

    def self.call(wallet:, amount_cents:, bank_detail:)
      new(wallet: wallet, amount_cents: amount_cents, bank_detail: bank_detail).call
    end

    def initialize(wallet:, amount_cents:, bank_detail:)
      @wallet = wallet
      @amount_cents = amount_cents
      @bank_detail = bank_detail
    end

    def call
      raise InsufficientBalance if @wallet.available_balance_cents < @amount_cents

      reference = "withdraw_#{@wallet.id}_#{Time.current.to_i}"
      @wallet.with_lock do
        raise InsufficientBalance if @wallet.available_balance_cents < @amount_cents

        @wallet.wallet_transactions.create!(
          amount_cents: @amount_cents,
          kind: 'withdraw',
          source: @bank_detail,
          reference: reference,
          metadata: { bank_detail_id: @bank_detail.id }
        )
        @wallet.update!(available_balance_cents: @wallet.available_balance_cents - @amount_cents)
      end
    end
  end
end
