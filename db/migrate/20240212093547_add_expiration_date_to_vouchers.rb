class AddExpirationDateToVouchers < ActiveRecord::Migration[7.0]
  def change
    add_column :vouchers, :expiration_date, :datetime
  end
end
