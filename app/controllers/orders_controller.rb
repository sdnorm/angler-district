class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.buyer_orders(current_user)
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    # cart_ids = $redis.smembers current_user_cart
    # @cart_products = Product.find(cart_ids)
    @product = Product.find(@order.product_id)
    @cart_ids = $redis.smembers current_user_cart
    if @cart_ids.count == 1
      @product = Product.find(@cart_ids).first
      @total = @product.amount
    else
      adding_totals = 0
      @cart_ids.each do |id|
        @product = Product.find(id)
        adding_totals += @product.amount
      end
      @total = adding_totals
    end
  end

  # GET /orders/new
  def new
    @cart_ids = $redis.smembers current_user_cart
    @grouped_order = GroupedOrder.create
    if @cart_ids.count == 1
      @order = Order.new
      # @grouped_order = GroupedOrder.create
      @product = Product.find(@cart_ids).first
      @seller = User.find(@product.user_id)
      @order.product_id = @product.id
      @order.buyer_id = current_user.id
      @order.seller_id = @seller.id
      @total = @product.amount
      @order.grouped_orders_id = @grouped_order.id
      @product.grouped_orders_id = @grouped_order.id
      @order.save
      # @product.order_product = @order.id
    else
      @cart_ids.each do |id|
        @order = Order.new
        @product = Product.find(id)
        @seller = @product.user
        @order.product_id = @product.id
        @order.buyer_id = current_user.id
        @order.seller_id = @seller.id
        @order.grouped_orders_id = @grouped_order.id
        @product.grouped_orders_id = @grouped_order.id
        @order.save
        # @product.order_product = @order.id
      end
    end
    # @product = Product.find(params[:product_id])
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    # @cart_ids = $redis.smembers current_user_cart
    # check to make sure the item is still in stock before all of this
    # only process items that are in stock
    # process payment
    # if success do the below
    # if not do not create the order(s)
    # redirect back to cart page with message of what happened

    #######################
    # @api = PayPal::SDK::AdaptivePayments.new
    # puts "right here --------"
    # puts "------------ paypal api #{@api.inspect}"
    # # Build request object
    # @pay = @api.build_pay({
    #   :actionType => "PAY",
    #   :cancelUrl => "http://localhost:3000/paypal/failure",
    #   :currencyCode => "USD",
    #   :feesPayer => "SENDER",
    #   :ipnNotificationUrl => "http://localhost:3000/paypal/ipn",
    #   :receiverList => {
    #     :receiver => [
    #       {
    #         :amount => 1.0,
    #         :email => "spencerdnorman-facilitator@gmail.com"
    #       }
    #     ]
    #   },
    #   :returnUrl => "http://localhost:3000/paypal/success" })
    #
    # # Make API call & get response
    # @response = @api.pay(@pay)
    # puts "---- PayPal response ---- #{@response.inspect}"
    # puts "---- bitches"
    #
    # # Access response
    # if @response.success? && @response.payment_exec_status != "ERROR"
    #   @response.payKey
    #   puts "----------"
    #   puts @response.payKey
    #   puts @api.payment_url(@response)
    #   puts "----------"
    #   @api.payment_url(@response)  # Url to complete payment
    # else
    #   puts "erroring - - - - - - "
    #   puts @response.error[0].message
    #   puts "- - - - - - - - "
    # end
    # #######################
    #
    # if @cart_ids.count == 1
    #   @order = Order.new(order_params)
    #   @product = Product.find(@cart_ids).first
    #   @seller = User.find(@product.user_id)
    #   @order.product_id = @product.id
    #   @order.buyer_id = current_user.id
    #   @order.seller_id = @seller.id
    #   @order.save
    #   if @order.save
    #     @product.set_inventory_to_zero
    #   end
    #   remove_from_cart @product.id
    # else
    #   @cart_ids.each do |id|
    #     @order = Order.new(order_params)
    #     @product = Product.find(id)
    #     @seller = @product.user
    #     @order.product_id = @product.id
    #     @order.buyer_id = current_user.id
    #     @order.seller_id = @seller.id
    #     @order.save
    #     if @order.save
    #       @product.set_inventory_to_zero
    #     end
    #     remove_from_cart @product.id
    #   end
    # end

    # respond_to do |format|
    #   if @order.save
    #     format.html { redirect_to @order, notice: 'Order was successfully created.' }
    #     format.json { render :show, status: :created, location: @order }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @order.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  def purchase

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
      params.require(:order).permit(:address, :city, :state)
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
