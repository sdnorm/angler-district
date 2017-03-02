class AddNameToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :first_name, :string
    add_column :orders, :last_name, :string
  end
end
