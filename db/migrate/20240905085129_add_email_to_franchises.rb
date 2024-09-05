class AddEmailToFranchises < ActiveRecord::Migration[7.0]
  def change
    add_column :franchises, :email, :string
  end
end
