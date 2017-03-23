class Order < ApplicationRecord

  require 'net/http'
  require 'uri'
  require 'openssl'

  validates :address1, :city, :state, :zip_code, :first_name, :last_name, presence: true

  belongs_to :product
  belongs_to :buyer, class_name: "User"
  belongs_to :seller, class_name: "User"
  belongs_to :grouped_order

  has_many :order_products
  has_many :products, through: :order_products

  scope :buyer_orders, -> (buyer_id) { where(buyer_id: buyer_id.id) }

  scope :paid, -> { where(charged: true) }

  scope :buyer_orders, -> (current_user) { where(buyer_id: current_user) }

  class << self
    def charged user
      paid.buyer_orders(user)
    end

    def get_paypal_details token
      uri = URI.parse("https://api-3t.sandbox.paypal.com/nvp")
      request = Net::HTTP::Post.new(uri)
      request.set_form_data(
        "USER" => ENV["PAYPAL_USERNAME"],
        "PWD" => ENV["PAYPAL_PASSWORD"],
        "SIGNATURE" => ENV["PAYPAL_SIGNATURE"],
        "METHOD" => "GetExpressCheckoutDetails",
        "VERSION" => "93",
        "TOKEN" => token,
      )
      req_options = {
        use_ssl: uri.scheme == "https",
        verify_mode: OpenSSL::SSL::VERIFY_NONE,
      }
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
      ParsePaypal.run(response.body)
    end

    def update_paypal token
      details = get_paypal_details(token)
      self.express_payer_id = details["PAYER_ID"]
      self.paypal_first_name = details["first_name"]
      self.paypal_last_name = details["last_name"]
    end

  end

  def purchase(token)
    # process_purchase(self)
    # transactions.create!(:action => "purchase", :amount => price_in_cents, :response => response)
    seller_amount = 9
    # EXPRESS_GATEWAY.purchase(1000, express_purchase_options)
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
    self.update_attributes(purchased_at: Time.now, purchased: true) if ParsePaypal.run(response.body)["ACK"] == "SUCCESS"
    # response.success?
    # update_paypal(parse_paypal(response)["TOKEN"])
  end

  # def express_token=(token)
  #   self[:express_token] = token
  #   if new_record? && !token.blank?
  #     details = EXPRESS_GATEWAY.details_for(self.token)
  #     self.express_payer_id = details.payer_id
  #     self.paypal_first_name = details.params["first_name"]
  #     self.paypal_last_name = details.params["last_name"]
  #   end
  # end

  def price_in_cents
    (cart.total_price*100).round
  end

