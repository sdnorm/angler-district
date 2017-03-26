class RoutePaypalController < ApplicationController

  def index
    @order = Order.find(params[:id])
    product = Product.find(@order.product_id)
    @order.purchased = true
    @order.save
    product.set_inventory_to_zero
    remove_from_cart(product.slug)
    flash[:notice] = "Payment Submitted Successfully!"
    if @order.group_order_id == nil
      redirect_to completed_order_url(@order)
    elsif GroupedOrder.find(@order.group_order_id).orders.orders_left_to_purchase
      redirect_to complete_groupedorder_url(@group_order_id)
    else
      redirect_to completed_groupedorder_url(GroupedOrder.find(@order.group_order_id))
    end
  end

  private

  def remove_from_cart product
    $redis.srem current_user_cart, product
  end

end
