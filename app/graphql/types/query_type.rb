# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # # Creating methods from a list of model names ##
    # to define methods based on the names in this array
    Dir[Rails.root.join('app/models/**/*.rb')].each { |file| require file }
    Dir[Rails.root.join('app/packages/**/app/models/**/*.rb')].each { |file| require file }

    model_names = ApplicationRecord.descendants.map(&:name)
    model_names = model_names.select do |class_name|
      Object.const_defined?("Types::#{class_name}Type")
    end

    model_names = model_names.map { |s| s.gsub(/([a-z])([A-Z])/, '\1_\2').downcase.pluralize }

    # loop through array names and use 'define_method(name)'
    model_names.each do |name|
      field_name = "Types::#{name.classify}Type"
      field name.to_sym, [field_name.constantize], null: false

      field name.singularize.to_sym, field_name.constantize, null: false do
        argument :id, ID
      end

      define_method(name) do
        name.classify.constantize.all
      end

      define_method(name.singularize) do |id:|
        name.classify.constantize.find(id)
      end
    end

    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, { null: true }], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :test_field, String, null: false,
                               description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end
  end
end
