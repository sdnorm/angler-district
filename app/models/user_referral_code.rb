class UserReferralCode < ApplicationRecord

  belongs_to :user
  belongs_to :referral_code
  
end
