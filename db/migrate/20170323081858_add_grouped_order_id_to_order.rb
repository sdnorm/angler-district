class AddGroupedOrderIdToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :grouped_order_id, :integer
  end
end
