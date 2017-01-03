require 'test_helper'

class UserProductsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_products_index_url
    assert_response :success
  end

  test "should get show" do
    get user_products_show_url
    assert_response :success
  end

end
