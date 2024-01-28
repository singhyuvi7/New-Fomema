require 'test_helper'

class Internal::PcrPoolsControllerTest < ActionDispatch::IntegrationTest
  test "should get pickup" do
    get internal_pcr_pools_pickup_url
    assert_response :success
  end

  test "should get pickup_update" do
    get internal_pcr_pools_pickup_update_url
    assert_response :success
  end

end
