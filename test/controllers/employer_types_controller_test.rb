require 'test_helper'

class EmployerTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @employer_type = employer_types(:one)
  end

  test "should get index" do
    get employer_types_url
    assert_response :success
  end

  test "should get new" do
    get new_employer_type_url
    assert_response :success
  end

  test "should create employer_type" do
    assert_difference('EmployerType.count') do
      post employer_types_url, params: { employer_type: { string: @employer_type.string } }
    end

    assert_redirected_to employer_type_url(EmployerType.last)
  end

  test "should show employer_type" do
    get employer_type_url(@employer_type)
    assert_response :success
  end

  test "should get edit" do
    get edit_employer_type_url(@employer_type)
    assert_response :success
  end

  test "should update employer_type" do
    patch employer_type_url(@employer_type), params: { employer_type: { string: @employer_type.string } }
    assert_redirected_to employer_type_url(@employer_type)
  end

  test "should destroy employer_type" do
    assert_difference('EmployerType.count', -1) do
      delete employer_type_url(@employer_type)
    end

    assert_redirected_to employer_types_url
  end
end
