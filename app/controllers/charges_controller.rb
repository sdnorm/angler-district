class ChargesController < ApplicationController
  before_action :set_order, only: [:create]

  def new
  end

  def create
    user = @order.seller
    amount = @order.product.price_in_cents + @order.product.shipping_in_cents
    fee = (amount.to_i * ENV["NORMAL_FEE_PERCENTAGE"].to_f)
    token = params[:stripeToken]
    buyer_email = "spencerdnorman@yahoo.com"
    customer = Stripe::Customer.create(
      source: token,
      email: buyer_email
    )
    begin
      token = Stripe::Token.create({
        customer: customer.id
      }, {stripe_account: user.uid})

      charge_attrs = {
        amount: amount,
        source: token.id,
        currency: 'usd',
        description: "Test Charge via Stripe Connect",
        application_fee: fee.to_i
      }
      charge = Stripe::Charge.create(charge_attrs, stripe_account: user.uid)
      product = Product.find(@order.product_id)
      remove_from_cart(product.slug)
      @order.update_attributes(
        purchased: true,
        purchased_at: Time.now,
        stripe_charge_id: charge.id,
        payment_method: "stripe",
        charged: true
      )
      product.set_inventory_to_zero
      ItemPurchasedMailer.alert_seller(@order.seller, @order, product, @order.buyer)
      flash[:notice] = "Payment Submitted Successfully!"
      redirect_to completed_order_url(@order)
    rescue Stripe::CardError => e
      puts "----- stripe error < begin > -----"
      error = e.json_body[:error][:message]
      flash[:error] = "Charge failed! #{error}"
      redirect_to complete_order_url(@order)
      puts "----- stripe error < end > -----"
    end
  end

  private

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
