require 'test_helper'

class Internal::VisitPlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @internal_visit_plan = internal_visit_plans(:one)
  end

  test "should get index" do
    get internal_visit_plans_url
    assert_response :success
  end

  test "should get new" do
    get new_internal_visit_plan_url
    assert_response :success
  end

  test "should create internal_visit_plan" do
    assert_difference('Internal::VisitPlan.count') do
      post internal_visit_plans_url, params: { internal_visit_plan: {  } }
    end

    assert_redirected_to internal_visit_plan_url(Internal::VisitPlan.last)
  end

  test "should show internal_visit_plan" do
    get internal_visit_plan_url(@internal_visit_plan)
    assert_response :success
  end

  test "should get edit" do
    get edit_internal_visit_plan_url(@internal_visit_plan)
    assert_response :success
  end

  test "should update internal_visit_plan" do
    patch internal_visit_plan_url(@internal_visit_plan), params: { internal_visit_plan: {  } }
    assert_redirected_to internal_visit_plan_url(@internal_visit_plan)
  end

  test "should destroy internal_visit_plan" do
    assert_difference('Internal::VisitPlan.count', -1) do
      delete internal_visit_plan_url(@internal_visit_plan)
    end

    assert_redirected_to internal_visit_plans_url
  end
end
