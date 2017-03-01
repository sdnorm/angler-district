class CompleteAddressFormOnOrders < ActiveRecord::Migration[5.0]
  def change
    rename_column :orders, :address, :address1
    add_column :orders, :address2, :string 
  end
end
