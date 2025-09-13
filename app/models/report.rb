class Report < ApplicationRecord
  include Whodunit::Stampable

  belongs_to :admin_user
end
