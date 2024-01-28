require "application_system_test_case"

class AppealTodosTest < ApplicationSystemTestCase
  setup do
    @appeal_todo = appeal_todos(:one)
  end

  test "visiting the index" do
    visit appeal_todos_url
    assert_selector "h1", text: "Appeal Todos"
  end

  test "creating a Appeal todo" do
    visit appeal_todos_url
    click_on "New Appeal Todo"

    fill_in "Name", with: @appeal_todo.name
    click_on "Create Appeal todo"

    assert_text "Appeal todo was successfully created"
    click_on "Back"
  end

  test "updating a Appeal todo" do
    visit appeal_todos_url
    click_on "Edit", match: :first

    fill_in "Name", with: @appeal_todo.name
    click_on "Update Appeal todo"

    assert_text "Appeal todo was successfully updated"
    click_on "Back"
  end

  test "destroying a Appeal todo" do
    visit appeal_todos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Appeal todo was successfully destroyed"
  end
end
