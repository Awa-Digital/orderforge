# frozen_string_literal: true

module Mutations
  class CreateCategory < BaseMutation
    argument :title, String
    argument :description, String
    argument :image, String

    type Types::CategoryType

    def resolve(**attributes)
      Category.create!(attributes)
    end
  end
end
