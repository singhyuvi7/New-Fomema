class InspMasterList < ApplicationRecord
  audited
  include CaptureAuthor

  belongs_to :insp_master_list_batch

  scope :start_date, -> (start_date) {
    return all if start_date.blank?
    where('insp_master_lists.visit_date >= ?',start_date.to_date.beginning_of_day)
  }

  scope :end_date, -> (end_date) {
    return all if end_date.blank?
    date = end_date.to_date + 1.day
    where('insp_master_lists.visit_date < ?', "#{date.strftime('%Y-%m-%d')}")
  }

  def self.search_visit_report_code(code)
		return all if code.blank?
		code = code.strip
      where("insp_master_lists.visit_report_id ilike '%#{code}%'")
  end
end
