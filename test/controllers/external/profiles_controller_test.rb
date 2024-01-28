require 'test_helper'

class External::ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "should get profile" do
    get external_profiles_profile_url
    assert_response :success
  end

  test "should get password" do
    get external_profiles_password_url
    assert_response :success
  end

end
