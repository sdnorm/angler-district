class AddCountToReferralCode < ActiveRecord::Migration[5.0]
  def change
    add_column :referral_codes, :count, :integer
    add_column :referral_codes, :count_limit, :integer
  end
end
