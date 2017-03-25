class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:stripe_connect]

  validates :email, presence: true
  # validates :profile_name, presence: true

  extend FriendlyId
  friendly_id :profile_name, use: :slugged

  has_many :products, dependent: :destroy
  has_many :sales, class_name: "Order", foreign_key: "seller_id"
  has_many :purchases, class_name: "Order", foreign_key: "buyer_id"
  has_many :grouped_purchases, class_name: "GroupedOrder", foreign_key: "buyer_id"
  has_many :referral_codes, through: :referral_codes
  has_many :user_ratings
  has_many :ratings, through: :user_ratings
  has_many :orders

  scope :paypal, -> { where(paypal_email_the_same: true).or(where.not(paypal_email: nil)) }
  scope :stripe, -> { where(provider: "stripe_connect")}

  def cart_count
    $redis.scard "cart#{id}"
  end

  def paypal_and_stripe
    paypal.stripe
  end

  def average_rating
    total = self.ratings.sum(:score)
    count = self.ratings.count
    average = total / count
    return average
  end

  def cart_total_price
    total_price = 0
    get_cart_products.each { |product| total_price += product.price }
    total_price
  end

  def get_cart_products
    cart_ids = $redis.smembers "cart#{id}"
    Product.where(slug: cart_ids)
  end

  def purchase_cart_products!
    get_cart_products.each { |product| purchase(product) }
    $redis.del "cart#{id}"
  end

  def purchase?(product)
    products.include?(product)
  end

  def purchase(product)
    products << product unless purchase?(product)
  end

  def stripe?
    if self.provider == "stripe_connect"
      true
    else
      false
    end
  end

  def paypal?
    if self.paypal_email_the_same == true || self.paypal_email != nil
      true
    else
      false
    end
  end

  class << self
    def paypal_and_stripe
      paypal.stripe
    end
  end

end
