require 'test_helper'

class PasswordPoliciesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @password_policy = password_policies(:one)
  end

  test "should get index" do
    get password_policies_url
    assert_response :success
  end

  test "should get new" do
    get new_password_policy_url
    assert_response :success
  end

  test "should create password_policy" do
    assert_difference('PasswordPolicy.count') do
      post password_policies_url, params: { password_policy: { block_previous_password: @password_policy.block_previous_password, minimum_length: @password_policy.minimum_length, name: @password_policy.name, password_expiry: @password_policy.password_expiry, require_alphabet: @password_policy.require_alphabet, require_numeric: @password_policy.require_numeric, require_small_and_capital: @password_policy.require_small_and_capital } }
    end

    assert_redirected_to password_policy_url(PasswordPolicy.last)
  end

  test "should show password_policy" do
    get password_policy_url(@password_policy)
    assert_response :success
  end

  test "should get edit" do
    get edit_password_policy_url(@password_policy)
    assert_response :success
  end

  test "should update password_policy" do
    patch password_policy_url(@password_policy), params: { password_policy: { block_previous_password: @password_policy.block_previous_password, minimum_length: @password_policy.minimum_length, name: @password_policy.name, password_expiry: @password_policy.password_expiry, require_alphabet: @password_policy.require_alphabet, require_numeric: @password_policy.require_numeric, require_small_and_capital: @password_policy.require_small_and_capital } }
    assert_redirected_to password_policy_url(@password_policy)
  end

  test "should destroy password_policy" do
    assert_difference('PasswordPolicy.count', -1) do
      delete password_policy_url(@password_policy)
    end

    assert_redirected_to password_policies_url
  end
end
