class PasswordPolicy < ApplicationRecord
  audited
  include CaptureAuthor
  acts_as_approval_resource

  has_many :password_policy_revisions
  has_many :roles

  validates :name, presence: true, uniqueness: true
  
  def self.search_name(name)
    return all if name.blank?
    name = name.strip
    where('password_policies.name ILIKE ?', "%#{name}%")
  end

  def self.search_status(status)
    return all if status.blank?
    where('password_policies.status in (?)', status)
  end
end
