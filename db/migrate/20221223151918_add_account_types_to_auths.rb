class AddAccountTypesToAuths < ActiveRecord::Migration[6.1]
  def change
    add_column :auths, :account_type, :string
  end
end
