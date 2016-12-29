class AddReferencesToProduct < ActiveRecord::Migration[5.0]
  def change
    add_reference :products, :user, foreign_key: true
    add_reference :products, :shop, foreign_key: true
  end
end
