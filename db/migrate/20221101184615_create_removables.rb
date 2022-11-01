class CreateRemovables < ActiveRecord::Migration[6.1]
  def change
    create_table :removables do |t|
      t.references :order_item, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true

      t.timestamps
    end
  end
end
