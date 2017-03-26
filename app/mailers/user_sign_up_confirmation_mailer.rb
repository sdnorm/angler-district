class UserSignUpConfirmationMailer < Devise::Mailer

  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views

  # def confirmable(user)
  #   @user = user
  #   mg_client = Mailgun::Client.new ENV['mailgun_api_key']
  #   message_params = {:from    => 'sign-up@anglerdistrict.com',
  #                     :to      => @user.email,
  #                     :subject => 'Sample Mail using Mailgun API',
  #                     :text    =>
  #                       "<p>Welcome #{@user.email}</p>
  #                         <p>You can confirm your account email through the link below:</p>
  #                         <p>
  #                         <a href='http://localhost:3000/users/confirmation?confirmation_token=sbFdow_mowhDhVWs4A48'>
  #                           Confirm my account
  #                         </a>
  #                       </p>"
  #                     }
  #   mg_client.send_message ENV['mailgun_domain'], message_params
  # end
end
