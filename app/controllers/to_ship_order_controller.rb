class ToShipOrderController < ApplicationController

  before_action :authenticate_user!

  def index
    @title = "Things I need to ship"
    @orders = Order.to_ship(current_user)
  end

  def show

  end

end
