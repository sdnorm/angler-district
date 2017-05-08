module ProcessPaypal
  extend ActiveSupport::Concern

  module ClassMethods
    require 'net/http'
    require 'uri'
    require 'openssl'

    def process_paypal
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
      return response
    end
  end
end
