class AddProfileNameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :profile_name, :string
    add_index :users, :profile_name, unique: true
  end
end
