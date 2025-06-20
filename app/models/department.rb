class Department < ApplicationRecord
  has_many :staff_departments
  has_many :staffs, through: :staff_departments
  has_many :department_roles
  has_many :roles, through: :department_roles
  has_many :admin_users
  belongs_to :franchise, optional: true

  include StateManagement

  def as_json(options = {})
    options[:except] = [:created_at, :updated_at]
    super
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at franchise_id id name status updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[admin_users department_roles franchise roles staff_departments staffs]
  end

  def abilities
    roles.map do |role|
      { role.model => role.name }
    end
  end
end
