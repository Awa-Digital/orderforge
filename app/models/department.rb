class Department < ApplicationRecord
  has_many :staff_departments
  has_many :staffs, through: :staff_departments
  has_many :department_roles
  has_many :roles, through: :department_roles

  include StateManagement

  def as_json(options = {})
    options[:except] = [:created_at, :updated_at]
    super
  end
end
