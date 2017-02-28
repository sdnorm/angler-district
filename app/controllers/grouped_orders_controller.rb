class GroupedOrdersController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :confirm]
  before_action :authenticate_user!, only: [
    :new, :create, :edit, :update, :destroy
  ]
  # before_action :check_user, only: [:edit, :update, :destroy]

  def index
    @grouped_orders = GroupedOrder.buyer_gps(current_user.id)
  end

  def new
    @grouped_order = GroupedOrder.create
    @cart_ids = $redis.smembers current_user_cart
    cart_id = @cart_ids
    @product = Product.find(cart_id).first
    # @seller = User.find(@product.user_id)
    # @order.product_id = @product.id
    # @order.buyer_id = current_user.id
    # @order.seller_id = @seller.id
    @total = @product.price
    # @order.grouped_orders_id = @grouped_order.id
    # @product.grouped_orders_id = @grouped_order.id
    # @order.save
  end

  def confirm
    @cart_ids = $redis.smembers current_user_cart
    cart_id = @cart_ids
    @product = Product.find(cart_id).first
    # @seller = User.find(@product.user_id)
    # @order.product_id = @product.id
    # @order.buyer_id = current_user.id
    # @order.seller_id = @seller.id
    @total = @product.price
  end

  def show

  end

  def update
    respond_to do |format|
      if @grouped_order.update(grouped_order_params)
        format.html { redirect_to @grouped_order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @grouped_order }
      else
        format.html { render :edit }
        format.json { render json: @grouped_order.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @grouped_order = GroupedOrder.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def grouped_order_params
    params.require(:grouped_order).permit(
      :first_name,
      :last_name,
      :address1,
      :address2,
      :city,
      :zip_code,
      :buyer_id
    )
  end

  def current_user_cart
    "cart#{current_user.id}"
  end

  def remove_from_cart product_id
    $redis.srem current_user_cart, product_id
  end

  def current_user_cart
    "cart#{current_user.id}"
  end


end
