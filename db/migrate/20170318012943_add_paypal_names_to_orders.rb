class AddPaypalNamesToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :paypal_first_name, :string
    add_column :orders, :paypal_last_name, :string
  end
end
