class Stripe::AccountConnectionController < ApplicationController

  before_action :authenticate_user!

  def index
    stripe_state = SecureRandom.hex(11)
    current_user.update_attributes(
      stripe_state: stripe_state
    )
    parameters = {
      client_id: ENV['STRIPE_CONNECT_CLIENT_ID'],
      state: stripe_state,
      # redirect_uri: ,
      first_name: current_user.first_name,
      last_name: current_user.last_name,
      email: current_user.email
    }
    stringed_parameters = parameters.map{|k,v| "#{k}=#{v}"}.join('&')
    redirect_to "https://connect.stripe.com/express/oauth/authorize?#{stringed_parameters}"
  end

  # curl https://connect.stripe.com/oauth/token \
  #  -d client_secret=sk_test_qhsT5eS9RheR5oIBkldMSveY \
  #  -d code=ac_BdbIsd4Yru1f2BJTrndpyJgrAyZcrhFP \
  #  -d grant_type=authorization_code

  def confirmation
    # Check the state we got back equals the one we generated before proceeding.
    if params[:state] =! current_user.stripe_state
      redirect_to user_profile_url, notice: "Something went wrong, please start the process of creating or connecting your account again."
    else
      endpoint = ENV['stripe_token_uri']
      data = {
        client_secret: ENV['STRIPE_SECRET_KEY'],
        code: params[:code],
        grant_type: 'authorization_code'
      }
      response = HTTParty.post(
        endpoint,
        body: data.to_json,
        headers: { "Content-Type" => 'application/json' }
      )
      if response.parsed_response["error"] == "invalid_grant"
        redirect_to user_profile_url, notice: "Please try creating/connecting your account again, something went wrong."
      else
        current_user.update_attributes(
          publishable_key: response.parsed_response["stripe_publishable_key"],
          stripe_user_id: response.parsed_response["stripe_user_id"]
        )
        redirect_to user_profile_url, notice: "You are ready to accept credit cards and Apple Pay/Google Pay!"
      end
    end
  end

end
