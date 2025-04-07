# config/initializers/active_admin_csv_builder.rb

module ExtendedCSV
  class CSVBuilder < ActiveAdmin::CSVBuilder
    attr_accessor :custom_rows

    def initialize(options = {}, &)
      super
      @custom_rows = []
    end

    # DSL method to add a custom row
    def row(data = nil, &)
      @custom_rows << (block_given? ? yield : data)
    end

    def build(controller, csv)
      columns      = exec_columns(controller.view_context)
      bom          = options[:byte_order_mark]
      column_names = options.delete(:column_names) { true }
      csv_options  = options.except(:encoding_options, :humanize_name, :byte_order_mark)

      csv << bom if bom

      csv << CSV.generate_line(columns.map { |col| sanitize(encode(col.name, options)) }, **csv_options) if column_names

      # Initialize sum accumulator for columns with sum: true
      sums = columns.map { |col| col.options[:sum] ? 0.0 : nil }

      controller.send(:in_paginated_batches) do |resource|
        row_data = build_row(resource, columns, options)
        columns.each_with_index do |col, idx|
          if col.options[:sum]
            value = call_method_or_proc_on(resource, col.data)
            sums[idx] += value.to_f if value.respond_to?(:to_f)
          end
        end
        csv << CSV.generate_line(row_data, **csv_options)
      end

      # Append a sum row if any column has sum: true
      if sums.any? { |s| !s.nil? }
        sum_row = columns.each_with_index.map do |col, idx|
          col.options[:sum] ? sanitize(encode(sums[idx], options)) : ""
        end
        csv << CSV.generate_line(sum_row, **csv_options)
      end

      # Append any custom rows added via the DSL
      @custom_rows.each do |custom_row|
        csv << CSV.generate_line(custom_row, **csv_options)
      end

      csv
    end
  end
end

# Override ActiveAdmin's CSVBuilder with our extended version.
ActiveAdmin.send(:remove_const, :CSVBuilder)
ActiveAdmin::CSVBuilder = ExtendedCSV::CSVBuilder
