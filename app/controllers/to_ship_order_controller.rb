class ToShipOrderController < ApplicationController

  before_action :authenticate_user!

  def index
    @orders = Order.to_ship(current_user)
  end

  def show
    
  end

end
