class UserProductsController < ApplicationController

  before_action :authenticate_user!

  def index
    @products = Product.user_products(current_user)
  end

end
