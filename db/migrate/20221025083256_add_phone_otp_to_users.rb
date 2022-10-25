class AddPhoneOtpToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :phone_otp, :string
  end
end
