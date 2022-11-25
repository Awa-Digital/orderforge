class AddPdfReceiptToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :pdf_receipt, :string
  end
end
