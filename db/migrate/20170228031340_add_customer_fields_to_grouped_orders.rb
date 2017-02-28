class AddCustomerFieldsToGroupedOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :grouped_orders, :first_name, :string
    add_column :grouped_orders, :last_name, :string
    add_column :grouped_orders, :address1, :string
    add_column :grouped_orders, :address2, :string
    add_column :grouped_orders, :city, :string
    add_column :grouped_orders, :state, :string
    add_column :grouped_orders, :zip_code, :integer
  end
end
