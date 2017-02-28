class CreateGroupedOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :grouped_orders do |t|

      t.timestamps
    end
  end
end
