class RemoveUserIdFromProducts < ActiveRecord::Migration[6.1]
  def change
    remove_column :products, :user_id, :integer
  end
end
