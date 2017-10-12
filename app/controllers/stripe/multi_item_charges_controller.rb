class Stripe::MultiItemChargesController < ApplicationController
  before_action :set_grouped_order, only: [:create]
  before_action :authenticate_user!

  def create
    @stripe_orders = []
    @grouped_order.orders.each do |order|
      @stripe_orders << order if order.product.accept_stripe?
    end
    @stripe_total = @stripe_orders.sum {|order| order.product.price_in_cents + order.product.shipping_in_cents}
    token = params[:stripeToken]
    buyer_email = current_user.email
    customer = Stripe::Customer.create(
      source: token,
      email: buyer_email
    )
    @stripe_orders.each do |order|
      seller = order.seller
      amount = order.product.price_in_cents + order.product.shipping_in_cents
      fee = (amount.to_i * ENV["NORMAL_FEE_PERCENTAGE"].to_f)
      begin
        token = Stripe::Token.create({
          customer: customer.id
        }, {stripe_account: seller.uid})

        charge_attrs = {
          amount: amount,
          source: token.id,
          currency: 'usd',
          description: "Purchase made on AnglerDistrict.com",
          application_fee: fee.to_i
        }
        charge = Stripe::Charge.create(charge_attrs, stripe_account: seller.uid)
        product = Product.find(order.product.id)
        order.update_attributes(
          purchased: true,
          purchased_at: Time.now,
          stripe_charge_id: charge.id,
          payment_method: "stripe",
          charged: true
        )
        product.set_inventory_to_zero
        remove_from_cart product.slug
      rescue Stripe::CardError => e
        error = e.json_body[:error][:message]
        flash[:error] = "Charge failed! #{error}"
        redirect_to complete_groupedorder_path(@grouped_order)
      end
    end
    # route order depending on if orders are left unpurchased
    unpurchased_items = 0
    @grouped_order.orders.each do |order|
      if order.charged == false
        unpurchased_items += 1
      end
    end
    if unpurchased_items == 0
      flash[:notice] = "Payment Submitted Successfully!"
      redirect_to orders_path
    else
      flash[:notice] = "Credit Card Payment Submitted Successfully!"
      redirect_to complete_groupedorder_path(@grouped_order)
    end
  end

  private

  def set_grouped_order
    @grouped_order = GroupedOrder.find(params[:id])
  end

  def remove_from_cart product
    $redis.srem current_user_cart, product
  end
end
