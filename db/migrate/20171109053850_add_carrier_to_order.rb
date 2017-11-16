class AddCarrierToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :carrier, :bigint
  end
end
