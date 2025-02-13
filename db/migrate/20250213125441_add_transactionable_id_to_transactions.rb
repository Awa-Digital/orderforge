class AddTransactionableIdToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :transactionable_id, :integer
  end
end
