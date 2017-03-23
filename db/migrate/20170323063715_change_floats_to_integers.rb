class ChangeFloatsToIntegers < ActiveRecord::Migration[5.0]
  def change
    change_column :grouped_orders, :total, :integer
    change_column :orders, :total, :integer
    change_column :products, :price, :integer
  end
end
