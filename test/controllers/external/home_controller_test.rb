require 'test_helper'

class External::HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get external_home_dashboard_url
    assert_response :success
  end

end
