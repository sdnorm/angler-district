class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def stripe_connect
    @user = current_user
    if @user.update_attributes({
      provider: request.env["omniauth.auth"].provider,
      uid: request.env["omniauth.auth"].uid,
      access_code: request.env["omniauth.auth"].credentials.token,
      publishable_key: request.env["omniauth.auth"].info.stripe_publishable_key,
      stripe_user_id: request.env["omniauth.auth"].info.stripe_user_id,
      refresh_token: request.env["omniauth.auth"].info.refresh_token,
      access_token: request.env["omniauth.auth"].info.access_token
    })
      # anything else you need to do in response..
      # sign_in_and_redirect @user, :event => :authentication
      redirect_to user_profile_url
      set_flash_message(:notice, :success, :kind => "Stripe") if is_navigational_format?
    else
      session["devise.stripe_connect_data"] = request.env["omniauth.auth"]
      redirect_to user_profile
    end
  end
end
