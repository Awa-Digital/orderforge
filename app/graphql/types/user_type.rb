# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :first_name, String
    field :last_name, String
    field :email, String
    field :phone_number, String
    field :password_digest, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :phone_otp, String
    field :active, Boolean
    field :avatar, String
    field :spend_score, Float
    field :orders, [Types::OrderType]
    field :payments, [Types::PaymentType]
    field :favourite, Types::FavouriteType
    field :notification_setting, Types::NotificationSettingType
    field :notifications, [Types::NotificationType]
    field :addresses, [Types::AddressType]
    field :devices, [Types::DeviceType]
    field :ratings, [Types::RatingType]
    field :password_reset_token, Types::PasswordResetTokenType
  end
end
