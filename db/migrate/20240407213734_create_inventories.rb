class CreateInventories < ActiveRecord::Migration[7.0]
  def change
    create_table :inventories do |t|
      t.string :code
      t.string :name
      t.string :description
      t.string :state
      t.boolean :expires

      t.timestamps
    end
  end
end
