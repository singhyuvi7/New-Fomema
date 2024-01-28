class XrayStorage < ApplicationRecord

  CATEGORIES = {
    "NORMAL" => "Normal",
    "ABNORMAL" => "Abnormal",
    "ACS" => "ACS (Audit and Comparisons)",
    "WRONGLY_TRANSMIT" => "Wrongly Transmit",
    "PENDING_REVIEW" => "Pending Review",
    "ACTIVE_TB" => "Active TB",
    "POOR_QUALITY" => "Poor Quality",
    "TCUPI" => "TCUPI"
}

  audited
  include CaptureAuthor
  include Sequence

  after_create :update_code

  has_many :xray_storage_items
  has_many :xray_storage_categories
  has_many :transactions, through: :xray_storage_items, source: :transactionz

  belongs_to :organization

  accepts_nested_attributes_for :xray_storage_items, allow_destroy: true

  def self.search_code(code)
    return all if code.blank?
    code = code.strip
    where('xray_storages.code = ?', "#{code}")
  end

  def sync_xray_storage_categories(categories)
    if categories.nil?
        categories = []
    end
    XrayStorageCategory.where(xray_storage_id: id).where.not(category: categories).delete_all
    categories.each do |perm|
        XrayStorageCategory.where(xray_storage_id: id).where(category: perm).first_or_create
    end
  end

  def current_categories
    if (!defined? @categories)
        @categories = xray_storage_categories.pluck(:category)
    end
    @categories
  end

  def update_code
		self.update({
			code: generate_code,
		})
	end

	def generate_code
		sprintf("#{Time.now.strftime("%Y%m")}%04d", get_sequence)
	end

	def get_sequence
		sequence_name = "xray_storages_code_#{Time.now.strftime("%Y%m")}_seq"
    get_or_create_sequence(sequence_name)
  end

  def xray_storage_item
    super || build_xray_storage_item()
  end
end
