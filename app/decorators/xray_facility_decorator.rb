# frozen_string_literal: true

# app/decorators/xray_facility_decorator.rb
class XrayFacilityDecorator < ApplicationDecorator
  delegate_all

  def created_at
    object.created_at.strftime('%d/%m/%Y')
  end

  def activated_at
    object.activated_at.try(:strftime, '%d/%m/%Y')
  end

  def renewal_agreement_date
    object.renewal_agreement_date.try(:strftime, '%d/%m/%Y')
  end

  def fp_device
    XrayFacility::FP_DEVICES[object.fp_device.to_s]&.upcase
  end

  def active_doctors_count
    doctors_count(active: true)
  end

  def total_fw_two_year_ago
    object.total_transactions_for(2.year.ago.year)
  end

  def total_fw_one_year_ago
    object.total_transactions_for(1.year.ago.year)
  end

  def total_fw_current_year
    object.total_transactions_for(Time.now.year)
  end

  def has_doctor_association
    object.has_doctor_association ? 'Y' : 'N'
  end
end
