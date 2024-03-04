# frozen_string_literal: true

module Types
  class BaseObject < GraphQL::Schema::Object
    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::BaseConnection)
    connection_type_class CounterCustomConnection
    field_class Types::BaseField
  end
end
