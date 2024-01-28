require 'test_helper'

class DoctorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @doctor = doctors(:one)
  end

  test "should get index" do
    get doctors_url
    assert_response :success
  end

  test "should get new" do
    get new_doctor_url
    assert_response :success
  end

  test "should create doctor" do
    assert_difference('Doctor.count') do
      post doctors_url, params: { doctor: { address1: @doctor.address1, address2: @doctor.address2, address3: @doctor.address3, address4: @doctor.address4, annual_practice_certificate: @doctor.annual_practice_certificate, application_number: @doctor.application_number, application_year: @doctor.application_year, area_id: @doctor.area_id, code: @doctor.code, comment: @doctor.comment, country_id: @doctor.country_id, district_id: @doctor.district_id, email: @doctor.email, fax: @doctor.fax, grace_quota: @doctor.grace_quota, icno: @doctor.icno, kdm_member: @doctor.kdm_member, name: @doctor.name, phone: @doctor.phone, postcode: @doctor.postcode, quota: @doctor.quota, quota_available: @doctor.quota_available, state_id: @doctor.state_id, status: @doctor.status } }
    end

    assert_redirected_to doctor_url(Doctor.last)
  end

  test "should show doctor" do
    get doctor_url(@doctor)
    assert_response :success
  end

  test "should get edit" do
    get edit_doctor_url(@doctor)
    assert_response :success
  end

  test "should update doctor" do
    patch doctor_url(@doctor), params: { doctor: { address1: @doctor.address1, address2: @doctor.address2, address3: @doctor.address3, address4: @doctor.address4, annual_practice_certificate: @doctor.annual_practice_certificate, application_number: @doctor.application_number, application_year: @doctor.application_year, area_id: @doctor.area_id, code: @doctor.code, comment: @doctor.comment, country_id: @doctor.country_id, district_id: @doctor.district_id, email: @doctor.email, fax: @doctor.fax, grace_quota: @doctor.grace_quota, icno: @doctor.icno, kdm_member: @doctor.kdm_member, name: @doctor.name, phone: @doctor.phone, postcode: @doctor.postcode, quota: @doctor.quota, quota_available: @doctor.quota_available, state_id: @doctor.state_id, status: @doctor.status } }
    assert_redirected_to doctor_url(@doctor)
  end

  test "should destroy doctor" do
    assert_difference('Doctor.count', -1) do
      delete doctor_url(@doctor)
    end

    assert_redirected_to doctors_url
  end
end
