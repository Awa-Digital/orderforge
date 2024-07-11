class Staff < ApplicationRecord
  belongs_to :franchise
  has_many :staff_departments
  has_many :departments, through: :staff_departments
  accepts_nested_attributes_for :staff_departments

  include StateManagement

  has_secure_password

  def as_json(options = {})
    options[:methods] = %i[departments roles]
    options[:except] = %i[password_digest]
    super
  end

  def roles
    roles = []
    departments.map { |dep| roles << roles_in_department(dep) }
    roles.flatten.uniq
  end

  def role_in_department?(role_name, department)
    roles_in_department(department).exists?(name: role_name)
  end

  def roles_in_department(department)
    department.roles
  end
end
