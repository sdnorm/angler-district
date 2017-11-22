class ToShipOrderController < ApplicationController

  before_action :authenticate_user!
  before_action :set_order, only: [:show, :edit, :update]
  before_action :authorize_seller, only: :show

  def index
    @title = "Things I need to ship"
    @orders = Order.to_ship(current_user)
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Tracking number was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def order_params
    params.require(:order).permit(
      :tracking_number,
      :carrier
    )
  end

  def set_order
    @order = Order.find(params[:id])
  end

end
