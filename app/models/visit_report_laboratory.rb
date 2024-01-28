class VisitReportLaboratory < ApplicationRecord
    YESNO = {
        "YES" => "Yes",
        "NO" => "No"
    }

    YESNONA = YESNO.merge({
        "NA" => "N/A"
    })

    SATISFACTORIES = YESNO

    CATEGORIES = {
        "FULL" => "Full Laboratory",
        "PARTIAL" => "Partial Laboratory",
        "COLLECTION_CENTRE" => "Collection Centre"
    }

    ## new lqcc 
    REPORT_CATEGORIES = [
        'blood_grouping','malaria_screening','malaria_bfmp',
        'hbsag_screening','hbsag_verification','hiv_screening',
        'hiv_verification','vdrl_rpr','tpha_tppa','urine_drugs_screening',
        'urine_drugs_verification','upt','serum_assay','urine_biochemistry'
    ]

    COLLECTION_TABS = {
        facility_adequacy: "Facility Adequacy",
        pre_analytical: "Pre-Analytical",
        specimen_storage: "Specimen Storage",
        conclusion: "Conclusion"
    }

    FULL_PARTIAL_TABS = {
        facility_adequacy: "Facility Adequacy",
        pre_analytical: "Pre-Analytical",
        blood_grouping: "ABO RH(D) Blood Grouping",
        malaria_screening: "Malaria - Screening",
        malaria_bfmp: "Malaria - BFMP",
        hbsag_screening: "HBSAG - Screening",
        hbsag_verification: "HBSAG - Verification",
        hiv_screening: "HIV - Screening",
        hiv_verification: "HIV - Verification",
        vdrl_rpr: 'VDRL/RPR',
        tpha_tppa: 'TPHA/TPPA',
        urine_drugs_screening: 'Urine Drugs - Screening',
        urine_drugs_verification: 'Urine Drugs - Verification',
        upt: 'UPT',
        serum_assay: 'SERUM β-hCG Assay',
        urine_biochemistry: 'Urine Biochemistry',
        specimen_storage: "Specimen Storage",
        record_keeping: "Reporting/Record-Keeping",
        conclusion: "Conclusion"
    }

    audited
    include CaptureAuthor

    belongs_to :visit_report
    belongs_to :laboratory
    belongs_to :country
    belongs_to :state
    belongs_to :town

    has_many :visit_report_lab_details
    has_one :blood_grouping, -> { where report_category: 'blood_grouping' }, class_name: "VisitReportLabDetail"
    has_one :malaria_screening, -> { where report_category: 'malaria_screening' }, class_name: "VisitReportLabDetail"
    has_one :malaria_bfmp, -> { where report_category: 'malaria_bfmp' }, class_name: "VisitReportLabDetail"
    has_one :hbsag_screening, -> { where report_category: 'hbsag_screening' }, class_name: "VisitReportLabDetail"
    has_one :hbsag_verification, -> { where report_category: 'hbsag_verification' }, class_name: "VisitReportLabDetail"
    has_one :hiv_screening, -> { where report_category: 'hiv_screening' }, class_name: "VisitReportLabDetail"
    has_one :hiv_verification, -> { where report_category: 'hiv_verification' }, class_name: "VisitReportLabDetail"
    has_one :vdrl_rpr, -> { where report_category: 'vdrl_rpr' }, class_name: "VisitReportLabDetail"
    has_one :tpha_tppa, -> { where report_category: 'tpha_tppa' }, class_name: "VisitReportLabDetail"
    has_one :urine_drugs_screening, -> { where report_category: 'urine_drugs_screening' }, class_name: "VisitReportLabDetail"
    has_one :urine_drugs_verification, -> { where report_category: 'urine_drugs_verification' }, class_name: "VisitReportLabDetail"
    has_one :upt, -> { where report_category: 'upt' }, class_name: "VisitReportLabDetail"
    has_one :serum_assay, -> { where report_category: 'serum_assay' }, class_name: "VisitReportLabDetail"
    has_one :urine_biochemistry, -> { where report_category: 'urine_biochemistry' }, class_name: "VisitReportLabDetail"

    accepts_nested_attributes_for :blood_grouping, :malaria_screening, :malaria_bfmp, :hbsag_screening, :hbsag_verification, :hiv_screening, :hiv_verification, :vdrl_rpr, :tpha_tppa, :urine_drugs_screening, 
    :urine_drugs_verification, :upt, :serum_assay, :urine_biochemistry
end