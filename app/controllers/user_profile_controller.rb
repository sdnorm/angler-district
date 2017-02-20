class UserProfileController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  def index
    @user = User.friendly.find(params[:id])
  end

  def show
    @user = current_user
  end
end
