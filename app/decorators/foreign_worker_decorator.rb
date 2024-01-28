# frozen_string_literal: true

# app/decorators/foreign_worker_decorator.rb
class ForeignWorkerDecorator < ApplicationDecorator
  delegate_all

  def transdate
    latest_transaction&.transaction_date
  end

  def exam_date
    latest_transaction&.medical_examination_date
  end

  def xray_test_done_date
    latest_transaction&.xray_test_done_date
  end

  def xray_transmit_date
    latest_transaction&.xray_transmit_date
  end

  def lab_specimen_receive_date
    latest_transaction&.specimen_received_date
  end

  def lab_specimen_taken_date
    latest_transaction&.specimen_taken_date
  end

  def lab_submit_date
    latest_transaction&.laboratory_transmit_date
  end

  def certification_date
    latest_transaction&.certification_date
  end

  def branch_code
    latest_transaction&.organization_code
  end

  def renewal
    object.renewal? ? 'RENEWAL' : 'NEW'
  end

  def laboratory_code
    latest_transaction&.laboratory_code
  end

  def laboratory_name
    latest_transaction&.laboratory_name
  end

  def lab_status
    latest_transaction&.laboratory_status
  end

  def status
    latest_transaction&.final_result
  end

  def clinic_name
    latest_transaction&.doctor_clinic_name
  end

  def doctor_phone_number
    latest_transaction&.doctor_phone
  end

  def doctor_address
    latest_transaction&.doctor_displayed_address
  end

  def transaction
    @transaction ||= object.latest_transaction
  end

  def diseases
    return unless transaction
    return unless transaction.doctor_examination

    transaction.doctor_examination.decorate.diseases
  end

  def gender
    ForeignWorker::GENDERS[object.gender]
  end
end
