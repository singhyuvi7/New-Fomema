class InspMasterListBatch < ApplicationRecord
    audited
    include CaptureAuthor

    has_many :insp_master_lists

    def self.search_date_range(start_date,end_date)
        return all if (start_date.blank? && end_date.blank?)

        if start_date.blank? || end_date.blank? 
            return where.not('DATE(end_date) < ?',start_date) if start_date.present?
            return where.not('DATE(start_date) > ?',end_date) if end_date.present?
        else 
            where.not('DATE(end_date) < ? or DATE(start_date) > ?', start_date, end_date)
        end
    end
end
