# frozen_string_literal: true

module Mutations
  class CreateDeliveryArea < BaseMutation
    argument :name, String
    argument :day_rate, Float
    argument :dusk_rate, Float
    argument :night_rate, Float
    argument :dawn_rate, Float
    argument :region_id, Integer

    type Types::DeliveryAreaType

    def resolve(**attributes)
      DeliveryArea.create!(attributes)
    end
  end
end
