class ReferralCode < ApplicationRecord

  has_many :users, through: :user_referral_codes

end
