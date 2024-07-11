class Role < ApplicationRecord
  has_many :department_roles
  has_many :departments, through: :department_roles

  include StateManagement

  def as_json(options = {})
    options[:except] = [:created_at, :updated_at, :status]
    super
  end
end