private

  def process_purchase(order)
    seller_amount = 9
    # EXPRESS_GATEWAY.purchase(1000, express_purchase_options)
    uri = URI.parse("https://api-3t.sandbox.paypal.com/nvp")
    request = Net::HTTP::Post.new(uri)
    request.set_form_data(
      "USER" => ENV["PAYPAL_USERNAME"],
      "PWD" => ENV["PAYPAL_PASSWORD"],
      "SIGNATURE" => ENV["PAYPAL_SIGNATURE"],
      "METHOD" => "DoExpressCheckoutPayment",
      "VERSION" => "93",
      "TOKEN" => order.express_token,
      "PAYERID" => order.express_payer_id,
      "PAYMENTREQUEST_0_AMT" => seller_amount,
      "PAYMENTREQUEST_0_CURRENCYCODE" => "USD",
      "PAYMENTREQUEST_0_SELLERPAYPALACCOUNTID" => "seller-ad@email.com",#User.find(self.seller_id).paypal_email
      "PAYMENTREQUEST_0_PAYMENTREQUESTID" => "Order#{order.id}-PAYMENT0",
      "PAYMENTREQUEST_1_AMT" => 1,
      "PAYMENTREQUEST_1_CURRENCYCODE" => "USD",
      "PAYMENTREQUEST_1_SELLERPAYPALACCOUNTID" => "spencerdnorman-facilitator@gmail.com",
      "PAYMENTREQUEST_1_PAYMENTREQUESTID" => "Order#{order.id}-PAYMENT1"
    )
    req_options = {
      use_ssl: uri.scheme == "https",
      verify_mode: OpenSSL::SSL::VERIFY_NONE,
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    ParsePaypal.run(response)
  end

  def parse_paypal token
    response_array = token.split(/[=,&]/)
    parsed_reponse = {}
    response_array.each_with_index do |phrase, index|
      scrubbed_phrase = phrase.gsub("%2d", "-").gsub("%3a", ":").gsub("%2e", ".").gsub("%20", " ")
      case index
      when 1
        parsed_reponse.merge!(response_array[0] => scrubbed_phrase)
      when 3
        parsed_reponse.merge!(response_array[2] => scrubbed_phrase)
      when 5
        parsed_reponse.merge!(response_array[4] => scrubbed_phrase)
      when 7
        parsed_reponse.merge!(response_array[6] => scrubbed_phrase)
      when 9
        parsed_reponse.merge!(response_array[8] => scrubbed_phrase)
      when 11
        parsed_reponse.merge!(response_array[10] => scrubbed_phrase)
      when 13
        parsed_reponse.merge!(response_array[12] => scrubbed_phrase)
      when 15
        parsed_reponse.merge!(response_array[14] => scrubbed_phrase)
      when 17
        parsed_reponse.merge!(response_array[16] => scrubbed_phrase)
      when 19
        parsed_reponse.merge!(response_array[18] => scrubbed_phrase)
      when 21
        parsed_reponse.merge!(response_array[20] => scrubbed_phrase)
      when 23
        parsed_reponse.merge!(response_array[22] => scrubbed_phrase)
      when 25
        parsed_reponse.merge!(response_array[24] => scrubbed_phrase)
      when 27
        parsed_reponse.merge!(response_array[26] => scrubbed_phrase)
      when 29
        parsed_reponse.merge!(response_array[28] => scrubbed_phrase)
      when 31
        parsed_reponse.merge!(response_array[30] => scrubbed_phrase)
      when 33
        parsed_reponse.merge!(response_array[32] => scrubbed_phrase)
      when 35
        parsed_reponse.merge!(response_array[34] => scrubbed_phrase)
      when 37
        parsed_reponse.merge!(response_array[36] => scrubbed_phrase)
      when 39
        parsed_reponse.merge!(response_array[38] => scrubbed_phrase)
      when 41
        parsed_reponse.merge!(response_array[40] => scrubbed_phrase)
      when 43
        parsed_reponse.merge!(response_array[42] => scrubbed_phrase)
      when 45
        parsed_reponse.merge!(response_array[44] => scrubbed_phrase)
      when 47
        parsed_reponse.merge!(response_array[46] => scrubbed_phrase)
      when 49
        parsed_reponse.merge!(response_array[48] => scrubbed_phrase)
      when 51
        parsed_reponse.merge!(response_array[50] => scrubbed_phrase)
      when 53
        parsed_reponse.merge!(response_array[52] => scrubbed_phrase)
      when 55
        parsed_reponse.merge!(response_array[54] => scrubbed_phrase)
      when 57
        parsed_reponse.merge!(response_array[56] => scrubbed_phrase)
      when 59
        parsed_reponse.merge!(response_array[58] => scrubbed_phrase)
      when 61
        parsed_reponse.merge!(response_array[60] => scrubbed_phrase)
      when 63
        parsed_reponse.merge!(response_array[62] => scrubbed_phrase)
      when 65
        parsed_reponse.merge!(response_array[64] => scrubbed_phrase)
      when 67
        parsed_reponse.merge!(response_array[66] => scrubbed_phrase)
      when 69
        parsed_reponse.merge!(response_array[68] => scrubbed_phrase)
      when 71
        parsed_reponse.merge!(response_array[70] => scrubbed_phrase)
      when 73
        parsed_reponse.merge!(response_array[72] => scrubbed_phrase)
      when 75
        parsed_reponse.merge!(response_array[74] => scrubbed_phrase)
      when 77
        parsed_reponse.merge!(response_array[76] => scrubbed_phrase)
      when 79
        parsed_reponse.merge!(response_array[78] => scrubbed_phrase)
      when 81
        parsed_reponse.merge!(response_array[80] => scrubbed_phrase)
      when 83
        parsed_reponse.merge!(response_array[82] => scrubbed_phrase)
      when 85
        parsed_reponse.merge!(response_array[84] => scrubbed_phrase)
      when 87
        parsed_reponse.merge!(response_array[86] => scrubbed_phrase)
      when 89
        parsed_reponse.merge!(response_array[88] => scrubbed_phrase)
      when 91
        parsed_reponse.merge!(response_array[90] => scrubbed_phrase)
      when 93
        parsed_reponse.merge!(response_array[92] => scrubbed_phrase)
      when 95
        parsed_reponse.merge!(response_array[94] => scrubbed_phrase)
      when 97
        parsed_reponse.merge!(response_array[96] => scrubbed_phrase)
      when 99
        parsed_reponse.merge!(response_array[98] => scrubbed_phrase)
      when 101
        parsed_reponse.merge!(response_array[100] => scrubbed_phrase)
      when 103
        parsed_reponse.merge!(response_array[102] => scrubbed_phrase)
      when 105
        parsed_reponse.merge!(response_array[104] => scrubbed_phrase)
      when 107
        parsed_reponse.merge!(response_array[106] => scrubbed_phrase)
      when 109
        parsed_reponse.merge!(response_array[108] => scrubbed_phrase)
      when 111
        parsed_reponse.merge!(response_array[110] => scrubbed_phrase)
      when 113
        parsed_reponse.merge!(response_array[112] => scrubbed_phrase)
      when 115
        parsed_reponse.merge!(response_array[114] => scrubbed_phrase)
      when 117
        parsed_reponse.merge!(response_array[116] => scrubbed_phrase)
      when 119
        parsed_reponse.merge!(response_array[118] => scrubbed_phrase)
      when 121
        parsed_reponse.merge!(response_array[120] => scrubbed_phrase)
      when 123
        parsed_reponse.merge!(response_array[122] => scrubbed_phrase)
      when 125
        parsed_reponse.merge!(response_array[124] => scrubbed_phrase)
      when 127
        parsed_reponse.merge!(response_array[126] => scrubbed_phrase)
      when 129
        parsed_reponse.merge!(response_array[128] => scrubbed_phrase)
      when 131
        parsed_reponse.merge!(response_array[130] => scrubbed_phrase)
      when 133
        parsed_reponse.merge!(response_array[132] => scrubbed_phrase)
      when 135
        parsed_reponse.merge!(response_array[134] => scrubbed_phrase)
      when 137
        parsed_reponse.merge!(response_array[136] => scrubbed_phrase)
      end
    end
    return parsed_reponse
  end

  # def get_paypal_details token
  #   uri = URI.parse("https://api-3t.sandbox.paypal.com/nvp")
  #   request = Net::HTTP::Post.new(uri)
  #   request.set_form_data(
  #     "USER" => ENV["PAYPAL_USERNAME"],
  #     "PWD" => ENV["PAYPAL_PASSWORD"],
  #     "SIGNATURE" => ENV["PAYPAL_SIGNATURE"],
  #     "METHOD" => "GetExpressCheckoutDetails",
  #     "VERSION" => "93",
  #     "TOKEN" => token,
  #   )
  #   req_options = {
  #     use_ssl: uri.scheme == "https",
  #     verify_mode: OpenSSL::SSL::VERIFY_NONE,
  #   }
  #   response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  #     http.request(request)
  #   end
  #   parse_paypal(response)
  # end

end
