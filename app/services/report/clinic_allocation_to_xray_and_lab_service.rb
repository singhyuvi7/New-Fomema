module Report
    class ClinicAllocationToXrayAndLabService
        attr_reader :filter_date_start, :filter_date_end, :code

        def initialize(filter_date_start, filter_date_end, code)
            @code           = code
            @query_date     = filter_date_start.to_time.beginning_of_day..filter_date_end.to_time.end_of_day if filter_date_start.present? && filter_date_end.present?
        end

        def result
        	get_data_via_xray_or_lab_code
        end

        private

        def get_data_via_xray_or_lab_code
            puts "QUERY DATE=#{@query_date.present?}"
            @previous_year = Time.now.prev_year

            if code.first == "L"
                if @query_date.present?
                    data  = Laboratory.joins(:doctors, doctors: [:town, :state]).where(code: code, doctors: {created_at: @query_date}).select(clinic_allocation_select_query)
                else
                    data  = Laboratory.joins(:doctors, doctors: [:town, :state]).where(code: code).select(clinic_allocation_select_query)
                end
              
            else code.first == "X"
                if @query_date.present?
                    data  = XrayFacility.joins(:doctors, doctors: [:town, :state]).where(code: code, doctors: {created_at: @query_date}).select(clinic_allocation_select_query)
                else
                    data  = XrayFacility.joins(:doctors, doctors: [:town, :state]).where(code: code).select(clinic_allocation_select_query)
                end
            end
        end

        def clinic_allocation_select_query
            "
                doctors.code as doc_code, 
                doctors.name as doc_name,
                doctors.clinic_name as clinic_name,
                concat(doctors.address1,' ', doctors.address2,' ', doctors.address3,' ', doctors.address4,' ', doctors.postcode,' ', towns.name,' ', states.name) as address, 
                towns.name as district,
                doctors.status as doc_status, 
                doctors.quota_used as w_count,
                (SELECT count(*) FROM transactions WHERE doctor_id=doctors.id and transaction_date >= (date_trunc('year', current_date-1) + INTERVAL '-1 year')  and transaction_date < date_trunc('year', current_date) ) as previous_count
            "
        end
    
    end
end
