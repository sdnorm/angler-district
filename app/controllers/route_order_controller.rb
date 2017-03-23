class RouteOrderController < ApplicationController

  def route_order
    @cart_ids = $redis.smembers current_user_cart
    @recent_open_order = Order.where(buyer_id: current_user.id, purchased: nil).order(:created_at).last
    product = Product.find(@recent_open_order.product_id) if @recent_open_order != nil
    @recent_grouped_order = GroupedOrder.where(buyer_id: current_user.id, purchased: nil).order(:created_at).last
    @recent_go_orders = Order.where(grouped_order_id: @recent_grouped_order.id) if @recent_grouped_order != nil
    products_ids = []
    if @recent_go_orders != nil && @recent_go_orders.count > 1
      @recent_go_orders.each do |order|
        puts order.product_id
        products_ids << order.product.slug
      end
    end
    if @cart_ids.count == 0
      redirect_to :back, flash[:notice] = "All items were removed from your cart."
    elsif @cart_ids.count == 1 && product != nil && @cart_ids.first == product.slug
      redirect_to complete_order_url(@recent_open_order)
    elsif @cart_ids.count == 1
      redirect_to new_order_url
    elsif @cart_ids.count > 1 && @cart_ids == products_ids
      puts "here"
      redirect_to complete_grouporder_url(@recent_grouped_order)
    else
      redirect_to new_grouped_order_url
    end
  end

end
