class DepartmentRole < ApplicationRecord
  include Whodunit::Stampable if defined?(Rails::Server)

  belongs_to :department
  belongs_to :role

  include StateManagement

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at department_id id role_id status updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[department role]
  end
end
