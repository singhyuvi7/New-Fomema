require 'test_helper'

class Internal::StatusSchedulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @status_schedule = status_schedules(:one)
  end

  test "should get index" do
    get internal_status_schedules_url
    assert_response :success
  end

  test "should get new" do
    get new_internal_status_schedule_url
    assert_response :success
  end

  test "should create status_schedule" do
    assert_difference('StatusSchedule.count') do
      post internal_status_schedules_url, params: { status_schedule: {  } }
    end

    assert_redirected_to internal_status_schedule_url(StatusSchedule.last)
  end

  test "should show internal_status_schedule" do
    get internal_status_schedule_url(@status_schedule)
    assert_response :success
  end

  test "should get edit" do
    get edit_internal_status_schedule_url(@status_schedule)
    assert_response :success
  end

  test "should update internal_status_schedule" do
    patch internal_status_schedule_url(@status_schedule), params: { internal_status_schedule: {  } }
    assert_redirected_to internal_status_schedule_url(@status_schedule)
  end

  test "should destroy internal_status_schedule" do
    assert_difference('Internal::StatusSchedule.count', -1) do
      delete internal_status_schedule_url(@status_schedule)
    end

    assert_redirected_to internal_status_schedules_url
  end
end
