# frozen_string_literal: true

module Mutations
  class CreateProductIngredient < BaseMutation
    description "create an ingredient for a product"
    field :product_id, Integer
    field :ingredient_id, Integer

    type Types::ProductIngredientType

    def resolve(product_id:, **attributes)
      Product.find(product_id).product_ingredients.create!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
