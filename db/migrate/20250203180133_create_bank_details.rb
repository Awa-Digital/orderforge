class CreateBankDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :bank_details do |t|
      t.string :account_name
      t.string :account_number
      t.string :account_type
      t.string :bank_code
      t.string :bank_name
      t.string :currency
      t.string :recipient_code
      t.string :bankable_type
      t.string :bankable_id
      t.string :country

      t.timestamps
    end
  end
end
