class LqccLetter < ApplicationRecord
    audited
    include CaptureAuthor

    STATUSES = {
		"DRAFT" => "Draft",
		"NEW" => "New",
		"APPROVAL" => "Pending Approval",
		"REJECTED" => "Rejected",
		"APPROVED" => "Approved",
		"CANCELLED" => "Cancelled"
	}

	EXPLANATION_TYPES = {
		"LAB_CLOSED_NOT_EXIST" => "Lab Closed/Not Exist",
		"NON_COMPLIANCE" => "Non-Compliance"
	}

	OPERATION_TYPES = {
		"CLOSED" => "closed",
		"NOT_EXIST" => "not exist at registered address"
	}

    belongs_to :visit_report

	accepts_nested_attributes_for :visit_report

    def self.search_visit_report_code(code)
		return all if code.blank?
		code = code.strip
        joins(:visit_report).where('visit_reports.code = ?', "#{code}")
	end
	
    def self.search_laboratory_code(code)
		return all if code.blank?
		code = code.strip
		joins(:visit_report)
		.joins('join laboratories on visit_reports.visitable_id = laboratories.id')
		.where("visit_reports.visitable_type = 'Laboratory' and laboratories.code = ?", "#{code}")
    end
	
	def explanation_letter_reference
		signee_abbr = TemplateVariable.find_by_code('LQCC_LETTER_SIGNEE_ABBR')&.value

		## if use signature name then its #{explanation_signature_name} else signee_abbr
        "#{visit_report&.code}/#{visit_report.visit_date.try(:strftime,'%Y-%m')}/#{visit_report.visit_report_laboratory&.laboratory_name.split.map(&:first).join.upcase}/LQCC/#{signee_abbr}"
    end
end