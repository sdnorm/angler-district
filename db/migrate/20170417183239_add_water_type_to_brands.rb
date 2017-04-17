class AddWaterTypeToBrands < ActiveRecord::Migration[5.0]
  def change
    add_column :brands, :salt, :boolean
    add_column :brands, :fresh, :boolean
  end
end
