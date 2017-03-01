class RemoveGroupedOrdersFromProducts < ActiveRecord::Migration[5.0]
  def change
    remove_reference :products, :grouped_orders, index: true
  end
end
