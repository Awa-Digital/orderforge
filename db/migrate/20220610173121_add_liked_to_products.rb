class AddLikedToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :liked, :boolean, default: nil
  end
end
