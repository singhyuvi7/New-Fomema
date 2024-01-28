require "application_system_test_case"

class TcupiTodosTest < ApplicationSystemTestCase
  setup do
    @tcupi_todo = tcupi_todos(:one)
  end

  test "visiting the index" do
    visit tcupi_todos_url
    assert_selector "h1", text: "Tcupi Todos"
  end

  test "creating a Tcupi todo" do
    visit tcupi_todos_url
    click_on "New Tcupi Todo"

    fill_in "Name", with: @tcupi_todo.name
    click_on "Create Tcupi todo"

    assert_text "Tcupi todo was successfully created"
    click_on "Back"
  end

  test "updating a Tcupi todo" do
    visit tcupi_todos_url
    click_on "Edit", match: :first

    fill_in "Name", with: @tcupi_todo.name
    click_on "Update Tcupi todo"

    assert_text "Tcupi todo was successfully updated"
    click_on "Back"
  end

  test "destroying a Tcupi todo" do
    visit tcupi_todos_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tcupi todo was successfully destroyed"
  end
end
