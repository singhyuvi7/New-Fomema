require 'test_helper'

class GroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_group = groups(:one)
  end

  test "should get index" do
    get groups_url
    assert_response :success
  end

  test "should get new" do
    get new_group_url
    assert_response :success
  end

  test "should create group" do
    assert_difference('Group.count') do
      post groups_url, params: { group: { name: @user_group.name, password_policy_id: @user_group.password_policy_id } }
    end

    assert_redirected_to group_url(Group.last)
  end

  test "should show group" do
    get group_url(@user_group)
    assert_response :success
  end

  test "should get edit" do
    get edit_group_url(@user_group)
    assert_response :success
  end

  test "should update group" do
    patch group_url(@user_group), params: { group: { name: @user_group.name, password_policy_id: @user_group.password_policy_id } }
    assert_redirected_to group_url(@user_group)
  end

  test "should destroy group" do
    assert_difference('Group.count', -1) do
      delete group_url(@user_group)
    end

    assert_redirected_to groups_url
  end
end
