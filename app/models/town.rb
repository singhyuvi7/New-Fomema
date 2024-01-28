class Town < ApplicationRecord
  audited
  include CaptureAuthor

  validates :name, :code, presence: true
  validates :code, uniqueness: true

  belongs_to :state

  def self.search_code(code)
    return all if code.blank?
    code = code.strip
    where('towns.code = ?', "#{code}")
  end

  def self.search_name(name)
    return all if name.blank?
    name = name.strip
    where('towns.name ILIKE ?', "%#{name}%")
  end

  def self.search_state(state_id)
    return all if state_id.blank?
    where('towns.state_id = ?', "#{state_id}")
  end
end
