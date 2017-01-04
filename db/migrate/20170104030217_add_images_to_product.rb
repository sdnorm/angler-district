class AddImagesToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :image2, :string
    add_column :products, :image3, :string
    add_column :products, :image4, :string
  end
end
