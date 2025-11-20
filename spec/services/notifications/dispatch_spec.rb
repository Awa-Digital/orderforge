# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifications::Dispatch do
  let(:user) { create(:user) }
  let(:order) { create(:order, user: user) }

  it 'creates a notification with delivery records' do
    expect do
      described_class.call(kind: :order_paid, notifiable: order, context: { order: order, user: user })
    end.to change(Notification, :count).by(1)
       .and change(NotificationDelivery, :count).by(3)

    notification = Notification.last
    expect(notification.kind).to eq('order_paid')
    expect(notification.user).to eq(user)
  end
end
