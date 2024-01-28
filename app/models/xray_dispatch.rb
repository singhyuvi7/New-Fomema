class XrayDispatch < ApplicationRecord
	audited
	include CaptureAuthor
  include Sequence
  
  after_create :update_code

  belongs_to :xray_facility
  has_many :xray_dispatch_items
  has_many :transactions, through: :xray_dispatch_items, source: :transactionz

  accepts_nested_attributes_for :xray_dispatch_items, allow_destroy: true
  
  def self.search_code(code)
    return all if code.blank?
    code = code.strip
    where('xray_dispatches.code = ?', "#{code}")
  end

  def self.search_xray_facility_id(xray_facility_id)
    return all if xray_facility_id.blank?
    where('xray_dispatches.xray_facility_id = ?', "#{xray_facility_id}")
  end

  def update_code
		self.update({
			code: generate_code,
		})
	end

	def generate_code
		sprintf("#{Time.now.strftime("%Y%m%d")}%04d", get_sequence)
	end

	def get_sequence
    sequence_name = "xray_dispatches_code_#{Time.now.strftime("%Y%m%d")}_seq"
    get_or_create_sequence(sequence_name)
  end

  def xray_dispatch_item
    super || build_xray_dispatch_item()
  end

end
