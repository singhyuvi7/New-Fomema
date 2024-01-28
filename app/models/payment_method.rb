class PaymentMethod < ApplicationRecord
  has_many :doc_transaction_details, class_name: 'TransactionDetail',
                                     inverse_of: :doc_sp_group_payment_method,
                                     foreign_key: :doc_sp_group_payment_method_id
  has_many :xray_transaction_details, class_name: 'TransactionDetail',
                                      inverse_of: :xray_sp_group_payment_method,
                                      foreign_key: :xray_sp_group_payment_method_id
  has_many :lab_transaction_details, class_name: 'TransactionDetail',
                                      inverse_of: :lab_sp_group_payment_method,
                                      foreign_key: :lab_sp_group_payment_method_id

  CATEGORIES = {
    "IN" => "INCOMING",
    "OUT" => "OUTGOING",
  }

  IS_MAINS = {
    "Yes" => true,
    "No" => false
  }

  ACTIVE = {
    "Yes" => true,
    "No" => false
  }

  USE_AT_TYPES = {
    "ALL" => "ALL",
    "INTERNAL" => "INTERNAL",
    "EXTERNAL" => "EXTERNAL",
  }

  audited
  include CaptureAuthor

  validates :code, presence: true, uniqueness: true
  validates :category, presence: true
  validates :name, presence: true

  has_many :orders

  def self.search_code(code)
    return all if code.blank?
    code = code.strip
    where('payment_methods.code = ?', "#{code}")
  end

  def self.search_name(name)
    return all if name.blank?
    name = name.strip
    where('payment_methods.name ilike ?', "%#{name}%")
  end

  def self.search_category(category)
    return all if category.blank?
    where('payment_methods.category = ?',category)
  end

  def self.search_use_at(use_at)
    return all if use_at.blank?
    where('payment_methods.use_at = ?',use_at)
  end

  def self.search_is_main(is_main)
    return all if is_main.blank?
    where('payment_methods.is_main = ?',is_main)
  end

  def self.search_active(active)
    return all if active.blank?
    where('payment_methods.active = ?',active)
  end

  def self.available_for_internal_payment
    where("payment_methods.category = 'IN'").where(:active => 'true', :use_at => ['ALL','INTERNAL'])
  end

  def self.available_for_external_payment
    where("payment_methods.category = 'IN'").where(:active => 'true', :use_at => ['ALL','EXTERNAL'])
  end

  def is_ipay?
    code.start_with?('IPAY')
  end

  def is_swipe?
    code.start_with?('SWIPE')
  end

  def is_fpx?
    code.start_with?('PAYNET')
  end

  def is_boleh?
    code.start_with?('BOLEH')
  end

  def self.mspd
    where("payment_methods.code in (?)",['BANKDRAFT'])
  end

  def self.is_ipay_active?
    where("payment_methods.code ilike 'IPAY_%' and payment_methods.active = true").count > 0
  end

  def self.is_swipe_active?
    where("payment_methods.code ilike 'SWIPE_%' and payment_methods.active = true").count > 0
  end

  def self.is_fpx_active?
    where("payment_methods.code ilike 'PAYNET_%' and payment_methods.active = true").count > 0
  end

  def self.is_boleh_active?
    where("payment_methods.code ilike 'BOLEH%' and payment_methods.active = true").count > 0
  end
end
