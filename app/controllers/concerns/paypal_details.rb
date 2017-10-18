module PaypalDetails

  def PaypalDetails.get token
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
    return response
  end

end
