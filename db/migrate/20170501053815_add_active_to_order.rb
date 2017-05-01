class AddActiveToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :active, :boolean
  end
end
