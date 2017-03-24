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
    @cart_products = Product.where(slug: @cart_ids)
    @products = Product.where(slug: [@cart_ids])
    price_total = @products.sum {|price| price.price}
    shipping_total = @products.sum {|shipping| shipping.shipping}
    @total = price_total + shipping_total
  end

  def create
    @grouped_order = GroupedOrder.new(grouped_order_params)
    @grouped_order.buyer_id = current_user.id
    @cart_ids = $redis.smembers current_user_cart
    @cart_products = Product.where(slug: @cart_ids)
    @products = Product.where(id: [@cart_ids])
    price_total = @products.sum {|price| price.price_in_cents}
    shipping_total = @products.sum {|shipping| shipping.shipping_in_cents}
    @grouped_order.total = price_total + shipping_total
    @grouped_order.save
    respond_to do |format|
      if @grouped_order.save
        @cart_ids.each do |product|
          @product = Product.find_by(slug: product)
          @seller = User.find(@product.user_id)
          @order = Order.new(
            total: @product.price_in_cents + @product.shipping_in_cents,
            product_id: @product.id,
            buyer_id: current_user.id,
            seller_id: @seller.id,
            first_name: @grouped_order.first_name,
            last_name:  @grouped_order.last_name,
            address1: @grouped_order.address1,
            address2: @grouped_order.address2,
            city: @grouped_order.city,
            state: @grouped_order.state,
            zip_code: @grouped_order.zip_code,
            grouped_order_id:@grouped_order.id
          )
          @order.save!
          OrderProduct.create({product_id: @product.id, order_id: @order.id})
        end
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
    @orders = @grouped_order.orders
    @paypal = []
    @stripe = []
    @both = []
    @orders.each do |order|
      @both << order if order.product.accept_stripe? && order.product.accept_paypal?
      @paypal << order if order.product.accept_paypal?
      @stripe << order if order.product.accept_stripe?
    end
    @total_order_count = @orders.count
    @both_count = @both.count
    @paypal_count = @paypal.count
    @stripe_count = @stripe.count
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

  # def order_params
  #   params.require(:order).permit(:address1, :address2, :city, :state, :first_name, :last_name, :zip_code)
  # end

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
