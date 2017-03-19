class PaypalOrderController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'openssl'

  def index
  end

  def create
    @order = Order.find(params[:id])
    @product = Product.find(@order.product_id)
    # puts "======= #{@product.inspect} ========="
    @seller = User.find(@product.user_id)
    # fee = @product.price * ENV["normal_fee_percentage"]
    fee = 1
    @order.ip_address = request.remote_ip
    @order.save
    uri = URI.parse("https://api-3t.sandbox.paypal.com/nvp")
    request = Net::HTTP::Post.new(uri)
    request.set_form_data(
      "USER" => ENV["PAYPAL_USERNAME"],
      "PWD" => ENV["PAYPAL_PASSWORD"], # the caller account Password \
      "SIGNATURE" => ENV["PAYPAL_SIGNATURE"], # the caller account Signature \
      "METHOD" => "SetExpressCheckout", # API operation \
      "RETURNURL" => paypal_show_url(@order), # URL displayed to buyer after authorizing transaction \
      "CANCELURL" => orders_url(@order), # URL displayed to buyer after canceling transaction \
      "VERSION" => 93, # API version \
      "PAYMENTREQUEST_0_CURRENCYCODE" => "USD",
      "PAYMENTREQUEST_0_AMT" => 9, # total amount of first payment \
      "PAYMENTREQUEST_0_ITEMAMT" => 0,
      "PAYMENTREQUEST_0_TAXAMT" => 0,
      "PAYMENTREQUEST_0_PAYMENTACTION" => "Order",
      "PAYMENTREQUEST_0_DESC" => "Purchased #{@product.name}",
      "PAYMENTREQUEST_0_SELLERPAYPALACCOUNTID" => "seller-ad@email.com", # PayPal e-mail of 1st receiver \
      "PAYMENTREQUEST_0_PAYMENTREQUESTID" => "Order#{@order.id}-PAYMENT0",  # unique ID for 1st payment \
      "PAYMENTREQUEST_1_CURRENCYCODE" => "USD",
      "PAYMENTREQUEST_1_AMT" => fee, # total amount of second payment \
      "PAYMENTREQUEST_1_ITEMAMT" => 0,
      "PAYMENTREQUEST_1_TAXAMT" => 0,
      "PAYMENTREQUEST_1_PAYMENTACTION" => "Order",
      "PAYMENTREQUEST_1_DESC" => "Angler District Fee",
      "PAYMENTREQUEST_1_SELLERPAYPALACCOUNTID" => "spencerdnorman-facilitator@gmail.com", # PayPal e-mail of 2nd receiver \
      "PAYMENTREQUEST_1_PAYMENTREQUESTID" => "Order#{@order.id}-PAYMENT1", # unique ID for 1st payment \
    )
    req_options = {
      use_ssl: uri.scheme == "https",
      verify_mode: OpenSSL::SSL::VERIFY_NONE,
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    paypal_return = parse_paypal(response.body)
    if paypal_return["ACK"] == "Success"
      redirect_to "https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=#{paypal_return["TOKEN"]}"
    else
      flash[:notice] = "There was a problem initiating the PayPal transaction. Please try again or use a different payment method. Thanks."
    end
  end

  def show
    @order = Order.find(params[:id])

    details = Order.get_paypal_details(params[:token])
    @order.update_attributes(express_token: params[:token])
    @order.express_payer_id = details["PAYERID"]
    @order.paypal_first_name = details["FIRSTNAME"]
    @order.paypal_last_name = details["LASTNAME"]
    @order.save
    # @order.update_paypal(params[:token])
    @order.purchase(params[:token])
  end

  private

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
end
