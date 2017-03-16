class UserProfilesController < ApplicationController
  # before_action :authenticate_user!, only: [:show]

  # before_action :set_user, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_user!, only: [
    :show, :edit, :update, :destroy
  ]

  def index
    @user = User.friendly.find(params[:id])
  end

  def show
    @user = current_user
  end

  def edit
    @user = current_user
    # @user_profile = User.where(profile_name: @user.profile_name)
  end

  def update
    @user = current_user
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to :back, notice: 'User Profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'User Profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      if current_user.profile_name == params[:id]
        @user = current_user
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(
        :email,
        :profile_name,
        :first_name,
        :last_name,
        :address1,
        :address2,
        :city,
        :state,
        :zip_code
      )
    end

end
