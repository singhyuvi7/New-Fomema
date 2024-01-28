# frozen_string_literal: true

# app/decorators/doctor_decorator.rb
class DoctorDecorator < ApplicationDecorator
  delegate_all

  def laboratory_state
    return unless object.laboratory&.state

    object.laboratory.state.name
  end

  def laboratory_district
    return unless object.laboratory&.town

    object.laboratory.town.name
  end

  def has_xray
    object.has_xray ? 'Y' : 'N'
  end

  def has_doctor_association
    object.has_doctor_association ? 'Y' : 'N'
  end

  def has_selected_re_medical
    object.has_selected_re_medical ? 'Y' : 'N'
  end

  def created_at
    object.created_at.strftime('%d/%m/%Y')
  end

  def activated_at
    object.activated_at.try(:strftime, '%d/%m/%Y')
  end

  def renewal_agreement_date
    object.renewal_agreement_date.try(:strftime, '%d/%m/%Y')
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
end
