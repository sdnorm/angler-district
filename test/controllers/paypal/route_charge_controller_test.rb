require 'test_helper'

class Paypal::RouteChargeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get paypal_route_charge_index_url
    assert_response :success
  end

end
