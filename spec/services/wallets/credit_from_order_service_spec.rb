# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Wallets::CreditFromOrderService do
  let(:franchise) { create(:franchise, service_charge_percent: 20) }
  let(:order) { create(:order, franchise: franchise, paid: true, total: 10_000) }
  let(:payment) { create(:payment, order: order, status: 'completed', paid: true) }

  before do
    allow(order).to receive(:order_total).and_return(10_000)
    allow(order).to receive(:delivery_charge).and_return(1000)
  end

  it 'creates pending wallet credit for franchise' do
    described_class.call(payment: payment)
    wallet = franchise.reload.wallet
    expect(wallet).to be_present
    expect(wallet.pending_balance_cents).to be > 0
    expect(wallet.wallet_transactions.where(kind: 'credit_pending').count).to eq(1)
  end

  it 'is idempotent per order payment' do
    2.times { described_class.call(payment: payment) }
    expect(franchise.wallet.wallet_transactions.count).to eq(1)
  end
end
