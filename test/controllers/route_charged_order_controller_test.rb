require 'test_helper'

class RouteChargedOrderControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get route_charged_order_index_url
    assert_response :success
  end

end
