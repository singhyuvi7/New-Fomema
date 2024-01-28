class XrayDispatchItem < ApplicationRecord
  belongs_to :xray_dispatch
  belongs_to :transactionz, foreign_key: "transaction_id", class_name: "Transaction"

  scope :with_xray_code, -> {}
  scope :analog, -> { joins(:transactionz).where(transactions: { xray_film_type: 'ANALOG' }) }
  scope :digital, -> { joins(:transactionz).where(transactions: { xray_film_type: 'DIGITAL' }) }
  scope :gp_certified, -> { joins(:transactionz).where.not(transactions: { doctor_transmit_date: nil }) }
  scope :pending_gp_certified, -> { joins(:transactionz).where(transactions: { doctor_transmit_date: nil }) }
  scope :with_xray_code, lambda { |xray_code|
    joins(transactionz: :xray_facility)
      .where(transactionz: { xray_facilities: { code: xray_code } })
  }
  scope :with_created_at_year, ->(year) { where(created_at: DateTime.new(year).beginning_of_year...DateTime.new(year).end_of_year) }
end
