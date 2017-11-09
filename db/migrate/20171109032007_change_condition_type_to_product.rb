class ChangeConditionTypeToProduct < ActiveRecord::Migration[5.0]
  def change
    change_column :products, :condition, 'integer USING CAST(condition AS integer)'
  end
end
