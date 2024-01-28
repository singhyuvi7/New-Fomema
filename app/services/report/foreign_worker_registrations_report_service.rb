module Report
  class ForeignWorkerRegistrationsReportService
    attr_reader :start_date, :end_date

    def initialize(start_date, end_date, date_source)
      @start_date 	   = start_date
      @end_date 	     = end_date
      @date_source     = date_source
    end

    def result
    	set_transactions
    end

    private

    def set_transactions
      data 	= Transaction.left_outer_joins(
                      :xray_examination, 
                      :laboratory_examination
                    )
                    .joins(
                      :laboratory, 
                      :organization, 
                      :fw_job_type, 
                      :doctor,
                      :xray_facility,
                      employer: [:town, :state], 
                      foreign_worker: [:country]
                    )
                    .send(:"#{@date_source}_between", @start_date, @end_date)
                    .order(@date_source.to_sym)
                    .select(
                      :fw_code,
                      :transaction_date,
                      :medical_examination_date,
                      'xray_examinations.xray_taken_date as xray_taken_date',
                      :xray_transmit_date,
                      'laboratory_examinations.specimen_taken_date as lab_exam_specimen_taken_date',
                      'laboratory_examinations.specimen_received_date as lab_exam_specimen_received_date',
                      :laboratory_transmit_date,
                      :certification_date,
                      'organizations.code as org_code',
                      :registration_type,
                      :fw_pati,
                      :reg_ind,
                      :fw_plks_number,
                      'job_types.name as fw__job_type_name',
                      :fw_gender,
                      'doctors.code as gp_code',
                      'doctors.name as gp_name',
                      'doctors.clinic_name as gp_clinic_name',
                      'doctors.status as gp_status',
                      'xray_facilities.code as xray_code',
                      'xray_facilities.name as xray_name',
                      'xray_facilities.status as xray_status',
                      'towns.name as emp_town_name',
                      'states.name as emp_state_name',
                      'countries.name as fw__country_name',
                      'laboratories.code as lab_code',
                      'laboratories.name as lab_name',
                      'laboratories.status as lab_status',
                      :final_result
                    )
    end
    
  end
end
