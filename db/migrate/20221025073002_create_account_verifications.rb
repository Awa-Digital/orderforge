class CreateAccountVerifications < ActiveRecord::Migration[6.1]
  def change
    create_table :account_verifications do |t|
      t.string :phone
      t.string :otp
      t.string :email
      t.string :email_token
      t.boolean :email_verified, default: false
      t.boolean :phone_verified, default: false
      t.integer :user_id

      t.timestamps
    end
  end
end
