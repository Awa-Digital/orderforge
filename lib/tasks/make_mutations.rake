# lib/tasks/graphql_mutations.rake

namespace :graphql do
  desc "Generate GraphQL mutations for models"
  task generate_mutations: :environment do
    Dir[Rails.root.join('app/models/**/*.rb')].each { |file| require file }
    Dir[Rails.root.join('app/packages/**/app/models/**/*.rb')].each { |file| require file }

    model_names = ApplicationRecord.descendants.map(&:name)
    model_names = model_names.select do |class_name|
      Object.const_defined?("Types::#{class_name}Type")
    end

    model_names = model_names.map { |s| s.gsub(/([a-z])([A-Z])/, '\1_\2').downcase }

    model_names.each do |model_name|
      classified_name = model_name.classify

      # Generate Create mutation
      system("rails generate graphql:mutation Create#{classified_name}")

      # Generate Update mutation
      system("rails generate graphql:mutation Update#{classified_name}")

      # Generate Destroy mutation
      system("rails generate graphql:mutation Destroy#{classified_name}")
    end
  end
end
