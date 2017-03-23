class RouteOrderController < ApplicationController

  def route_order
    @cart_ids = $redis.smembers current_user_cart
    @recent_open_order = Order.where(buyer_id: current_user.id, purchased: nil).order(:created_at).last
    product = Product.find(@recent_open_order.product_id)
    if @cart_ids.count == 0
      redirect_to :back, flash[:notice] = "All items were removed from your cart."
    elsif @cart_ids.count == 1 && @cart_ids.first == product.slug
      redirect_to complete_order_url(@recent_open_order)
    elsif @cart_ids.count == 1
      redirect_to new_order_url
    else
      redirect_to new_grouped_order_url
    end
  end

end
