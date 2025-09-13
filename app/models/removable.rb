class Removable < ApplicationRecord
  include Whodunit::Stampable

  belongs_to :order_item
  belongs_to :ingredient

  def as_json(options = {})
    options[:methods] = %i[ingredient]
    options[:except] = %i[created_at updated_at order_item_id ingredient_id id]
    super
  end
end
