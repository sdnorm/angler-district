class DropOrderProducts < ActiveRecord::Migration[5.0]
  def change
    drop_table :order_products
  end
end
