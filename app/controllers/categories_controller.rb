class CategoriesController < ApplicationController
  # before_action :set_category, except: [:index]

  def index
  end

  def show
  end

  def reels
    @products = Category.where(name: "Reels").includes(:products)
  end

  def rods
    @products = Category.rods
  end

  def fresh_rods
    @products = Category.fresh_rods
  end

  def lures
    @products = Category.lures
  end

  def apparel
    @products = Category.apparel
  end

  def boating
    @products = Category.boating
  end

  def electronics
    @products = Category.electronics
  end

  def genrel
    @products = Category.general
  end

  private

  def set_category
    @category = Category.friendly.find(params[:id])
  end

end
