class StaffDepartment < ApplicationRecord
  include Whodunit::Stampable

  belongs_to :staff
  belongs_to :department

  include StateManagement
end
