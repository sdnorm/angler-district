class Rating < ApplicationRecord

  has_many :user_ratinga
  has_many :users, through: :user_ratings

end
