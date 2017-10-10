class Paypal::2ItemOrderController < ApplicationController

  def index
    @order = GroupedOrder.find(params[:id])

    i_fee = @order.orders.sum(:total) * ENV["NORMAL_FEE_PERCENTAGE"].to_f
    fee = i_fee.round(2)

    order_1_fee = @order.orders.first.total * ENV["NORMAL_FEE_PERCENTAGE"].to_f
    order_1_fee = order_1_fee.round(2)
    order_1_total = @order.orders.first.total - order_1_fee
    seller_1 = User.find(@order.orders.first.product.user_id)
    product_desc_1 = @order.orders.first.product.name
    order_1_id = @order.orders.first.id
    @order.orders.first.ip_address = request.remote_ip
    @order.orders.first.save

    order_2_fee = @order.orders.second.total * ENV["NORMAL_FEE_PERCENTAGE"].to_f
    order_2_fee = order_1_fee.round(2)
    order_2_total = @order.orders.second.total - order_1_fee
    seller_2 = User.find(@order.orders.second.product.user_id)
    product_desc_2 = @order.orders.second.product.name
    order_2_id = @order.orders.second.id
    @order.orders.second.ip_address = request.remote_ip
    @order.orders.second.save

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
      "PAYMENTREQUEST_0_AMT" => order_1_total, # total amount of first payment \
      "PAYMENTREQUEST_0_ITEMAMT" => 0,
      "PAYMENTREQUEST_0_TAXAMT" => 0,
      "PAYMENTREQUEST_0_PAYMENTACTION" => "Order",
      "PAYMENTREQUEST_0_DESC" => "Purchased #{product_desc_1}",
      "PAYMENTREQUEST_0_SELLERPAYPALACCOUNTID" => seller_1.paypal_email,#"seller-ad@email.com", # PayPal e-mail of 1st receiver \
      "PAYMENTREQUEST_0_PAYMENTREQUESTID" => "Order#{order_1_id}-PAYMENT0",  # unique ID for 1st payment \
      "PAYMENTREQUEST_1_CURRENCYCODE" => "USD",
      "PAYMENTREQUEST_1_AMT" => order_2_total, # total amount of first payment \
      "PAYMENTREQUEST_1_ITEMAMT" => 0,
      "PAYMENTREQUEST_1_TAXAMT" => 0,
      "PAYMENTREQUEST_1_PAYMENTACTION" => "Order",
      "PAYMENTREQUEST_1_DESC" => "Purchased #{product_desc_2}",
      "PAYMENTREQUEST_1_SELLERPAYPALACCOUNTID" => seller_2.paypal_email,#"seller-ad@email.com", # PayPal e-mail of 1st receiver \
      "PAYMENTREQUEST_1_PAYMENTREQUESTID" => "Order#{order_2_id}-PAYMENT1",  # unique ID for 1st payment \
      "PAYMENTREQUEST_2_CURRENCYCODE" => "USD",
      "PAYMENTREQUEST_2_AMT" => fee, # total amount of second payment \
      "PAYMENTREQUEST_2_ITEMAMT" => 0,
      "PAYMENTREQUEST_2_TAXAMT" => 0,
      "PAYMENTREQUEST_2_PAYMENTACTION" => "Order",
      "PAYMENTREQUEST_2_DESC" => "Angler District Fee",
      "PAYMENTREQUEST_2_SELLERPAYPALACCOUNTID" => "spencerdnorman-facilitator@gmail.com", # PayPal e-mail of 2nd receiver \
      "PAYMENTREQUEST_2_PAYMENTREQUESTID" => "Order#{@order.id}-PAYMENT2", # unique ID for 1st payment \
    )
    req_options = {
      use_ssl: uri.scheme == "https",
      verify_mode: OpenSSL::SSL::VERIFY_NONE,
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end
    paypal_return = ParsePaypal.run(response.body)
    if paypal_return["ACK"] == "Success"
      @order.orders.update_all(purchased: true, purchased_at: Time.now)
      redirect_to "#{ENV["PAYPAL_URL"]}#{paypal_return["TOKEN"]}"
    else
      flash[:notice] = "There was a problem initiating the PayPal transaction. Please try again or use a different payment method. Thanks."
    end
  end

end
