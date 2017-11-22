class Order < ApplicationRecord

  enum carrier: {
    UPS: 0,
    FedEx: 1,
    USPS: 2,
    Other: 3
  }

  after_initialize :set_defaults

  def set_defaults
    self.shipped = false if self.new_record?
    self.purchased = false if self.new_record?
  end

  validates :address1, :city, :state, :zip_code, :first_name, :last_name, presence: true

  belongs_to :product
  belongs_to :buyer, class_name: "User"
  belongs_to :seller, class_name: "User"
  belongs_to :grouped_order

  has_many :order_products
  has_many :products, through: :order_products

  scope :paid, -> { where(charged: true) }
  scope :not_paid, -> { where(charged: false) }
  scope :buyer_orders, -> (user) { where(buyer_id: user) }
  scope :seller_orders, -> (user) { where(seller_id: user) }
  scope :not_purchased, -> { where(purchased: false) }
  scope :user_purchased, -> (buyer) { where(purchased: true, buyer_id: buyer) }
  scope :shipped, -> { where(shipped: true) }
  scope :not_shipped, -> { where(shipped: false) }

  class << self
    def open_buyer buyer
      buyer_orders(buyer.id).not_purchased.not_shipped
    end

    def to_ship user
      seller_orders(user).not_shipped
    end

    def seller_shipped user
      seller_orders(user).shipped
    end

    def purchased user
      buyer_orders(user).user_purchased
    end

    def charged user
      paid.buyer_orders(user)
    end

    def orders_left_to_purchase
      if not_purchased.count == 0
        false
      else
        true
      end
    end

  end
  
end
