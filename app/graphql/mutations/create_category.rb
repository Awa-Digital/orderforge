# frozen_string_literal: true

module Mutations
  class CreateCategory < BaseMutation
    description "Create a category that groups the menu items"
    argument :title, String
    argument :description, String
    argument :image, String

    type Types::CategoryType

    def resolve(**attributes)
      Category.create!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
