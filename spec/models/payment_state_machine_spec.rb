# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe 'payment state machine' do
    let(:order) { create(:order) }
    let(:payment) { create(:payment, order: order, status: 'pending', paid: false) }

    it 'starts in pending state' do
      expect(payment).to be_pending
    end

    it 'transitions to completed on complete!' do
      allow(order).to receive(:generate_completion_notification)
      payment.complete!
      expect(payment).to be_completed
      expect(payment.paid).to be true
      expect(payment.paid_at).to be_present
    end

    it 'credits franchise wallet on completion' do
      allow(order).to receive(:generate_completion_notification)
      expect(Wallets::CreditFromOrderService).to receive(:call).with(payment: payment)
      payment.complete!
    end

    it 'transitions to failed on fail!' do
      payment.fail!
      expect(payment).to be_failed
    end
  end
end
