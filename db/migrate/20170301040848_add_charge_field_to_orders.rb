class AddChargeFieldToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :charged, :boolean
  end
end
