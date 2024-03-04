# frozen_string_literal: true

module Mutations
  class CreateProduct < BaseMutation
    description "create a product"
    argument :title, String
    argument :description, String
    argument :image, String
    argument :category_id, Integer
    argument :amount, Float
    argument :liked, Boolean
    argument :subcategory_id, Integer
    argument :start_time, Integer
    argument :end_time, Integer
    argument :status, String

    type Types::ProductType

    def resolve(**attributes)
      Product.create!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
