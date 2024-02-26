# frozen_string_literal: true

module Mutations
  class CreateAd < BaseMutation
    description "Create an ad that shows up on the app"

    argument :image, String, required: true
    argument :title, String
    argument :expiration_date, GraphQL::Types::ISO8601Date
    argument :product_id, Integer
    argument :url, String

    type Types::AdType

    def resolve(attributes)
      Ad.create!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
