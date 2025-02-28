class AddAssociatedFranchisesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :associated_franchises, :integer, array: true, default: []
  end
end
