# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FranchiseAnalytics::Summary do
  let(:franchise) { create(:franchise) }

  it 'returns revenue and order counts for the window' do
    create(:order, franchise: franchise, paid: true, total: 5000, created_at: 1.day.ago)
    create(:franchise_page_visit, franchise: franchise, created_at: 1.day.ago)

    result = described_class.call(franchise: franchise, days: 7)
    expect(result[:franchise_id]).to eq(franchise.id)
    expect(result[:revenue][:current]).to eq(5000.0)
    expect(result[:orders][:current]).to eq(1)
    expect(result[:visits][:current]).to eq(1)
  end
end
