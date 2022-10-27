class CreateAds < ActiveRecord::Migration[6.1]
  def change
    create_table :ads do |t|
      t.string :image
      t.string :title
      t.date :expiration_date

      t.timestamps
    end
  end
end
