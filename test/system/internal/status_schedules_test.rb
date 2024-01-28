require "application_system_test_case"

class Internal::StatusSchedulesTest < ApplicationSystemTestCase
  setup do
    @status_schedule = internal_status_schedules(:one)
  end

  test "visiting the index" do
    visit internal_status_schedules_url
    assert_selector "h1", text: "Internal/Status Schedules"
  end

  test "creating a Status schedule" do
    visit internal_status_schedules_url
    click_on "New Internal/Status Schedule"

    click_on "Create Status schedule"

    assert_text "Status schedule was successfully created"
    click_on "Back"
  end

  test "updating a Status schedule" do
    visit internal_status_schedules_url
    click_on "Edit", match: :first

    click_on "Update Status schedule"

    assert_text "Status schedule was successfully updated"
    click_on "Back"
  end

  test "destroying a Status schedule" do
    visit internal_status_schedules_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Status schedule was successfully destroyed"
  end
end
