class PaypalChargeController < ApplicationController

  def express
    @order = Order.find(params[:id])
    @product = Product.find(@order.product_id)
    # puts "======= #{@product.inspect} ========="
    @seller = User.find(@product.user_id)
    # fee = @product.price * ENV["normal_fee_percentage"]
    fee = 100
    response = EXPRESS_GATEWAY.setup_purchase(
      1000, #@product.price*100,
      ip: request.remote_ip,
      return_url: orders_url,
      cancel_return_url: cart_url,
      items: [
        {
          name: "Charge",
          number: "1",
          quantity: "1",
          amount: 900,#@product.price - fee,
          description: "Purchased #{@product.name}",
          category: "Digital"
          # seller_paypal_account_id: "seller-ad@email.com"#@seller.paypal_email
        },
        {
          name: "Fee",
          number: "1",
          quantity: "1",
          amount: fee,
          description: "Angler District, LLC fee for selling product - #{@product.name}",
          category: "Digital"
          # seller_paypal_account_id: "spencerdnorman-facilitator@gmail.com"#ENV["collect_paypal_email"]
        }
      ]
    )
    puts "---- #{response.inspect}"
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end

end
