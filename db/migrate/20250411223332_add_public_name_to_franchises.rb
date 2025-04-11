class AddPublicNameToFranchises < ActiveRecord::Migration[7.0]
  def change
    add_column :franchises, :public_name, :string
  end
end
