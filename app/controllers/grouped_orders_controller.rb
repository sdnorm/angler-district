class GroupedOrdersController < ApplicationController
  before_action :set_grouped_order, only: [:purchase, :show, :edit, :update, :destroy, :confirm]
  before_action :authenticate_user!, only: [
    :new, :create, :edit, :update, :destroy
  ]
  # before_action :check_user, only: [:edit, :update, :destroy]

  def index
    @grouped_orders = GroupedOrder.buyer_gps(current_user.id)
  end

  def new
    @grouped_order = GroupedOrder.new
    @cart_ids = $redis.smembers current_user_cart
    @products = Product.where(slug: [@cart_ids])
    @total = @products.sum {|price| price.price}
  end

  def create
    @grouped_order = GroupedOrder.new(grouped_order_params)
    @grouped_order.buyer_id = current_user.id
    @cart_ids = $redis.smembers current_user_cart
    @products = Product.where(id: [@cart_ids])
    @grouped_order.total = @products.sum {|price| price.price}
    @cart_ids.each do |product|
      @order = Order.new
      @product = Product.find(product)
      @seller = User.find(@product.user_id)
      @order.total = @product.price
      @order.product_id = @product.id
      @order.buyer_id = current_user.id
      @order.seller_id = @seller.id
      @order.first_name = @grouped_order.first_name
      @order.last_name = @grouped_order.last_name
      @order.address1 = @grouped_order.address1
      @order.address2 = @grouped_order.address2
      @order.city = @grouped_order.city
      @order.state = @grouped_order.state
      @order.zip_code = @grouped_order.zip_code
      @order.save
    end
    respond_to do |format|
      if @grouped_order.save
        format.html {
          redirect_to action: "purchase", id: @grouped_order.id, notice: 'Order was successfully created.'
        }
        format.json { render :purchase, status: :created, location: @grouped_order }
      else
        format.html { render :new }
        format.json {
          render json: @grouped_order.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def purchase

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
        format.html { redirect_to action: "purchase", id: @grouped_order.id }
        format.json { render :purchase, status: :ok, location: @grouped_order }
      else
        format.html { render :edit }
        format.json { render json: @grouped_order.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_grouped_order
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
      :state,
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
