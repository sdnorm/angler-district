class AddDefaultValueToOrderPurchased < ActiveRecord::Migration[5.0]
  def change
    change_column :orders, :purchased, :boolean, :default => false
  end
end
