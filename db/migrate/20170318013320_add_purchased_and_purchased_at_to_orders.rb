class AddPurchasedAndPurchasedAtToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :purchased, :boolean
    add_column :orders, :purchased_at, :datetime
  end
end
