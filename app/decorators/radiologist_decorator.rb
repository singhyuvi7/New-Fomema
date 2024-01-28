# frozen_string_literal: true

# app/decorators/radiologist_decorator.rb
class RadiologistDecorator < ApplicationDecorator
  delegate_all

  def created_at
    object.created_at.strftime('%m/%d/%Y %H:%M')
  end

  def total_fw_two_year_ago
    object.total_transactions_for(2.year.ago.year)
  end

  def total_fw_one_year_ago
    object.total_transactions_for(1.year.ago.year)
  end
end
