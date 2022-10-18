class AddCategoryIdToSubcategories < ActiveRecord::Migration[6.1]
  def change
    add_reference :subcategories, :category, null: true, foreign_key: true
  end
end
