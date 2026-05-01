class Report < ApplicationRecord
  include Whodunit::Stampable if defined?(Rails::Server)

  belongs_to :admin_user

  def self.ransackable_attributes(_auth_object = nil)
    %w[admin_user_id created_at creator_id csv_url file_name filters id id_value updated_at updater_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[admin_user]
  end
end
