class AddTotalToGroupedOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :grouped_orders, :total, :float
  end
end
