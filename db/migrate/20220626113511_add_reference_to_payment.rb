class AddReferenceToPayment < ActiveRecord::Migration[6.1]
  def change
    add_column :payments, :reference, :string
  end
end
