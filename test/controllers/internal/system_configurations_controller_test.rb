require 'test_helper'

class Internal::SystemConfigurationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get internal_system_configurations_index_url
    assert_response :success
  end

  test "should get edit" do
    get internal_system_configurations_edit_url
    assert_response :success
  end

end
