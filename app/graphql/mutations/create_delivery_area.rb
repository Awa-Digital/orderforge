# frozen_string_literal: true

module Mutations
  class CreateDeliveryArea < BaseMutation
    description "Create a delivery area that shows up in the UI when user wants to make a purchase"

    argument :name, String
    argument :day_rate, Float
    argument :dusk_rate, Float
    argument :night_rate, Float
    argument :dawn_rate, Float
    argument :region_id, Integer

    type Types::DeliveryAreaType

    def resolve(**attributes)
      DeliveryArea.create!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
