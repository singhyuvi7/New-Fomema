require "application_system_test_case"

class Internal::XqccsTest < ApplicationSystemTestCase
  setup do
    @internal_xqcc = internal_xqccs(:one)
  end

  test "visiting the index" do
    visit internal_xqccs_url
    assert_selector "h1", text: "Internal/Xqccs"
  end

  test "creating a Xqcc" do
    visit internal_xqccs_url
    click_on "New Internal/Xqcc"

    click_on "Create Xqcc"

    assert_text "Xqcc was successfully created"
    click_on "Back"
  end

  test "updating a Xqcc" do
    visit internal_xqccs_url
    click_on "Edit", match: :first

    click_on "Update Xqcc"

    assert_text "Xqcc was successfully updated"
    click_on "Back"
  end

  test "destroying a Xqcc" do
    visit internal_xqccs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Xqcc was successfully destroyed"
  end
end
