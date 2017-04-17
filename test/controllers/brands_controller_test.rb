require 'test_helper'

class BrandsControllerTest < ActionDispatch::IntegrationTest

  test "should get freshwater brand Daiwa" do
    get fresh_brands_url("daiwa")
    assert_response :success
  end

  test "should get freshwater brand Dobyns" do
    get fresh_brands_url("dobyns")
    assert_response :success
  end

  test "should get redirected" do
    get fresh_brands_url("penn")
    assert_response :redirect
  end

  test "should get saltware brand Penn" do
    get salt_brands_url("penn")
    assert_response :success
  end

  test "should get saltwater brand Offshore Angler" do
    get salt_brands_url("offshore-angler")
    assert_response :success
  end

end
