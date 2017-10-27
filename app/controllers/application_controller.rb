class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include Response
  include ExceptionHandler

  def current_user_cart
    "cart#{current_user.id}"
  end

  def remove_from_cart product_id
    $redis.srem current_user_cart, product_id
  end

  def current_user_cart
    "cart#{current_user.id}"
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def resource_class
    User
  end

  helper_method :resource, :resource_name, :devise_mapping, :resource_class

end
