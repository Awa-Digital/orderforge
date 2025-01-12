require 'csv'

module UserService
  class ExportCsv
    def self.call
      states = Franchise.all.map { |f| f.address.region.name }
      states.each do |state|
        records = User.by_state(state)
        export_model_to_csv(records, "#{state}-users-output.csv")
      end
    end

    def self.export_model_to_csv(records, file_path)
      model = records.first.class
      attributes = model.column_names

      # Write to CSV
      CSV.open(file_path, 'w', headers: true) do |csv|
        csv << attributes # Write header row
        records.each do |record|
          csv << attributes.map { |attr| record.send(attr) } # Write each row
        end
      end

      puts "Data exported successfully to #{file_path}"
    rescue StandardError => e
      puts "Error occurred: #{e.message}"
    end
  end
end

# Usage:
# Pass the model name as a string and specify the output CSV file path
# ExportToCSV.export_model_to_csv('YourModel', 'output.csv')
