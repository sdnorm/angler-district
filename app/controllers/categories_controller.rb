class CategoriesController < ApplicationController
  # before_action :set_category, except: [:index]

  def index
  end

  def show
  end

  def reels
    @products = Product.where(category_id: Category.reels.first.id).paginate(:page => params[:page], :per_page => 18)
    @brands = Brand.all
  end

  def rods
    @products = Product.where(category_id: Category.rods.first.id).paginate(:page => params[:page], :per_page => 18)
    @brands = Brand.all
  end

  def fresh_rods
    @products = Product.where(category_id: Category.fresh_rods.first.id).paginate(:page => params[:page], :per_page => 18)
    @brands = Brand.all
  end

  def lures
    @products = Product.where(category_id: Category.lures.first.id).paginate(:page => params[:page], :per_page => 18)
    @brands = Brand.all
  end

  def apparel
    @products = Product.where(category_id: Category.apparel.first.id).paginate(:page => params[:page], :per_page => 18)
    @brands = Brand.all
  end

  def boating
    @products = Product.where(category_id: Category.boating.first.id).paginate(:page => params[:page], :per_page => 18)
    @brands = Brand.all
  end

  def electronics
    @products = Product.where(category_id: Category.electronics.first.id).paginate(:page => params[:page], :per_page => 18)
    @brands = Brand.all
  end

  def generel
    @products = Product.where(category_id: Category.general.first.id).paginate(:page => params[:page], :per_page => 18)
    @brands = Brand.all
  end

  private

  def set_category
    @category = Category.friendly.find(params[:id])
  end

end
