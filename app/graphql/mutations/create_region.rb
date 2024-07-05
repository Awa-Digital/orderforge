# frozen_string_literal: true

module Mutations
  class CreateRegion < BaseMutation
    description "create a region"
    argument :location_id, Integer
    argument :name, String

    type Types::RegionType

    def resolve(**attributes)
      Region.create!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
