class ChargesController < ApplicationController
  before_action :set_order, only: [:create]

  def new
  end

  def create
    @order = Order.find(params[:order])
    # Find the user to pay.
    # user = User.find(@order.seller_id)
    user = "acct_19o2A4DAZfujDBem"
    amount = @order.total.to_i*100
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
      }, {stripe_account: user})

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
      Stripe::Charge.create(charge_attrs, stripe_account: "acct_19o2A4DAZfujDBem")
      flash[:notice] = "Payment Submitted Successfully!"
      product = Product.find(@order.product_id)
      @order.charged = true
      product.set_inventory_to_zero
      remove_from_cart product.id
    rescue Stripe::CardError => e
      error = e.json_body[:error][:message]
      flash[:error] = "Charge failed! #{error}"
      redirect_to complete_order_path(@order)
    end
    redirect_to charged_order_path(@order)

  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params[:order])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    params.require(:order).permit(:address, :city, :state)
  end

end
