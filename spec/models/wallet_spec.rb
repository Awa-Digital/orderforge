# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Wallet, type: :model do
  it 'exposes major-unit balances' do
    wallet = create(:wallet, available_balance_cents: 2500, pending_balance_cents: 1000)
    expect(wallet.available_balance).to eq(25.0)
    expect(wallet.pending_balance).to eq(10.0)
  end
end
