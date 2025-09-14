class Rating < ApplicationRecord
  include Whodunit::Stampable if defined?(Rails::Server)

  belongs_to :user, optional: true
  belongs_to :product
end
