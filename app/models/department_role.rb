class DepartmentRole < ApplicationRecord
  belongs_to :department
  belongs_to :role

  include StateManagement
end
