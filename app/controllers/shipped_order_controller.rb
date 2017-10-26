class ShippedOrderController < ApplicationController

  before_action :authenticate_user!

  def index
    @orders = Order.shipped(current_user)
  end

  def show

  end

end
