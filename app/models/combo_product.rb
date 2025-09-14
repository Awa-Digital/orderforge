class ComboProduct < ApplicationRecord
  include Whodunit::Stampable if defined?(Rails::Server)

  belongs_to :product
  belongs_to :parent, class_name: "Product", foreign_key: "combo_id"
end
