# frozen_string_literal: true

module Mutations
  class CreateSubcategory < BaseMutation
    description "create a sub category"
    argument :title, String
    argument :category_id, Integer

    type Types::SubcategoryType

    def resolve(**attributes)
      Subcategory.create!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
