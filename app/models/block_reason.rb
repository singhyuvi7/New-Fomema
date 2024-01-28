class BlockReason < ApplicationRecord
  audited
  include CaptureAuthor

  CATEGORIES = ['BLOCK', 'UNBLOCK']

  has_many :foreign_workers

  validates :code, uniqueness: {scope: :category}

  def self.search_category(category)
    return all if category.blank?
    where('block_reasons.category = ?', "#{category}")
  end

  def self.search_code(code)
    return all if code.blank?
    code = code.strip
    where('block_reasons.code = ?', "#{code}")
  end

  def self.search_description(description)
    return all if description.blank?
    description = description.strip
    where('block_reasons.description ILIKE ?', "%#{description}%")
  end
end
