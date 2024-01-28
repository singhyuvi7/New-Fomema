class Fee < ApplicationRecord
  audited
  include CaptureAuthor
  acts_as_paranoid

  has_many :order_items

  def self.search_code(code)
    return all if code.blank?
    code = code.strip
    where('fees.code = ?', code)
  end

  def self.search_name(name)
    return all if name.blank?
    name = name.strip
    where('fees.name ilike ?', "%#{name}%")
  end

  def self.search_remark(remark)
    return all if remark.blank?
    remark = remark.strip
    where('fees.remark ilike ?', "%#{code}%")
  end

  def self.search_status(status)
    return all if status.blank?
    where('fees.status = ?', status)
  end

  def is_convenient_fee?
    code.start_with?('IPAY','SWIPE','PAYNET','BOLEH')
  end

  def is_registration_fee?
    ['TRANSACTION_MALE','TRANSACTION_FEMALE'].include?(code)
  end

  def is_insurance_fee?
    code.start_with?('INSURANCE')
  end
end
