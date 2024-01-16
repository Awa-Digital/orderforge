# frozen_string_literal: true

module Types
  class OrderType < Types::BaseObject
    field :id, ID, null: false
    field :address_id, Integer
    field :user_id, Integer
    field :status, String
    field :completed, Boolean
    field :paid, Boolean
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :reference, String
    field :recipient_name, String
    field :recipient_phone, String
    field :total, Float
    field :recipient_email, String
    field :processing_date, GraphQL::Types::ISO8601DateTime
    field :priority, Integer
    field :sent_receipt_notification, Boolean
    field :sent_processing_notification, Boolean
    field :sent_delivering_notification, Boolean
    field :sent_completed_notification, Boolean
    field :sent_guest_receipt_notification, Boolean
    field :order_no, String
    field :order_items, [Types::OrderItemType]
    field :products, [Types::ProductType]
    field :order_status_stamps, [Types::OrderStatusStampType]
    field :payment, Types::PaymentType
    field :order_addresses, Types::OrderAddressType
  end
end
