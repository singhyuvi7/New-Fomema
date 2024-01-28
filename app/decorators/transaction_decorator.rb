# frozen_string_literal: true

# app/decorators/transaction_decorator.rb
class TransactionDecorator < ApplicationDecorator
  decorates_association :transaction_detail
  delegate_all

  def transaction_date
    return unless object.transaction_date

    object.transaction_date.strftime('%-d-%^b-%y')
  end

  def medical_examination_date
    return unless object.medical_examination_date

    object.medical_examination_date.strftime('%-d-%^b-%y')
  end

  def certification_date
    return unless object.certification_date

    object.certification_date.strftime('%-d-%^b-%y')
  end

  def renewal?
    object.renewal? ? 'RENEWAL' : 'NEW'
  end

  def fw_gender
    ForeignWorker::GENDERS[object.fw_gender]
  end

  DoctorExamination::DISEASES.each do |disease_condition, _|
    define_method(disease_condition.to_sym) do
      return unless object.doctor_examination

      object.doctor_examination.send(disease_condition.to_sym) ? 'YES' : 'NO'
    end
  end
end
