require 'test_helper'

class External::VisitorControllerTest < ActionDispatch::IntegrationTest
  test "should get faq" do
    get external_visitor_faq_url
    assert_response :success
  end

end
