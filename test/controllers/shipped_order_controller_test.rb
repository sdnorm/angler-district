require 'test_helper'

class ShippedOrderControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get shipped_order_index_url
    assert_response :success
  end

  test "should get show" do
    get shipped_order_show_url
    assert_response :success
  end

end
