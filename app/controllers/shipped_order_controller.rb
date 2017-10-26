class ShippedOrderController < ApplicationController

  before_action :authenticate_user!

  def index
    @title = "Things I've Shipped"
    @orders = Order.seller_shipped(current_user)
  end

  def show

  end

end
