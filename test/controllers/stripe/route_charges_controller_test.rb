require 'test_helper'

class Stripe::RouteChargesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get stripe_route_charges_index_url
    assert_response :success
  end

end
