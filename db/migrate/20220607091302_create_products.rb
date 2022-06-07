class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.string :image
      t.integer :category_id
      t.decimal :amount, precision: 8, scale: 2

      t.timestamps
    end
  end
end
