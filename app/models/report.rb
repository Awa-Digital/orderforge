class Report < ApplicationRecord
  include Whodunit::Stampable if defined?(Rails::Server)

  belongs_to :admin_user
end
