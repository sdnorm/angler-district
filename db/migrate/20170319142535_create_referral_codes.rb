class CreateReferralCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :referral_codes do |t|
      t.string :code

      t.timestamps
    end
  end
end
