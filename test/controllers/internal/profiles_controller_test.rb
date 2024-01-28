require 'test_helper'

class Internal::ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "should get profile" do
    get internal_profiles_profile_url
    assert_response :success
  end

  test "should get password" do
    get internal_profiles_password_url
    assert_response :success
  end

end
