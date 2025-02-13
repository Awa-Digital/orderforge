class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :transactionable
      t.string :transactionable_type
      t.string :amount
      t.string :reference
      t.string :recipient_code
      t.string :narration
      t.string :transaction_type

      t.timestamps
    end
  end
end
