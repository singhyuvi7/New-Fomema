# frozen_string_literal: true

# app/decorators/laboratory_decorator.rb
class LaboratoryDecorator < ApplicationDecorator
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
