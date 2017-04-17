class AddFreshSaltCategoryToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :water_type, :string
  end
end
