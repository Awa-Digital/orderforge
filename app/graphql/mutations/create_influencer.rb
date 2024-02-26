# frozen_string_literal: true

module Mutations
  class CreateInfluencer < BaseMutation

    type Types::InfluencerType

    # TODO: define return fields
    # field :post, Types::PostType, null: false

    # TODO: define arguments
    # argument :name, String, required: true

    def resolve(attributes)
      Influencer.create!(attributes)
    end
  end
end
