require "application_system_test_case"

class AntiSerasTest < ApplicationSystemTestCase
  setup do
    @anti_sera = anti_seras(:one)
  end

  test "visiting the index" do
    visit anti_seras_url
    assert_selector "h1", text: "Anti Seras"
  end

  test "creating a Anti sera" do
    visit anti_seras_url
    click_on "New Anti Sera"

    click_on "Create Anti sera"

    assert_text "Anti sera was successfully created"
    click_on "Back"
  end

  test "updating a Anti sera" do
    visit anti_seras_url
    click_on "Edit", match: :first

    click_on "Update Anti sera"

    assert_text "Anti sera was successfully updated"
    click_on "Back"
  end

  test "destroying a Anti sera" do
    visit anti_seras_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Anti sera was successfully destroyed"
  end
end
