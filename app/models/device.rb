class Device < ApplicationRecord
  include Whodunit::Stampable

  belongs_to :user
end
