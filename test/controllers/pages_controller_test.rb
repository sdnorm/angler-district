require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get about" do
    get pages_about_url
    assert_response :success
  end

  test "should get terms_and_policies" do
    get pages_terms_and_policies_url
    assert_response :success
  end

  test "should get sell_your_tackle" do
    get pages_sell_your_tackle_url
    assert_response :success
  end

end
