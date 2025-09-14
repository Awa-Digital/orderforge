class StaffDepartment < ApplicationRecord
  include Whodunit::Stampable if defined?(Rails::Server)

  belongs_to :staff
  belongs_to :department

  include StateManagement
end
