class ChargesController < ApplicationController
  before_action :set_order, only: [:create]

  def new
  end

  def create
    # puts "here - - - - - - -"
    # Find the user to pay.
    # user = User.find(@order.seller_id)
    user = @order.seller
    amount = @order.product.price_to_cents + @order.product.shipping_in_cents
    fee = (amount.to_i * ENV["NORMAL_FEE_PERCENTAGE"].to_f)
    token = params[:stripeToken]
    buyer_email = params[:stripeEmail]

    customer = Stripe::Customer.create(
      source: token,
      email: buyer_email
    )

    begin
      token = Stripe::Token.create({
        customer: customer.id
      }, {stripe_account: user.access_token})

      charge_attrs = {
        # customer: customer.id,
        amount: amount,
        source: token.id,
        currency: 'usd',
        description: "Test Charge via Stripe Connect",
        application_fee: fee.to_i
      }
      # Use the user-to-be-paid's access token
      # to make the charge directly on their account
      Stripe::Charge.create(charge_attrs, stripe_account: user.access_token)
      product = Product.find(@order.product_id)
      @order.purchased = true
      @order.purchased_at = Time.now
      product.set_inventory_to_zero
      remove_from_cart(product.slug)
      ItemPurchasedMailer.alert_seller(@order.seller, @order, product, @order.buyer)
      flash[:notice] = "Payment Submitted Successfully!"
      redirect_to completed_order_url(@order)
    rescue Stripe::CardError => e
      puts "----- stripe error -----"
      error = e.json_body[:error][:message]
      flash[:error] = "Charge failed! #{error}"
      redirect_to complete_order_url(@order)
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    params.require(:order).permit(:address, :city, :state)
  end

  def remove_from_cart product
    $redis.srem current_user_cart, product
  end

end
