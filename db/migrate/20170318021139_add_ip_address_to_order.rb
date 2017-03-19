class AddIpAddressToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :ip_address, :string
  end
end
