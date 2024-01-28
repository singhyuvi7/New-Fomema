require "application_system_test_case"

class ReagentsTest < ApplicationSystemTestCase
  setup do
    @reagent = reagents(:one)
  end

  test "visiting the index" do
    visit reagents_url
    assert_selector "h1", text: "Reagents"
  end

  test "creating a Reagent" do
    visit reagents_url
    click_on "New Reagent"

    click_on "Create Reagent"

    assert_text "Reagent was successfully created"
    click_on "Back"
  end

  test "updating a Reagent" do
    visit reagents_url
    click_on "Edit", match: :first

    click_on "Update Reagent"

    assert_text "Reagent was successfully updated"
    click_on "Back"
  end

  test "destroying a Reagent" do
    visit reagents_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Reagent was successfully destroyed"
  end
end
