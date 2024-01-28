require 'test_helper'

class Internal::RefundsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @refund = internal_refunds(:one)
  end

  test "should get index" do
    get internal_refunds_url
    assert_response :success
  end

  test "should get new" do
    get new_internal_refund_url
    assert_response :success
  end

  test "should create internal_refund" do
    assert_difference('Internal::Refund.count') do
      post internal_refunds_url, params: { internal_refund: {  } }
    end

    assert_redirected_to internal_refund_url(Internal::Refund.last)
  end

  test "should show internal_refund" do
    get internal_refund_url(@refund)
    assert_response :success
  end

  test "should get edit" do
    get edit_internal_refund_url(@refund)
    assert_response :success
  end

  test "should update internal_refund" do
    patch internal_refund_url(@refund), params: { internal_refund: {  } }
    assert_redirected_to internal_refund_url(@refund)
  end

  test "should destroy internal_refund" do
    assert_difference('Internal::Refund.count', -1) do
      delete internal_refund_url(@refund)
    end

    assert_redirected_to internal_refunds_url
  end
end
