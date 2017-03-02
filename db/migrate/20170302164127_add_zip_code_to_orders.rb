class AddZipCodeToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :zip_code, :integer
  end
end
