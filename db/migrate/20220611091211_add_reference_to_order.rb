class AddReferenceToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :reference, :string
  end
end
