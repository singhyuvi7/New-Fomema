# frozen_string_literal: true

# app/decorators/order_decorator.rb
class OrderDecorator < ApplicationDecorator
  delegate_all

  def latest_payment_date
    return unless latest_ipay88_request.present?

    object.paid_at.strftime('%-d-%m-%Y')
  end

  def latest_payment_method
    return unless latest_ipay88_request.present?

    object.payment_method.name
  end

  def latest_fpx_transaction_id
    return unless latest_ipay88_request.present?

    object.latest_ipay88_request.transaction_id
  end
end
