class ChargesController < ApplicationController
  before_action :set_order, only: [:create]

  def new
  end

  def create
    # Find the user to pay.
    user = User.find( params[:id] )
    # Charge $10.
    amount = 1000 #*100
    # Calculate the fee amount that goes to the application.
    fee = (amount.to_i * ENV["NORMAL_FEE_PERCENTAGE"].to_i)

    token = params[:stripeToken]
    buyer_email = params[:stripeEmail]

    customer = Stripe::Customer.create(
      card: token,
      description: "buyer account for - #{buyer_email}",
      email: buyer_email
    )

    @cart_ids = $redis.smembers current_user_cart

    if @cart_ids.count == 1
      begin
        charge_attrs = {
          customer: customer.id,
          amount: amount,
          currency: 'usd',
          description: "Test Charge via Stripe Connect",
          application_fee: fee
        }
        # Use the user-to-be-paid's access token
        # to make the charge directly on their account
        charge = Stripe::Charge.create( charge_attrs, user.secret_key )
        flash[:notice] = "Charged successfully! <a target='_blank' rel='#{params[:charge_on]}-account' href='https://dashboard.stripe.com/test/payments/#{charge.id}'>View in dashboard &raquo;</a>"
        @order = Order.new(order_params)
        @product = Product.find(@cart_ids).first
        @seller = User.find(@product.user_id)
        @order.product_id = @product.id
        @order.buyer_id = current_user.id
        @order.seller_id = @seller.id
        @order.save
        if @order.save
          @product.set_inventory_to_zero
        end
        remove_from_cart @product.id
      rescue Stripe::CardError => e
        error = e.json_body[:error][:message]
        flash[:error] = "Charge failed! #{error}"
      end
      redirect_to user_path( user )
    else
      @cart_ids.each do |id|
        begin
          charge_attrs = {
            customer: customer.id,
            amount: amount,
            currency: 'usd',
            description: "Test Charge via Stripe Connect",
            application_fee: fee
          }
          # Use the user-to-be-paid's access token
          # to make the charge directly on their account
          charge = Stripe::Charge.create( charge_attrs, user.secret_key )
          flash[:notice] = "Charged successfully! <a target='_blank' rel='#{params[:charge_on]}-account' href='https://dashboard.stripe.com/test/payments/#{charge.id}'>View in dashboard &raquo;</a>"
          @order = Order.new(order_params)
          @product = Product.find(id)
          @seller = @product.user
          @order.product_id = @product.id
          @order.buyer_id = current_user.id
          @order.seller_id = @seller.id
          @order.save
          if @order.save
            @product.set_inventory_to_zero
          end
          remove_from_cart @product.id
        rescue Stripe::CardError => e
          error = e.json_body[:error][:message]
          flash[:error] = "Charge failed! #{error}"
        end
        redirect_to user_path( user )
      end
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

  def current_user_cart
    "cart#{current_user.id}"
  end

  def remove_from_cart product_id
    $redis.srem current_user_cart, product_id
  end

  def current_user_cart
    "cart#{current_user.id}"
  end
end
