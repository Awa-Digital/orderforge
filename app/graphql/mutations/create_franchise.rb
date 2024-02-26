# frozen_string_literal: true

module Mutations
  class CreateFranchise < BaseMutation
    argument :title, String
    argument :description, String

    type Types::FranchiseType

    def resolve(**attributes)
      Franchise.create!(attributes)
    end
  end
end
