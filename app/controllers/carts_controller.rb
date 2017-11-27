class CartsController < ApplicationController

  before_action :authenticate_user!

  include FindRelatedItems

  def show
    @cart_ids = $redis.smembers current_user_cart
    # check for product inventory amount, disable if 0
    # @pre_cart_products =
    @cart_products = Product.where(slug: @cart_ids)
    @product_total = @cart_products.sum { |product| product.price }
    @shipping_total = @cart_products.sum { |product| product.shipping }
    @total = @product_total + @shipping_total
    # @disabled_cart_products =
    # @cart_action = @cart_products.cart_action
    @related_products = find_related_items(@cart_products)
  end

  def add
    $redis.sadd current_user_cart, params[:product_id]
    render json: current_user.cart_count, status: 200
  end

  def remove
    $redis.srem current_user_cart, params[:product_id]
    render json: current_user.cart_count, status: 200
  end

  def get_cart_total
    @cart_ids = $redis.smembers current_user_cart
    @cart_products = Product.where(slug: @cart_ids)
    @total = @cart_products.sum { |product| product.price }
    render json: @total, status: 200
  end

  private

  def current_user_cart
    "cart#{current_user.id}"
  end

end
