require 'test_helper'

class Stripe::AccountConnectionControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get stripe_account_connection_index_url
    assert_response :success
  end

end
