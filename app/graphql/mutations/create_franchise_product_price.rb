# frozen_string_literal: true

module Mutations
  class CreateFranchiseProductPrice < BaseMutation
    description "Create a price for a franchise's product"

    argument :franchise_id, Integer
    argument :product_id, Integer

    type Types::FranchiseProductPriceType

    def resolve(franchise_id:, **attributes)
      Franchise.find(franchise_id).franchise_product_prices.create!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
