class GroupedOrder < ApplicationRecord
  has_many :products
  has_many :orders

  belongs_to :buyer, class_name: "User"

  scope :buyer_gps, -> (id) { where(buyer_id: id) }

end
