require 'test_helper'

class Stripe::MultiItemChargesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get stripe_multi_item_charges_create_url
    assert_response :success
  end

end
