class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [
    :new, :create, :edit, :update, :destroy
  ]
  before_action :check_user, only: [:edit, :update, :destroy]

  include FindRelatedItems

  # GET /products
  # GET /products.json
  def index
    if params[:search_text].present?
      @products = Product.search(params[:search_text]).ordered_and_instock.paginate(:page => params[:page], :per_page => 18)
    else
      @products = Product.ordered_and_instock.paginate(:page => params[:page], :per_page => 12)
    end
    # @products = Product.ordered_and_instock
    @brands = Brand.all
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @cart_ids = $redis.smembers current_user_cart
    @cart_action = @product.cart_action current_user.try :id
    seller = User.find(@product.user_id)
    @seller = seller
    if seller.ratings.count > 0
      @reputation = seller.average_rating
    else
      @reputation = "No ratings yet"
    end
    @cart_products = Product.where(slug: @cart_ids)
    @related_products = find_related_items(@product)
  end

  # GET /products/new
  def new
    if check_payment
      # puts "here"
      flash[:notice] = 'Please provide a method to accept payments for the sale of your product before creating a listing. Thanks!'
      redirect_back fallback_location: all_user_products_url
    else
      @product = Product.new
      @categories = Category.all
    end
  end

  # GET /products/1/edit
  def edit
    @categories = Category.all
  end

  # POST /products
  # POST /products.json
  def create
    @categories = Category.all
    @product = Product.new(product_params)
    @product.user_id = current_user.id
    if check_payment
      # puts "here"
      flash[:notice] = 'Please provide a method to accept payments for the sale of your product before creating a listing. Thanks!'
      render :new
    else
      respond_to do |format|
        if @product.save
          format.html {
            redirect_to @product, notice: 'Product was successfully created.'
          }
          format.json { render :show, status: :created, location: @product }
        else
          format.html { render :new }
          format.json {
            render json: @product.errors, status: :unprocessable_entity
          }
        end
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    # @product.price = params[:product][:price] * 100 if params[:product][:price]
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html {
        redirect_to products_url, notice: 'Product was successfully destroyed.'
      }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(
        :name,
        :description,
        :price,
        :shipping,
        :display_image,
        :image,
        :image2,
        :image3,
        :image4,
        :category_id,
        :condition,
        :quantity
      )
    end

    def check_user
      if current_user != @product.user
        redirect_to root_url, alert: "Sorry, this product belongs to someone else"
      end
    end

    def check_payment
      @user = User.find(current_user.id)
      # puts "---- paypal email ----" if @user.paypal_email == nil
      # puts @user.paypal_email
      if @user.paypal_email == nil && @user.paypal_email_the_same == false && @user.stripe_user_id == nil
        # puts "what the hell"
        true
      else
        false
      end
    end

end
