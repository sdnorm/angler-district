class AddPurchasedToGroupedOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :grouped_orders, :purchased, :boolean
    add_column :grouped_orders, :purchased_at, :datetime
  end
end
