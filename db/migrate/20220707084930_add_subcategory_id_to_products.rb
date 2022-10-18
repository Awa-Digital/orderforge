class AddSubcategoryIdToProducts < ActiveRecord::Migration[6.1]
  def change
    add_reference :products, :subcategory, null: true, foreign_key: true
  end
end
