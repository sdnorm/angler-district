class PurchasedOrderController < ApplicationController
  def index
    @orders = Order.user_purchased(current_user.id)
  end

  def show
    @order = Order.find(params[:id])
  end
end
