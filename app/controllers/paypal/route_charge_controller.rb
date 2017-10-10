class Paypal::RouteChargeController < ApplicationController

  def index
    @cart_ids = $redis.smembers current_user_cart
    case @cart_ids.count
    when 0
      redirect_back fallback_location: cart_url, notice: "All items were removed from your cart."
    when 1
      redirect_to paypal_url(params[:id])
    else
      redirect_to paypals_url(params[:id])
    end
  end

end
