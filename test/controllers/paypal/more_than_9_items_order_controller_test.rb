require 'test_helper'

class Paypal::MoreThan9ItemsOrderControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get paypal_more_than_9_items_order_index_url
    assert_response :success
  end

  test "should get show" do
    get paypal_more_than_9_items_order_show_url
    assert_response :success
  end

end
