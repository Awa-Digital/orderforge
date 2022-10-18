class AddVoucherIdToPayments < ActiveRecord::Migration[6.1]
  def change
    add_column :payments, :voucher_id, :integer
  end
end
