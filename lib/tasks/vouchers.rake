# frozen_string_literal: true

namespace :vouchers do
  desc "Recalculate orders_count for all vouchers (active and inactive) from payments"
  task refresh_orders_count: :environment do
    updated = ActiveRecord::Base.connection.execute(<<-SQL.squish)
      UPDATE vouchers
      SET orders_count = (
        SELECT COUNT(*)::integer FROM payments
        WHERE payments.voucher_id = vouchers.id
      )
    SQL
    count = Voucher.unscoped.count
    puts "Refreshed orders_count for all #{count} vouchers (active and inactive)."
  end
end
