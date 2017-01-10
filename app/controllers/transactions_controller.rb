class TransactionsController < ApplicationController

  before_action :authenticate_user!
  before_action :check_cart!

  def new
    gon.client_token = generate_client_token
  end

  def create
    # obtain shipping information on a form
    # create the paypal payment acceptance
    # if the return from the payment is successful
      # a) initiate the paypal payout -- actually delay the payout for 12 hours????
      # b) email / show the shipping information to the seller && and alert them

    # have the seller update tracking info and shipped notice to notify the buyer

    # check for updates on order that have been processed

    @products = params[:products]

    @result = Braintree::Transaction.sale(
              amount: current_user.cart_total_price,
              payment_method_nonce: params[:payment_method_nonce])
    if @result.success?
      current_user.purchase_cart_products!
      redirect_to root_url, notice: "Congraulations! Your order has been successfully processed!"
      @order = Order.new(order_params)
      @order.buyer_id = current_user.id
      @order.seller_id = product.user_id
      @order.save
    else
      flash[:alert] = "Something went wrong while processing your order. Please try again!"
      gon.client_token = generate_client_token
      render :new
    end
  end

  private

  def generate_client_token
    Braintree::ClientToken.generate
  end

  def check_cart!
    if current_user.get_cart_products.blank?
      redirect_to root_url, alert: "Please add some items to your cart before processing your transaction!"
    end
  end

  def order_params
    params.require(:order).permit(:address, :city, :state)
  end

end
