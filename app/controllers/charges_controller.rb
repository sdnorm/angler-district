class ChargesController < ApplicationController
  def new
  end

  def create
    # Find the user to pay.
    user = User.find( params[:id] )
    # Charge $10.
    amount = 1000
    # Calculate the fee amount that goes to the application.
    fee = (amount.to_i * ENV["NORMAL_FEE_PERCENTAGE"].to_i)
    if params[:stripeEmail].present? && params[:stripeToken].present?
      customer = Stripe::Customer.create(
        :email => params[:stripeEmail],
        :source  => params[:stripeToken]
      )
      begin
        charge_attrs = {
          customer: customer.id,
          amount: amount,
          currency: user.currency,
          source: params[:token],
          description: "Test Charge via Stripe Connect",
          application_fee: fee
        }
        # Use the user-to-be-paid's access token
        # to make the charge directly on their account
        charge = Stripe::Charge.create( charge_attrs, user.secret_key )
        flash[:notice] = "Charged successfully! <a target='_blank' rel='#{params[:charge_on]}-account' href='https://dashboard.stripe.com/test/payments/#{charge.id}'>View in dashboard &raquo;</a>"
      rescue Stripe::CardError => e
        error = e.json_body[:error][:message]
        flash[:error] = "Charge failed! #{error}"
      end
    else
      begin
        charge_attrs = {
          amount: amount,
          currency: user.currency,
          source: params[:token],
          description: "Test Charge via Stripe Connect",
          application_fee: fee
        }
        # Use the user-to-be-paid's access token
        # to make the charge directly on their account
        charge = Stripe::Charge.create( charge_attrs, user.secret_key )
        flash[:notice] = "Charged successfully! <a target='_blank' rel='#{params[:charge_on]}-account' href='https://dashboard.stripe.com/test/payments/#{charge.id}'>View in dashboard &raquo;</a>"
      rescue Stripe::CardError => e
        error = e.json_body[:error][:message]
        flash[:error] = "Charge failed! #{error}"
      end
    end
    redirect_to user_path( user )
  end
end
