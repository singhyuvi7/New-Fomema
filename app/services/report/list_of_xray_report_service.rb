module Report
  class ListOfXrayReportService
    attr_reader :start_date, :end_date

    def initialize(start_date, end_date)
        @query_date = start_date.to_time.beginning_of_day..end_date.to_time.end_of_day
    end

    def self.headers
        [[
            "XRAY_CODE",
            "TITLE",
            "XRAY_NAME",
            "CREATION_DATE",
            "LICENSE_HOLDER_NAME",
            "COMPANY_NAME",
            "ICNO",
            "BUSINESS_REGISTRATION_NUMBER",
            "ADDRESS",
            "TOWN_NAME",
            "POSTCODE",
            "STATE_NAME",
            "RADIOOPERATED",
            "RADIOLOGIST_NAME",
            "FP_DEVICE",
            "PHONE",
            "FAX",
            "MOBILE",
            "EMAIL",
            "STATUS",
            "STATUS_REASON",
            "STATUS_COMMENT",
            "XRAY_TYPE",
            "QUALIFICATION",
            "XRAY_LICENSE_NUMBER",
            "XRAY_FILE_NUMBER",
            "XRAY_LICENSE_TUJUAN",
            "XRAY_LICENSE_EXPIRY_DATE",
            "MOH_LICENSE_STATUS",
            "APC_NUMBER",
            "APC_YEAR",
            "RENEWAL_AGREEMENT_DATE",
            "DISTRICT_HEALTH_OFFICE_NAME",
            "ACTIVATED_AT",
            "SERVICE_PROVIDER_GROUP",
            "TOTAL_CLINIC",
            "ACTIVE_CLINIC_ASSOCIATES",
            "TOTAL_WORKER_ALLOCATED",
            "TOTAL_FW_#{2.year.ago.year}",
            "TOTAL_FW_#{1.year.ago.year}",
            "TOTAL_FW_#{Time.now.year}"
        ]]
    end

    def result
        csv     = ListOfXrayReportService.headers
    	data    = set_list_of_xray_data

        data.each do |d|
            csv    << [
                d.code,
                d.title_name,
                d.name,
                d.created_at,
                d.license_holder_name,
                d.company_name,
                d.icno,
                d.business_registration_number,
                d.displayed_address,
                d.town_name,
                d.postcode,
                d.state_name,
                d.radiologist_operated,
                d.radiologist_name,
                d.fp_device,
                d.phone,
                d.fax,
                d.mobile,
                d.email,
                d.status,
                d.status_reason_display,
                d.status_comment,
                d.film_type,
                d.qualification,
                d.xray_license_number,
                d.xray_file_number,
                d.xray_license_tujuan,
                d.xray_license_expiry_date,
                d.moh_license_status,
                d.apc_number,
                d.apc_year,
                d.renewal_agreement_date,
                d.district_health_office_name,
                d.activated_at,
                d.service_provider_group_name,
                d.doctors_count,
                d.active_doctors_count,
                d.total_worker_allocated,
                d.total_fw_two_year_ago,
                d.total_fw_one_year_ago,
                d.total_fw_current_year
            ]
        end

        csv
    end

    private

    def set_list_of_xray_data
        data 	=   XrayFacilityDecorator.decorate_collection XrayFacility.includes(
                        :title, 
                        :town, 
                        :state, 
                        :doctors, 
                        :district_health_office, 
                        :service_provider_group
                    )
                    .where(created_at: @query_date)
    end
    
  end
end
