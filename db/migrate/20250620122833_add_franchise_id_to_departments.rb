class AddFranchiseIdToDepartments < ActiveRecord::Migration[7.0]
  def change
    add_column :departments, :franchise_id, :integer
  end
end
