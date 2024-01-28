class VisitReportLabOption < ApplicationRecord
    audited
    include CaptureAuthor

    scope :get_data, -> (report_category, field_name) {
        categories = [report_category,nil,'']
        where(:report_category => categories, :field_name => field_name).select('code','name')
    }

    scope :exclude_id, -> {
        as_json(:except => :id)
    }

end
