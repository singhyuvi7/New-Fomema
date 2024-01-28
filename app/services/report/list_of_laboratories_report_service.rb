module Report
  class ListOfLaboratoriesReportService
    attr_reader :start_date, :end_date

    def initialize(start_date, end_date)
        @query_date = start_date.to_datetime.beginning_of_day..end_date.to_time.end_of_day
    end

    def self.headers
        [[
            "LABORATORY_CODE",
            "COMPANY_NAME",
            "LABORATORY_NAME",
            "BUSINESS_REGISTRATION_NUMBER",
            "CREATION_DATE",
            "ADDRESS",
            "POSTCODE",
            "DISTRICT_NAME",
            "STATE_NAME",
            "PHONE",
            "FAX",
            "EMAIL",
            "PIC_NAME",
            "PIC_PHONE",
            "QUALIFICATION",
            "PATHOLOGIST_NAME",
            "RENEWAL_AGREEMENT_DATE",
            "NSR_NUMBER",
            "LABORATORY_TYPE",
            "DISTRICT_HEALTH_OFFICE",
            "SAMM_NUMBER",
            "SAMM_ACCREDITED_SINCE",
            "SAMM_EXPIRY_DATE",
            "LICENSE",
            "LICENSE_YEAR",
            "WEB_SERVICE",
            "STATUS",
            "STATUS_REASON",
            "STATUS_COMMENT",
            "ACTIVATED_AT",
            "ACTIVE_GP",
            "TOTAL_WORKER_ALLOCATED",
            "SERVICE_PROVIDER_GROUP",
            "TOTAL_FW_#{2.year.ago.year}",
            "TOTAL_FW_#{1.year.ago.year}",
            "TOTAL_FW_#{Time.now.year}"
        ]]
    end

    def result
        csv     = ListOfLaboratoriesReportService.headers
    	data    = set_list_of_laboratories_data

        data.each do |d|
            csv    << [
                d.code,
                d.company_name,
                d.name,
                d.business_registration_number,
                d.created_at,
                d.displayed_address,
                d.postcode,
                d.town_name,
                d.state_name,
                d.phone,
                d.fax,
                d.email,
                d.pic_name,
                d.pic_phone,
                d.qualification,
                d.pathologist_name,
                d.renewal_agreement_date,
                d.nsr_number,
                d.laboratory_type_name,
                d.district_health_office_name,
                d.samm_number,
                d.samm_accredited_since,
                d.samm_expiry_date,
                d.license,
                d.license_year,
                d.web_service_yes_no,
                d.status,
                d.status_reason_display,
                d.status_comment,
                d.activated_at,
                d.active_gp_count,
                d.total_worker_allocated,
                d.service_provider_group_name,
                d.total_fw_two_year_ago,
                d.total_fw_one_year_ago,
                d.total_fw_current_year
            ]
        end

        csv
    end

    private

    def set_list_of_laboratories_data
        data 	=   LaboratoryDecorator.decorate_collection Laboratory.includes(
                        :town, 
                        :state, 
                        :laboratory_type, 
                        :district_health_office, 
                        :doctors, 
                        :service_provider_group
                    )
                    .where(created_at: @query_date)
    end
    
  end
end
