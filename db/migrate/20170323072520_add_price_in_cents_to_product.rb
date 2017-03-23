class AddPriceInCentsToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :price_in_cents, :integer
    add_column :products, :shipping_in_cents, :integer
  end
end
