class AddGroupedProductReferencesToOrders < ActiveRecord::Migration[5.0]
  def change
    add_reference :orders, :grouped_orders, foreign_key: true
  end
end
