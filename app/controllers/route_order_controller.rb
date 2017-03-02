class RouteOrderController < ApplicationController

  def route_order
    @cart_ids = $redis.smembers current_user_cart
    if @cart_ids.count == 0
      redirect_to :back, flash[:notice] = "All items were removed from your cart."
    elsif @cart_ids.count == 1
      redirect_to new_order_url
    else
      redirect_to new_grouped_order_url
    end
  end

end
