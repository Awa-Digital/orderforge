# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Packwerk', type: :model do
  it 'loads pack configuration' do
    expect(Dir.exist?(Rails.root.join('packs/shared'))).to be true
    expect(Dir.exist?(Rails.root.join('packs/ordering'))).to be true
    expect(Dir.exist?(Rails.root.join('packs/payments'))).to be true
    expect(Dir.exist?(Rails.root.join('packs/notifications'))).to be true
    expect(Dir.exist?(Rails.root.join('packs/wallets'))).to be true
  end
end
