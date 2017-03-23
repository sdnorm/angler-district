class ChangePriceAndShippingAgainAndAgainOnProducts < ActiveRecord::Migration[5.0]
  def change
    change_column :products, :price, :float
    change_column :products, :shipping, :float
  end
end
