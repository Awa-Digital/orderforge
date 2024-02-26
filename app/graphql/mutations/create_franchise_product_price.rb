# frozen_string_literal: true

module Mutations
  class CreateFranchiseProductPrice < BaseMutation
    argument :franchise_id, Integer
    argument :product_id, Integer

    type Types::FranchiseProductPriceType

    # TODO: define resolve method
    # def resolve(name:)
    #   { post: ... }
    # end
  end
end
