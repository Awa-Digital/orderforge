class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :street
      t.string :city
      t.string :state, default: 'Lagos'
      t.string :country, default: 'Nigeria', null: false

      t.timestamps
    end
  end
end
