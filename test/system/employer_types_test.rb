require "application_system_test_case"

class EmployerTypesTest < ApplicationSystemTestCase
  setup do
    @employer_type = employer_types(:one)
  end

  test "visiting the index" do
    visit employer_types_url
    assert_selector "h1", text: "Employer Types"
  end

  test "creating a Employer type" do
    visit employer_types_url
    click_on "New Employer Type"

    fill_in "String", with: @employer_type.string
    click_on "Create Employer type"

    assert_text "Employer type was successfully created"
    click_on "Back"
  end

  test "updating a Employer type" do
    visit employer_types_url
    click_on "Edit", match: :first

    fill_in "String", with: @employer_type.string
    click_on "Update Employer type"

    assert_text "Employer type was successfully updated"
    click_on "Back"
  end

  test "destroying a Employer type" do
    visit employer_types_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Employer type was successfully destroyed"
  end
end
