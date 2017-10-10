class GroupedOrder < ApplicationRecord

  include ParsePaypal
  include ProcessPaypal

  validates :address1, :city, :state, :zip_code, :first_name, :last_name, presence: true

  has_many :products
  has_many :orders

  belongs_to :buyer, class_name: "User"

  scope :buyer_gps, -> (id) { where(buyer_id: id) }

end
