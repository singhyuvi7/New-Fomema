require 'test_helper'

class Internal::XqccsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @internal_xqcc = internal_xqccs(:one)
  end

  test "should get index" do
    get internal_xqccs_url
    assert_response :success
  end

  test "should get new" do
    get new_internal_xqcc_url
    assert_response :success
  end

  test "should create internal_xqcc" do
    assert_difference('Internal::Xqcc.count') do
      post internal_xqccs_url, params: { internal_xqcc: {  } }
    end

    assert_redirected_to internal_xqcc_url(Internal::Xqcc.last)
  end

  test "should show internal_xqcc" do
    get internal_xqcc_url(@internal_xqcc)
    assert_response :success
  end

  test "should get edit" do
    get edit_internal_xqcc_url(@internal_xqcc)
    assert_response :success
  end

  test "should update internal_xqcc" do
    patch internal_xqcc_url(@internal_xqcc), params: { internal_xqcc: {  } }
    assert_redirected_to internal_xqcc_url(@internal_xqcc)
  end

  test "should destroy internal_xqcc" do
    assert_difference('Internal::Xqcc.count', -1) do
      delete internal_xqcc_url(@internal_xqcc)
    end

    assert_redirected_to internal_xqccs_url
  end
end
