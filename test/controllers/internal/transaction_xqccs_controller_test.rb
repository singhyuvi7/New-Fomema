require 'test_helper'

class Internal::TransactionXqccsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @internal_transaction_xqcc = internal_transaction_xqccs(:one)
  end

  test "should get index" do
    get internal_transaction_xqccs_url
    assert_response :success
  end

  test "should get new" do
    get new_internal_transaction_xqcc_url
    assert_response :success
  end

  test "should create internal_transaction_xqcc" do
    assert_difference('Internal::TransactionXqcc.count') do
      post internal_transaction_xqccs_url, params: { internal_transaction_xqcc: {  } }
    end

    assert_redirected_to internal_transaction_xqcc_url(Internal::TransactionXqcc.last)
  end

  test "should show internal_transaction_xqcc" do
    get internal_transaction_xqcc_url(@internal_transaction_xqcc)
    assert_response :success
  end

  test "should get edit" do
    get edit_internal_transaction_xqcc_url(@internal_transaction_xqcc)
    assert_response :success
  end

  test "should update internal_transaction_xqcc" do
    patch internal_transaction_xqcc_url(@internal_transaction_xqcc), params: { internal_transaction_xqcc: {  } }
    assert_redirected_to internal_transaction_xqcc_url(@internal_transaction_xqcc)
  end

  test "should destroy internal_transaction_xqcc" do
    assert_difference('Internal::TransactionXqcc.count', -1) do
      delete internal_transaction_xqcc_url(@internal_transaction_xqcc)
    end

    assert_redirected_to internal_transaction_xqccs_url
  end
end
