class BrandsController < ApplicationController
  before_action :set_brand, only: [:show, :salt, :fresh]

  def index
  end

  def show
  end

  def salt

  end

  def fresh
    @products = Product.freshwater_brand(@brand.id)
  end

  private

  def set_brand
    @brand = Brand.friendly.find(params[:id])
  end
end
