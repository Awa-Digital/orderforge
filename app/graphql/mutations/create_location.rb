# frozen_string_literal: true

module Mutations
  class CreateLocation < BaseMutation
    description "create an location"

    argument :name, String

    type Types::LocationType

    def resolve(attributes)
      Location.create!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
