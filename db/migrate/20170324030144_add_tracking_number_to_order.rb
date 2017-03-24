class AddTrackingNumberToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :tracking_number, :string
  end
end
