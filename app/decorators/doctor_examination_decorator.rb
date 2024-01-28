# frozen_string_literal: true

# app/decorators/doctor_examination_decorator.rb
class DoctorExaminationDecorator < ApplicationDecorator
  delegate_all

  def diseases
    object.diseases.join(', ')
  end
end
