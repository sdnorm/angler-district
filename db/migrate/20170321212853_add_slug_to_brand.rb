class AddSlugToBrand < ActiveRecord::Migration[5.0]
  def change
    add_column :brands, :slug, :string
  end
end
