module Report
  class ListOfGpReportService
    attr_reader :start_date, :end_date

    def initialize(start_date, end_date)
        @query_date = start_date.to_datetime.beginning_of_day..end_date.to_time.end_of_day
    end

    def self.headers
        [[
            "DOCTOR_CODE",
            "COMPANY_NAME",
            "TITLE",
            "DOCTOR_NAME",
            "CLINIC_NAME",
            "ICNO",
            "BUSINESS_REGISTRATION_NUMBER",
            "CREATION_DATE",
            "ADDRESS",
            "GP_DISTRICT",
            "GP_STATE",
            "GP_POSTCODE",
            "GP_PHONE",
            "GP_MOBILE",
            "GP_FAX",
            "EMAIL",
            "QUALIFICATION",
            "GP_STATUS",
            "RENEWAL_AGREEMENT_DATE",
            "APC_NUMBER",
            "APC_YEAR",
            "DISTRICT_HEALTH_OFFICE",
            "FP_DEVICE",
            "ACTIVATED_AT",
            "QUOTA",
            "QUOTA_MODIFIER",
            "QUOTA_USED",
            "QUOTA_USED_INCLUDE_PENDING",
            "QUOTA",
            "CERTIFIED_WORKER",
            "AVAILABLE_QUOTA",
            "OVER_QUOTA",
            "STATUS_REASON",
            "STATUS_COMMENT",
            "SOLO_CLINIC",
            "GROUP_CLINIC",
            "OWN_XRAY_CLINIC",
            "XRAY_FACILITY_PAIRING_OPTIONS",
            "LABORATORY_PAIRING_OPTIONS",
            "XRAY_CODE",
            "XRAY_NAME",
            "XRAY_EMAIL",
            "XRAY_PHONE",
            "XRAY_FAX",
            "XRAY_ADDRESS",
            "XRAY_DISTRICT",
            "XRAY_STATE",
            "LABORATORY_CODE",
            "LABORATORY_NAME",
            "LABORATORY_EMAIL",
            "LABORATORY_ADDRESS",
            "LAB_STATE",
            "LAB_DISTRICT",
            "SERVICE_PROVIDER_GROUP_NAME",
            "TOTAL_FW_#{2.year.ago.year}",
            "TOTAL_FW_#{1.year.ago.year}",
            "TOTAL_FW_#{Time.now.year}"
        ]]
    end

    def result
        csv     = ListOfGpReportService.headers
    	data    = set_list_of_gp_data

        data.each do |d|
            csv    << [
                d.code,
                d.company_name,
                d.title_name,
                d.name,
                d.clinic_name,
                d.icno,
                d.business_registration_number,
                d.created_at,
                d.displayed_address,
                d.town_name,
                d.state_name,
                d.postcode,
                d.phone,
                d.mobile,
                d.fax,
                d.email,
                d.qualification,
                d.status,
                d.renewal_agreement_date,
                d.apc_number,
                d.apc_year,
                d.district_health_office_name,
                d.fp_device_display,
                d.activated_at,
                d.quota,
                d.quota_modifier,
                d.quota_used,
                d.quota_used_include_pending_order,
                d.displayed_quota,
                d.current_year_certified_worker_count,
                d.available_quota,
                d.over_quota_yes_no,
                d.status_reason_display,
                d.status_comment,
                d.solo_clinic,
                d.group_clinic,
                d.has_xray,
                d.xray_facility_pairing_options_display,
                d.laboratory_pairing_options_display,
                d.xray_facility_code,
                d.xray_facility_name,
                d.xray_facility_email,
                d.xray_facility_phone,
                d.xray_facility_fax,
                d.xray_facility_displayed_address,
                d.xray_facility_town_name,
                d.xray_facility_state_name,
                d.laboratory_code,
                d.laboratory_name,
                d.laboratory_email,
                d.laboratory_displayed_address,
                d.laboratory_state,
                d.laboratory_district,
                d.service_provider_group_name,
                d.total_fw_two_year_ago,
                d.total_fw_one_year_ago,
                d.total_fw_current_year
            ]
        end

        csv
    end

    private

    def set_list_of_gp_data
        data 	=   DoctorDecorator.decorate_collection Doctor.includes(
                        :title, 
                        :town, 
                        :state, 
                        :district_health_office, 
                        :xray_facility, 
                        :laboratory, 
                        :service_provider_group, 
                        xray_facility: [:town, :state], 
                        laboratory: [:town, :state]
                    )
                    .where(created_at: @query_date)
    end
    
  end
end
