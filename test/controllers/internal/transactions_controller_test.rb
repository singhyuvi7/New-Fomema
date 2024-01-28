require 'test_helper'

class Internal::TransactionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get internal_transactions_index_url
    assert_response :success
  end

  test "should get show" do
    get internal_transactions_show_url
    assert_response :success
  end

  test "should get new" do
    get internal_transactions_new_url
    assert_response :success
  end

  test "should get create" do
    get internal_transactions_create_url
    assert_response :success
  end

  test "should get edit" do
    get internal_transactions_edit_url
    assert_response :success
  end

  test "should get update" do
    get internal_transactions_update_url
    assert_response :success
  end

end
