class FranchiseAddress < ApplicationRecord
  belongs_to :franchise
  belongs_to :region

  def as_json(options = {})
    # options[:methods] = %i[address]
    options[:except] = %i[created_at updated_at longitude latitude street]
    super
  end
end
