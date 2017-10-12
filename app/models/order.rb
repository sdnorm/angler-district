class Order < ApplicationRecord

  include ParsePaypal
  include ProcessPaypal

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

    def shipped user
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

    def update_paypal token
      details = get_paypal_details(token)
      parse_paypal(details.body)
      self.express_payer_id = details["PAYER_ID"]
      self.paypal_first_name = details["first_name"]
      self.paypal_last_name = details["last_name"]
    end
  end

  def purchase(token)
    # process_purchase(self)
    # transactions.create!(:action => "purchase", :amount => price_in_cents, :response => response)
    # seller_amount = 9
    # EXPRESS_GATEWAY.purchase(1000, express_purchase_options)
    seller_amount = self.product.price_in_cents + self.product.shipping_in_cents
    uri = URI.parse("https://api-3t.sandbox.paypal.com/nvp")
    request = Net::HTTP::Post.new(uri)
    request.set_form_data(
      "USER" => ENV["PAYPAL_USERNAME"],
      "PWD" => ENV["PAYPAL_PASSWORD"],
      "SIGNATURE" => ENV["PAYPAL_SIGNATURE"],
      "METHOD" => "DoExpressCheckoutPayment",
      "VERSION" => "93",
      "TOKEN" => self.express_token,
      "PAYERID" => self.express_payer_id,
      "PAYMENTREQUEST_0_AMT" => seller_amount,
      "PAYMENTREQUEST_0_CURRENCYCODE" => "USD",
      "PAYMENTREQUEST_0_SELLERPAYPALACCOUNTID" => "seller-ad@email.com",#User.find(self.seller_id).paypal_email
      "PAYMENTREQUEST_0_PAYMENTREQUESTID" => "Order#{self.id}-PAYMENT0",
      "PAYMENTREQUEST_1_AMT" => 1,
      "PAYMENTREQUEST_1_CURRENCYCODE" => "USD",
      "PAYMENTREQUEST_1_SELLERPAYPALACCOUNTID" => "spencerdnorman-facilitator@gmail.com",
      "PAYMENTREQUEST_1_PAYMENTREQUESTID" => "Order#{self.id}-PAYMENT1"
    )
    req_options = {
      use_ssl: uri.scheme == "https",
      verify_mode: OpenSSL::SSL::VERIFY_NONE,
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    self.update_attributes(purchased_at: Time.now, purchased: true) if parse_paypal(response.body)["ACK"] == "SUCCESS"
    # response.success?
    # update_paypal(parse_paypal(response)["TOKEN"])
  end

  def process_purchase(order)
    processed_response = process_paypal
    parse_paypal(processed_response)
  end
end
