require 'test_helper'

class External::ForeignWorkersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get external_foreign_workers_index_url
    assert_response :success
  end

  test "should get show" do
    get external_foreign_workers_show_url
    assert_response :success
  end

  test "should get new" do
    get external_foreign_workers_new_url
    assert_response :success
  end

  test "should get create" do
    get external_foreign_workers_create_url
    assert_response :success
  end

  test "should get edit" do
    get external_foreign_workers_edit_url
    assert_response :success
  end

  test "should get update" do
    get external_foreign_workers_update_url
    assert_response :success
  end

  test "should get destroy" do
    get external_foreign_workers_destroy_url
    assert_response :success
  end

end
