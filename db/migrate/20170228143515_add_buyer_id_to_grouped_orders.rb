class AddBuyerIdToGroupedOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :grouped_orders, :buyer_id, :integer
  end
end
