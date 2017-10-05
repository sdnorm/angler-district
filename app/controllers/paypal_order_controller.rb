class PaypalOrderController < ApplicationController
  require 'net/http'
  require 'uri'
  require 'openssl'

  def index
  end

  def create
    @order = Order.find(params[:id])
    @product = Product.find(@order.product_id)
    @seller = User.find(@product.user_id)
    i_fee = @order.product.price * ENV["NORMAL_FEE_PERCENTAGE"].to_f
    fee = i_fee.round(2)
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
      "PAYMENTREQUEST_0_AMT" => @order.product.price - fee, # total amount of first payment \
      "PAYMENTREQUEST_0_ITEMAMT" => 0,
      "PAYMENTREQUEST_0_TAXAMT" => 0,
      "PAYMENTREQUEST_0_PAYMENTACTION" => "Order",
      "PAYMENTREQUEST_0_DESC" => "Purchased #{@order.product.name}",
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
    paypal_return = ParsePaypal.run(response.body)
    if paypal_return["ACK"] == "Success"
      redirect_to "#{ENV["PAYPAL_URL"]}#{paypal_return["TOKEN"]}"
    else
      flash[:notice] = "There was a problem initiating the PayPal transaction. Please try again or use a different payment method. Thanks."
    end
  end

  def grouped_create
    @grouped_orders = GroupedOrder.buyer_gps(current_user.id)
    @orders = @grouped_order.orders.not_purchased
    @paypal = []
    @stripe = []
    @both = []
    @orders.each do |order|
      if order.product.accept_stripe? && order.product.accept_paypal?
        @both << order
      elsif order.product.accept_paypal?
        @paypal << order
      elsif order.product.accept_stripe?
        @stripe << order
      end
    end
    price = @orders.sum {|order| order.product.price_in_cents}
    shipping = @orders.sum {|order| order.product.shipping_in_cents}
    @total = price + shipping
    paypal_price = @paypal.sum {|order| order.product.price_in_cents}
    paypal_shipping = @paypal.sum {|order| order.product.shipping_in_cents}
    @paypal_total = paypal_price + paypal_shipping
  end

  def show
    @order = Order.find(params[:id])
    details = Order.get_paypal_details(params[:token])
    @order.update_attributes(express_token: params[:token])
    @order.express_payer_id = details["PAYERID"]
    @order.paypal_first_name = details["FIRSTNAME"]
    @order.paypal_last_name = details["LASTNAME"]
    @order.save
    @order.purchase(params[:token])
    @order = Order.find(params[:id])
    product = Product.find(@order.product_id)
    @order.purchased = true
    @order.purchased_at = Time.now
    @order.save
    product.set_inventory_to_zero
    remove_from_cart(product.slug)
    flash[:notice] = "Payment Submitted Successfully!"
    if @order.grouped_order_id == nil
      redirect_to completed_order_url(@order)
    elsif GroupedOrder.find(@order.grouped_order_id).orders.orders_left_to_purchase
      redirect_to complete_grouporder_url(GroupedOrder.find(@order.grouped_order_id))
    else
      redirect_to completed_groupedorder_url(GroupedOrder.find(@order.group_order_id))
    end
  end

end
