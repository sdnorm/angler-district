class Api::V1::ProductsController < ApplicationController
  def index
    @products = Product.all
    json_response(@products)
  end

  def show
  end
end
