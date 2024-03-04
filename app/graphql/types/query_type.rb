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
      field name.to_sym, [field_name.constantize.connection_type], null: false

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
  end
end
