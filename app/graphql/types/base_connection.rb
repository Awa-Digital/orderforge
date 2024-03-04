# frozen_string_literal: true

module Types
  class BaseConnection < Types::BaseObject
    # add `nodes` and `pageInfo` fields, as well as `edge_type(...)` and `node_nullable(...)` overrides
    include GraphQL::Types::Relay::ConnectionBehaviors

    field :total_count, Integer, null: false, description: "Total number of items in the collection"

    def total_count
      # Assumes the object responds to `object`, which is the collection being paginated
      object.items.size
    end
  end
end
