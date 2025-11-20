# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'order state machine' do
    let(:order) { create(:order, status: 'initiated') }

    it 'starts initiated' do
      expect(order).to be_initiated
    end

    it 'transitions through fulfillment states' do
      payment = create(:payment, order: order, status: 'completed', paid: true)
      order.mark_paid!
      expect(order).to be_paid

      order.start_processing!
      expect(order).to be_processing

      order.package!
      expect(order).to be_packaged

      order.start_delivery!
      expect(order).to be_delivering

      allow(Wallets::ReleasePendingForOrderService).to receive(:call)
      order.complete!
      expect(order).to be_completed
    end

    it 'cancels from initiated' do
      order.cancel!
      expect(order).to be_cancelled
    end
  end

  describe 'order snapshots' do
    let(:order) { create(:order) }
    let(:product) { create(:product, amount: 2000) }

    before do
      create(:order_item, order: order, product: product, quantity: 2)
      order.reload
    end

    it 'freezes line items and totals' do
      snapshot = order.create_order_snapshot!
      expect(snapshot[:items].size).to eq(1)
      expect(order.order_stamp['order_total']).to be_present
      expect(order.order_items.first.snapshot['product_name']).to eq(product.title)
    end
  end
end
