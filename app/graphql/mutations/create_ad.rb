# frozen_string_literal: true

module Mutations
  class CreateAd < BaseMutation
    # TODO: define return fields
    # field :post, Types::PostType, null: false

    # TODO: define arguments
    argument :image, String, required: true
    argument :title, String
    argument :expiration_date, GraphQL::Types::ISO8601Date
    argument :product_id, Integer
    argument :url, String

    type Types::AdType

    def resolve(attributes)
      Ad.create!(attributes)
    end
  end
end
