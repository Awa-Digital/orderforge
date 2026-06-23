# frozen_string_literal: true

module Mutations
  class CreateFranchise < BaseMutation
    description "Create a franchise location for the platform"

    argument :title, String
    argument :description, String

    type Types::FranchiseType

    def resolve(**attributes)
      Franchise.create!(attributes)
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
