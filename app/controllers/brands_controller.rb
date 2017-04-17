class BrandsController < ApplicationController
  before_action :set_brand, only: [:show, :salt, :fresh]

  def index
  end

  def show
  end

  def salt
    if @brand.salt == true
      @products = Product.saltwater_brand(@brand.id)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def fresh
    if @brand.fresh == true
      @products = Product.freshwater_brand(@brand.id)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def set_brand
    @brand = Brand.friendly.find(params[:id])
  end
end
