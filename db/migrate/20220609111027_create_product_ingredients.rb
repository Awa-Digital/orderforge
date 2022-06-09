class CreateProductIngredients < ActiveRecord::Migration[6.1]
  def change
    create_table :product_ingredients do |t|
      t.belongs_to :product, null: false, foreign_key: true
      t.belongs_to :ingredient, null: false, foreign_key: true

      t.timestamps
    end
  end
end
