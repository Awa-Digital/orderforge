# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Wallets::ReleasePendingForOrderService do
  let(:franchise) { create(:franchise) }
  let(:order) { create(:order, franchise: franchise, status: 'delivering', paid: true) }
  let(:payment) { create(:payment, order: order, status: 'completed', paid: true) }
  let!(:wallet) { create(:wallet, franchise: franchise, pending_balance_cents: 5000, available_balance_cents: 0) }

  before do
    wallet.wallet_transactions.create!(
      amount_cents: 5000,
      kind: 'credit_pending',
      source: order,
      reference: "order_#{order.id}_payment_#{payment.id}"
    )
  end

  it 'moves pending balance to available on order completion' do
    described_class.call(order: order)
    wallet.reload
    expect(wallet.pending_balance_cents).to eq(0)
    expect(wallet.available_balance_cents).to eq(5000)
  end
end
