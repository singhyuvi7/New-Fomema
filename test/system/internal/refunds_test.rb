require "application_system_test_case"

class Internal::RefundsTest < ApplicationSystemTestCase
  setup do
    @refund = internal_refunds(:one)
  end

  test "visiting the index" do
    visit internal_refunds_url
    assert_selector "h1", text: "Internal/Refunds"
  end

  test "creating a Refund" do
    visit internal_refunds_url
    click_on "New Internal/Refund"

    click_on "Create Refund"

    assert_text "Refund was successfully created"
    click_on "Back"
  end

  test "updating a Refund" do
    visit internal_refunds_url
    click_on "Edit", match: :first

    click_on "Update Refund"

    assert_text "Refund was successfully updated"
    click_on "Back"
  end

  test "destroying a Refund" do
    visit internal_refunds_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Refund was successfully destroyed"
  end
end
