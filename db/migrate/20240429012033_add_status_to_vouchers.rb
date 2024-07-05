class AddStatusToVouchers < ActiveRecord::Migration[7.0]
  def change
    add_column :vouchers, :status, :string, default: "active"
  end
end
