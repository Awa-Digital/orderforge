class RemovePdfReceiptFromOrders < ActiveRecord::Migration[6.1]
  def change
    remove_column :orders, :pdf_receipt, :string
  end
end
