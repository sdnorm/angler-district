class Paypal::RouteMultiItemController < ApplicationController

  def index
    @grouped_order = GroupedOrder.includes(:orders).where(orders: {payment_method: "paypal"}).find(params[:id])
    # @grouped_order = g_o
    # paypal_orders = PaypalOrders.run(@grouped_order)
    if @grouped_order.orders.count > 0#PaypalOrderChecker.run(@grouped_order)
      number_of_items = @grouped_order.orders.count
      case number_of_items
      when 2
        redirect_to two_item_paypal_order_url(@grouped_order.id)
      when 3
        redirect_to three_item_paypal_order_url(@grouped_order.id)
      when 4
        redirect_to four_item_paypal_order_url(@grouped_order.id)
      when 5
        redirect_to five_item_paypal_order_url(@grouped_order.id)
      when 6
        redirect_to six_item_paypal_order_url(@grouped_order.id)
      when 7
        redirect_to seven_item_paypal_order_url(@grouped_order.id)
      when 8
        redirect_to eight_item_paypal_order_url(@grouped_order.id)
      when 9
        redirect_to nine_item_paypal_order_url(@grouped_order.id)
      else
        redirect_to more_than_9_items_paypal_order_url(@grouped_order.id)
      end
    else
      @grouped_order.GroupedOrder.includes(:orders).find(params[:id])
      if @grouped_order.orders.count > 1
        redirect_to complete_grouporder_url(@grouped_order)
      elsif @grouped_order.orders.count == 1
        redirect_to complete_order_url(@grouped_order)
      else
        redirect_to root_url
      end
    end
  end

  def show
    @order = GroupedOrder.find(params[:id])
    details = Order.get_paypal_details(params[:token])
    @order.orders.update_all(
      express_token: params[:token],
      express_payer_id: details["PAYERID"],
      paypal_first_name: details["FIRSTNAME"],
      paypal_last_name: details["LASTNAME"],
      purchased: true,
      purchased_at: Time.now
    )
    @order.orders.each do |order|
      order.product.set_inventory_to_zero
      remove_from_cart(order.product.slug)
    end
    flash[:notice] = "Payment Submitted Successfully!"
    redirect_to completed_groupedorder_url(GroupedOrder.find(@order.group_order_id))
  end

end
