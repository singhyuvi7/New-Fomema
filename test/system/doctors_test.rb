require "application_system_test_case"

class DoctorsTest < ApplicationSystemTestCase
  setup do
    @doctor = doctors(:one)
  end

  test "visiting the index" do
    visit doctors_url
    assert_selector "h1", text: "Doctors"
  end

  test "creating a Doctor" do
    visit doctors_url
    click_on "New Doctor"

    fill_in "Address1", with: @doctor.address1
    fill_in "Address2", with: @doctor.address2
    fill_in "Address3", with: @doctor.address3
    fill_in "Address4", with: @doctor.address4
    fill_in "Annual Practice Certificate", with: @doctor.annual_practice_certificate
    fill_in "Application Number", with: @doctor.application_number
    fill_in "Application Year", with: @doctor.application_year
    fill_in "Area", with: @doctor.area_id
    fill_in "Code", with: @doctor.code
    fill_in "Comment", with: @doctor.comment
    fill_in "Country", with: @doctor.country_id
    fill_in "District", with: @doctor.district_id
    fill_in "Email", with: @doctor.email
    fill_in "Fax", with: @doctor.fax
    fill_in "Grace Quota", with: @doctor.grace_quota
    fill_in "Icno", with: @doctor.icno
    fill_in "Kdm Member", with: @doctor.kdm_member
    fill_in "Name", with: @doctor.name
    fill_in "Phone", with: @doctor.phone
    fill_in "Postcode", with: @doctor.postcode
    fill_in "Quota", with: @doctor.quota
    fill_in "Quota Available", with: @doctor.quota_available
    fill_in "State", with: @doctor.state_id
    fill_in "Status", with: @doctor.status
    click_on "Create Doctor"

    assert_text "Doctor was successfully created"
    click_on "Back"
  end

  test "updating a Doctor" do
    visit doctors_url
    click_on "Edit", match: :first

    fill_in "Address1", with: @doctor.address1
    fill_in "Address2", with: @doctor.address2
    fill_in "Address3", with: @doctor.address3
    fill_in "Address4", with: @doctor.address4
    fill_in "Annual Practice Certificate", with: @doctor.annual_practice_certificate
    fill_in "Application Number", with: @doctor.application_number
    fill_in "Application Year", with: @doctor.application_year
    fill_in "Area", with: @doctor.area_id
    fill_in "Code", with: @doctor.code
    fill_in "Comment", with: @doctor.comment
    fill_in "Country", with: @doctor.country_id
    fill_in "District", with: @doctor.district_id
    fill_in "Email", with: @doctor.email
    fill_in "Fax", with: @doctor.fax
    fill_in "Grace Quota", with: @doctor.grace_quota
    fill_in "Icno", with: @doctor.icno
    fill_in "Kdm Member", with: @doctor.kdm_member
    fill_in "Name", with: @doctor.name
    fill_in "Phone", with: @doctor.phone
    fill_in "Postcode", with: @doctor.postcode
    fill_in "Quota", with: @doctor.quota
    fill_in "Quota Available", with: @doctor.quota_available
    fill_in "State", with: @doctor.state_id
    fill_in "Status", with: @doctor.status
    click_on "Update Doctor"

    assert_text "Doctor was successfully updated"
    click_on "Back"
  end

  test "destroying a Doctor" do
    visit doctors_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Doctor was successfully destroyed"
  end
end
