class RouteOrderController < ApplicationController

  def route_order
    @cart_ids = $redis.smembers current_user_cart
    
    case @cart_ids.count
    when 0
      redirect_back fallback_location: cart_url, notice: "All items were removed from your cart."
    when 1
      get_recent
      if check_for_recent && @product != nil && @cart_ids.first == @product.slug
        redirect_to complete_order_url(@recent_open_order)
      else
        redirect_to new_order_url
      end
    else
      get_recent_grouped
      if @products_ids != nil && @cart_ids == @products_ids
        redirect_to complete_grouporder_url(@recent_grouped_order)
      else
        redirect_to new_grouped_order_url
      end
    end
  end

  def get_recent
    recent_orders = Order.open_buyer(current_user)
    if recent_orders.count == 1
      @recent_open_order = recent_orders.first
    else
      @recent_open_order = recent_orders.order(:created_at).last
    end
    @product = Product.find(@recent_open_order.product_id) if @recent_open_order != nil
  end

  def get_recent_grouped
    @recent_grouped_order = GroupedOrder.where(buyer_id: current_user.id, purchased: nil).order(:created_at).last
    @recent_go_orders = Order.where(grouped_order_id: @recent_grouped_order.id) if @recent_grouped_order != nil
    @products_ids = []
    if @recent_go_orders != nil && @recent_go_orders.count > 1
      @recent_go_orders.each do |order|
        @products_ids << order.product.slug
      end
    end
  end

  def check_for_recent
    recent_orders = Order.open_buyer(current_user)
    if recent_orders.count == 0
      false
    elsif recent_orders.count == 1
      true
    else
      true
    end
  end

end
