class CreateUserRanks < ActiveRecord::Migration[5.0]
  def change
    create_table :user_ranks do |t|
      t.integer :user_id
      t.integer :rank_id

      t.timestamps
    end
  end
end
