# frozen_string_literal: true

module Mutations
  class CreateIngredient < BaseMutation
    description "create an ingredient that a burger is made of"

    argument :name, String
    argument :icon, String

    type Types::IngredientType

    def resolve(attributes)
      Ingredient.create!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
