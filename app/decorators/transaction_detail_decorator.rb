# frozen_string_literal: true

# app/decorators/transaction_detail_decorator.rb
class TransactionDetailDecorator < ApplicationDecorator
  delegate_all

  # doc_full_address, lab_full_address, xray_full_address
  %i[doc lab xray].each do |selector|
    define_method(:"#{selector}_full_address") { full_address_for(selector) }
  end

  def doc_full_address
    full_address_for :doc
  end

  def certification_date
    return unless object.certification_date

    object.certification_date.strftime('%d/%m/%Y')
  end

  def doc_group_code
    return unless doc_code

    object.doc_sp_group_code || 'NON-GROUP'
  end

  def lab_group_code
    return unless lab_code

    object.lab_sp_group_code || 'NON-GROUP'
  end

  def xray_group_code
    return unless xray_code

    object.xray_sp_group_code || 'NON-GROUP'
  end
end
