class CreatePasswordResetTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :password_reset_tokens do |t|
      t.integer :user_id
      t.string :token

      t.timestamps
    end
  end
end
