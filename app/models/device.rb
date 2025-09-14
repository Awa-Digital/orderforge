class Device < ApplicationRecord
  include Whodunit::Stampable if defined?(Rails::Server)

  belongs_to :user
end
