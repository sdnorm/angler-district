require 'test_helper'

class Paypal::SingleItemOrderControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get paypal_single_item_order_index_url
    assert_response :success
  end

end
