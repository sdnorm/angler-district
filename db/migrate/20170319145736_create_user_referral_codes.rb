class CreateUserReferralCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :user_referral_codes do |t|
      t.integer :user_id
      t.integer :referral_code_id

      t.timestamps
    end
  end
end
