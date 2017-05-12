require 'test_helper'

class HandleStripeGroupOrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get handle_stripe_group_orders_index_url
    assert_response :success
  end

end
