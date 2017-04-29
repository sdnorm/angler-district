require 'test_helper'

class ToShipOrderControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get to_ship_order_index_url
    assert_response :success
  end

  test "should get show" do
    get to_ship_order_show_url
    assert_response :success
  end

end
