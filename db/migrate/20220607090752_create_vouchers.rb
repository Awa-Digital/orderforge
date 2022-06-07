class CreateVouchers < ActiveRecord::Migration[6.1]
  def change
    create_table :vouchers do |t|
      t.string :title
      t.string :discount_code
      t.integer :influencer_id
      t.decimal :discount_rate, precision: 4, scale: 2

      t.timestamps
    end
  end
end
