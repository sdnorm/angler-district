class GroupedChargesController < ApplicationController

  before_action :authenticate_user!

  def new
  end

  def create
    @grouped_order = GroupedOrder.find(params[:grouped_order])
    # Find the user to pay.
    # user = User.find(@order.seller_id)

    @stripe_orders = []
    @grouped_order.map do |order|
      @stripe_orders << order if order.product.accept_stripe?
    end

    @stripe_total = @stripe_orders.sum {|order| order.price_in_cents + order.shipping_in_cents}

    token = params[:stripeToken]
    # buyer_email = params[:stripeEmail]
    buyer_email = current_user.email
    customer = Stripe::Customer.create(
      source: token,
      email: buyer_email
    )

    if @stripe_orders.count == 1

      seller = @stripe_orders.first.seller.access_code# ENV['']
      amount = @stripe_orders.first.product.price_in_cents + shipping_in_cents
      fee = (amount.to_i * ENV["NORMAL_FEE_PERCENTAGE"].to_f)

      begin
        token = Stripe::Token.create({
          customer: customer.id
        }, {stripe_account: user})

        charge_attrs = {
          # customer: customer.id,
          amount: amount,
          source: token.id,
          currency: 'usd',
          description: "Purchase made on AnglerDistrict.com",
          application_fee: fee.to_i
        }
        # Use the user-to-be-paid's access token
        # to make the charge directly on their account
        Stripe::Charge.create(charge_attrs, stripe_account: seller)
        flash[:notice] = "Payment Submitted Successfully!"
        product = Product.find(@stripe_orders.first.product_id)
        @stripe_orders.first.order.charged = true
        product.set_inventory_to_zero
        remove_from_cart product.slug
      rescue Stripe::CardError => e
        error = e.json_body[:error][:message]
        flash[:error] = "Charge failed! #{error}"
        redirect_to complete_groupedorder_path(@grouped_order)
      end

    else
      @stripe_orders.each do |order|
        seller = order.seller.access_code# ENV['']
        amount = order.product.price_in_cents + shipping_in_cents
        fee = (amount.to_i * ENV["NORMAL_FEE_PERCENTAGE"].to_f)

        begin
          token = Stripe::Token.create({
            customer: customer.id
          }, {stripe_account: user})

          charge_attrs = {
            # customer: customer.id,
            amount: amount,
            source: token.id,
            currency: 'usd',
            description: "Purchase made on AnglerDistrict.com",
            application_fee: fee.to_i
          }
          # Use the user-to-be-paid's access token
          # to make the charge directly on their account
          Stripe::Charge.create(charge_attrs, stripe_account: seller)
          flash[:notice] = "Payment Submitted Successfully!"
          product = Product.find(@order.product_id)
          order.charged = true
          product.set_inventory_to_zero
          remove_from_cart product.slug
        rescue Stripe::CardError => e
          error = e.json_body[:error][:message]
          flash[:error] = "Charge failed! #{error}"
          redirect_to complete_groupedorder_path(@grouped_order)
        end
      end
      # route order depending on if orders are left unpurchased
      redirect_to charged_order_path(@order)
    end

  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_grouped_order
    @order = Order.find(params[:grouped_order])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def grouped_order_params
    params.require(:grouped_order).permit(:address, :city, :state)
  end
end
