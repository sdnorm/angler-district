class OrdersController < ApplicationController
  before_action :set_order, only: [:purchase, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.buyer_orders(current_user)
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @product = Product.find(@order.product_id)
    @total = @product.price
  end

  # GET /orders/new
  def new
    @order = Order.new
    @cart_ids = $redis.smembers current_user_cart
    @product = Product.find(@cart_ids).first
    @seller = User.find(@product.user_id)
    @total = @product.price
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @cart_ids = $redis.smembers current_user_cart
    @product = Product.find(@cart_ids).first
    @seller = User.find(@product.user_id)
    @order.total = @product.price
    @order.product_id = @product.id
    @order.buyer_id = current_user.id
    @order.seller_id = @seller.id
    @order.save
    respond_to do |format|
      if @order.save
        format.html {
          redirect_to action: "purchase", id: @order.id, notice: 'Order was successfully created.'
        }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json {
          render json: @order.errors, status: :unprocessable_entity
        }
      end
    end
  end

  def show
    @orders = Order.charged(current_user.id)
  end

  def purchase

  end

  def submitted_orders
    @orders = Order.charged(current_user.id)
  end

  def charged
    @order = Order.find(params[:id])
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:address1, :address2, :city, :state)
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
