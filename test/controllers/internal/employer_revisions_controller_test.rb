require 'test_helper'

class Internal::EmployerRevisionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @internal_employer_revision = internal_employer_revisions(:one)
  end

  test "should get index" do
    get internal_employer_revisions_url
    assert_response :success
  end

  test "should get new" do
    get new_internal_employer_revision_url
    assert_response :success
  end

  test "should create internal_employer_revision" do
    assert_difference('Internal::EmployerRevision.count') do
      post internal_employer_revisions_url, params: { internal_employer_revision: {  } }
    end

    assert_redirected_to internal_employer_revision_url(Internal::EmployerRevision.last)
  end

  test "should show internal_employer_revision" do
    get internal_employer_revision_url(@internal_employer_revision)
    assert_response :success
  end

  test "should get edit" do
    get edit_internal_employer_revision_url(@internal_employer_revision)
    assert_response :success
  end

  test "should update internal_employer_revision" do
    patch internal_employer_revision_url(@internal_employer_revision), params: { internal_employer_revision: {  } }
    assert_redirected_to internal_employer_revision_url(@internal_employer_revision)
  end

  test "should destroy internal_employer_revision" do
    assert_difference('Internal::EmployerRevision.count', -1) do
      delete internal_employer_revision_url(@internal_employer_revision)
    end

    assert_redirected_to internal_employer_revisions_url
  end
end
