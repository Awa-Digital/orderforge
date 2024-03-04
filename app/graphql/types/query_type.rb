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

      ### Sorting class generation
      sort_name = "#{name.classify}SortEnum"
      sort_fields = name.classify.constantize.column_names

      # Dynamically create the sort enum class
      sort_class = Class.new(GraphQL::Schema::Enum) do
        # Dynamically add enum values based on the sort_fields array
        sort_fields.each do |field|
          value "#{field.upcase}_ASC", "Sort by #{field} in ascending order"
          value "#{field.upcase}_DESC", "Sort by #{field} in descending order"
        end
      end

      # insert new class into Types Module
      Types.const_set(sort_name, sort_class)
      # --------------

      ### Filter input type generation
      filter_input_name = "#{name.classify}FilterInput"
      model_class = name.classify.constantize
      filter_fields = model_class.columns.each_with_object({}) do |column, hash|
        hash[column.name.to_sym] = String if column.type == :string
      end

      filter_input_class = Class.new(GraphQL::Schema::InputObject) do
        filter_fields.each do |field_name, field_type|
          argument field_name, field_type, required: false, description: "Filter by #{field_name}"
        end
      end

      # Insert the new class into the Types module
      Types.const_set(filter_input_name, filter_input_class)
      # --------------

      # Fields
      field name.to_sym, field_name.constantize.connection_type, null: false do
        argument :sort, "Types::#{sort_name}".constantize, required: false
        argument :filter, "Types::#{filter_input_name}".constantize, required: false, as: :filter_conditions
      end

      field name.singularize.to_sym, field_name.constantize, null: false do
        argument :id, ID
      end

      define_method(name) do |sort: nil, filter_conditions: {}|
        # Start with all records
        records = name.classify.constantize.all

        # Apply filtering logic based on `filter_conditions`
        filter_conditions&.each do |key, value|
          records = records.where("LOWER(#{key}) LIKE ?", "%#{value.downcase}%") if value.present?
        end

        # Apply sorting logic
        if sort.present?
          field, direction = sort.split('_')
          if model_class.column_names.include?(field.downcase) && %w[ASC DESC].include?(direction.upcase)
            records = records.order("#{field.downcase} #{direction.upcase}")
          end
        end

        records
      end

      define_method(name.singularize) do |id:|
        name.classify.constantize.find(id)
      end
    end
  end
end
