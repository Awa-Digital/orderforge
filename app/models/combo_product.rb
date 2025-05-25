class ComboProduct < ApplicationRecord
  belongs_to :product
  belongs_to :parent, class_name: "Product", foreign_key: "combo_id"
end
