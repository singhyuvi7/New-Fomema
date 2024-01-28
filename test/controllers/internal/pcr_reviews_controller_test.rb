require 'test_helper'

class Internal::PcrReviewsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get internal_pcr_reviews_index_url
    assert_response :success
  end

  test "should get edit" do
    get internal_pcr_reviews_edit_url
    assert_response :success
  end

  test "should get show" do
    get internal_pcr_reviews_show_url
    assert_response :success
  end

  test "should get update" do
    get internal_pcr_reviews_update_url
    assert_response :success
  end

end
