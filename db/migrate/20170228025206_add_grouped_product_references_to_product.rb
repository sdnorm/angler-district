class AddGroupedProductReferencesToProduct < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :grouped_orders, foreign_key: true
  end
end
