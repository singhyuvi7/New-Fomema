require 'test_helper'

class External::OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get external_orders_index_url
    assert_response :success
  end

  test "should get show" do
    get external_orders_show_url
    assert_response :success
  end

  test "should get new" do
    get external_orders_new_url
    assert_response :success
  end

  test "should get create" do
    get external_orders_create_url
    assert_response :success
  end

  test "should get edit" do
    get external_orders_edit_url
    assert_response :success
  end

  test "should get update" do
    get external_orders_update_url
    assert_response :success
  end

  test "should get destroy" do
    get external_orders_destroy_url
    assert_response :success
  end

end
