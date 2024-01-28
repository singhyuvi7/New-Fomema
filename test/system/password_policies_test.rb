require "application_system_test_case"

class PasswordPoliciesTest < ApplicationSystemTestCase
  setup do
    @password_policy = password_policies(:one)
  end

  test "visiting the index" do
    visit password_policies_url
    assert_selector "h1", text: "Password Policies"
  end

  test "creating a Password policy" do
    visit password_policies_url
    click_on "New Password Policy"

    fill_in "Block Previous Password", with: @password_policy.block_previous_password
    fill_in "Minimum Length", with: @password_policy.minimum_length
    fill_in "Name", with: @password_policy.name
    fill_in "Password Expiry", with: @password_policy.password_expiry
    fill_in "Require Alphabet", with: @password_policy.require_alphabet
    fill_in "Require Numeric", with: @password_policy.require_numeric
    fill_in "Require Small And Capital", with: @password_policy.require_small_and_capital
    click_on "Create Password policy"

    assert_text "Password policy was successfully created"
    click_on "Back"
  end

  test "updating a Password policy" do
    visit password_policies_url
    click_on "Edit", match: :first

    fill_in "Block Previous Password", with: @password_policy.block_previous_password
    fill_in "Minimum Length", with: @password_policy.minimum_length
    fill_in "Name", with: @password_policy.name
    fill_in "Password Expiry", with: @password_policy.password_expiry
    fill_in "Require Alphabet", with: @password_policy.require_alphabet
    fill_in "Require Numeric", with: @password_policy.require_numeric
    fill_in "Require Small And Capital", with: @password_policy.require_small_and_capital
    click_on "Update Password policy"

    assert_text "Password policy was successfully updated"
    click_on "Back"
  end

  test "destroying a Password policy" do
    visit password_policies_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Password policy was successfully destroyed"
  end
end
