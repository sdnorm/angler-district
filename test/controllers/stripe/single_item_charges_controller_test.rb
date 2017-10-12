require 'test_helper'

class Stripe::SingleItemChargesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get stripe_single_item_charges_create_url
    assert_response :success
  end

end
