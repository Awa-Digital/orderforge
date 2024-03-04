# frozen_string_literal: true

module Mutations
  class CreateRating < BaseMutation
    description "create a rating for a product"
    argument :user_id, Integer
    argument :product_id, Integer
    argument :rating, Float
    
    type Types::RatingType

    def resolve(**attributes)
      Rating.create!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
