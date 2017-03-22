class CartsController < ApplicationController

  before_action :authenticate_user!

  def show
    @cart_ids = $redis.smembers current_user_cart
    # check for product inventory amount, disable if 0
    # @pre_cart_products =
    @cart_products = Product.where(slug: @cart_ids)
    @total = @cart_products.sum { |product| product.price }
    # @disabled_cart_products =
    # @cart_action = @cart_products.cart_action
  end

  def add
    $redis.sadd current_user_cart, params[:product_id]
    render json: current_user.cart_count, status: 200
  end

  def remove
    $redis.srem current_user_cart, params[:product_id]
    render json: current_user.cart_count, status: 200
  end

  private

  def current_user_cart
    "cart#{current_user.id}"
  end

end
