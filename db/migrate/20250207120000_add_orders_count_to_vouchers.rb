# frozen_string_literal: true

class AddOrdersCountToVouchers < ActiveRecord::Migration[7.0]
  def up
    add_column :vouchers, :orders_count, :integer, default: 0, null: false

    # Backfill from payments count per voucher
    execute <<-SQL.squish
      UPDATE vouchers
      SET orders_count = (
        SELECT COUNT(*) FROM payments
        WHERE payments.voucher_id = vouchers.id
      )
    SQL
  end

  def down
    remove_column :vouchers, :orders_count
  end
end
