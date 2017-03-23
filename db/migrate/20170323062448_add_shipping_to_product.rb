class AddShippingToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :shipping, :integer
  end
end
