class Paypal::RouteMultiItemController < ApplicationController

  def index
    @grouped_order = GroupedOrder.find(params[:id])
    numnber_of_items = @grouped_order.count
    case numnber_of_items
    when 2
      redirect_to 2_item_order_url(@group_order.id)
    when 3
      redirect_to 3_item_order_url(@group_order.id)
    when 4
      redirect_to 4_item_order_url(@group_order.id)
    when 5
      redirect_to 5_item_order_url(@group_order.id)
    when 6
      redirect_to 6_item_order_url(@group_order.id)
    when 7
      redirect_to 7_item_order_url(@group_order.id)
    when 8
      redirect_to 8_item_order_url(@group_order.id)
    when 9
      redirect_to 9_item_order_url(@group_order.id)
    end
  end

end
