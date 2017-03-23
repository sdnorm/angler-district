class ChangePriceAndShippingOnProducts < ActiveRecord::Migration[5.0]
  def change
    change_column :products, :price, :integer
    change_column :products, :shipping, :integer
  end
end
