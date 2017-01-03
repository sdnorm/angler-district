class UserProductsController < ApplicationController

  before_filter :authenticate_user!

  def index
    @products = Product.user_products(current_user)
  end

end
