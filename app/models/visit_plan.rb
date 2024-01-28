class VisitPlan < ApplicationRecord

    VISITABLE_TYPES = {
        "Doctor" => "CLINIC",
        "Laboratory" => "LABORATORY",
        "XrayFacility" => "X-RAY FACILITY"
    }

    CATEGORIES = {
        "ROUTINE" => "ROUTINE",
        "INVESTIGATIVE" => "INVESTIGATIVE",
        "TARGETED" => "TARGETED"
    }

    INSPECTORATE_CATEGORIES = {
        "ROUTINE" => "ROUTINE",
        "INVESTIGATIVE" => "INVESTIGATIVE",
        "TARGETED" => "TARGETED"
    }

    LQCC_CATEGORIES = {
        "ROUTINE" => "ROUTINE",
        "INVESTIGATIVE" => "INVESTIGATIVE"
    }

    STATUSES = {
        "DRAFT" => "DRAFT",
        "LEVEL_1_APPROVAL" => "PENDING FOR LEVEL 1 APPROVAL",
        "LEVEL_1_APPROVED" => "PENDING FOR LEVEL 2 APPROVAL",
        "LEVEL_2_APPROVED" => "LEVEL 2 APPROVED",
        "REJECTED" => "REJECTED",
        "EXECUTED" => "EXECUTED",
        "SUSPENDED" => "SUSPENDED"
    }

    APPROVAL_STATUSES = {
        "LEVEL_1_APPROVAL" => "PENDING FOR LEVEL 1 APPROVAL",
        "LEVEL_1_APPROVED" => "PENDING FOR LEVEL 2 APPROVAL",
        "LEVEL_2_APPROVED" => "LEVEL 2 APPROVED",
        "REJECTED" => "REJECTED",
    }

    CODE_PREFIX = {
        "Doctor" => "C",
        "Laboratory" => "L",
        "XrayFacility" => "X"
    }

    INDICATOR_COLOR = {
        "RED" => "Not Yet Visit",
        "YELLOW" => "Visited Previous Year",
        "GREEN" => "Visited Current Year"
    }
    
    audited
    include CaptureAuthor
    include Sequence

    has_many :visit_plan_items, dependent: :destroy
    has_many :visit_plan_states, dependent: :destroy
    has_many :visit_plan_postcodes
    has_many :visit_plan_towns, dependent: :destroy
    has_many :visit_plan_categories
    has_many :visit_reports
    has_many :visit_report_doctors
    has_many :visit_report_xray_facilities
    has_many :visit_report_laboratories
    belongs_to :level1_approval_user, :class_name => :User, :foreign_key => "level_1_approval_by", :optional => true
    belongs_to :level2_approval_user, :class_name => :User, :foreign_key => "level_2_approval_by", :optional => true
    belongs_to :draft_by, :class_name => :User, :foreign_key => "created_by", :optional => true

    after_create :update_visit_plan_code

    # scopes

    scope :visitable_type, -> visitable_type { where(visitable_type: visitable_type) }

    scope :visitable_category, -> visitable_category { joins(:visit_plan_categories).where("visit_plan_categories.category = ?", visitable_category) }

    scope :inspect_from, -> inspect_from { where("inspect_from >= ?", inspect_from) }

    scope :inspect_to, -> inspect_to { where("inspect_to <= ?", inspect_to) }

    scope :status, -> status { where(status: status) }

    scope :approval, -> {
        pending_approval_statuses = %w(LEVEL_1_APPROVAL LEVEL_2_APPROVAL LEVEL_1_APPROVED LEVEL_2_APPROVED REJECTED)
        where(status: pending_approval_statuses)
    }

    scope :levelone_approval, -> { where(status: 'LEVEL_1_APPROVAL') }

    scope :leveltwo_approval, -> { where(status: 'LEVEL_2_APPROVAL') }

    def update_visit_plan_code
        self.update({
			code: generate_code
		})
    end

    def generate_code
        sprintf("#{CODE_PREFIX[self.visitable_type]}%05d", get_sequence)
    end

	def get_sequence
		sequence_name = "visit_plan_code_#{self.visitable_type.downcase}_seq"
        rs = ActiveRecord::Base.connection.execute("SELECT count(*) FROM information_schema.sequences where sequence_name = '#{sequence_name}'")
		if rs.first["count"] == 0
			sql = "create sequence #{sequence_name} 
			increment 1 
			cycle 
			start with 1"
			ActiveRecord::Base.connection.execute sql
		end
		seq_nextval(sequence_name)
    end
    
    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        where('code = ?', code)
    end

    def self.search_state(state_id)
        return all if state_id.blank?
        joins(:visit_plan_states).where("visit_plan_states.state_id = ?", state_id)
    end
end
