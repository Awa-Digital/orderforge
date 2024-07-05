# frozen_string_literal: true

module Mutations
  class CreateInfluencer < BaseMutation
    description "Create an influencer that can market a discount code"

    type Types::InfluencerType

    argument :name, String
    argument :instagram_handle, String
    argument :twitter_handle, String, required: false
    argument :email, String, required: false

    def resolve(attributes)
      Influencer.create!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
