class AddDisplayImageToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :display_image, :string
  end
end
