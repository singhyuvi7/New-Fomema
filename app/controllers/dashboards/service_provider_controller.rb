class Dashboards::ServiceProviderController < InternalController

  def index
    @current_year = Time.now.year
    @doctorsactive = Doctor.where(status: 'ACTIVE').count
    @doctornew = Doctor.where("extract(year from created_at) = ?", @current_year).count
    @doctorwithdrawl = Doctor.joins("join status_schedules on status_schedules.status_scheduleable_id=doctors.id").where("doctors.status=? and status_schedules.status_reason IN(?)", 'INACTIVE', ["01", "02"]).count
    @doctordemised = Doctor.joins("join status_schedules on status_schedules.status_scheduleable_id=doctors.id").where('doctors.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', '07').count
    @doctornoncomp = Doctor.joins("join status_schedules on status_schedules.status_scheduleable_id=doctors.id").where('doctors.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', ["06", "03"]).count
    @doctorstates = Doctor.joins(:state).where('doctors.status=?', 'ACTIVE').group('states.name').count

    @laboratoriesactive = Laboratory.where(status: 'ACTIVE').count
    @laboratoriesnew = Laboratory.where("extract(year from created_at) = ?", @current_year).count
    @laboratorywithdrawl = Laboratory.joins("join status_schedules on status_schedules.status_scheduleable_id=laboratories.id").where('laboratories.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', ["01", "02"]).count
    @laboratorydemised = Laboratory.joins("join status_schedules on status_schedules.status_scheduleable_id=laboratories.id").where('laboratories.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', '07').count
    @laboratorynoncomp = Laboratory.joins("join status_schedules on status_schedules.status_scheduleable_id=laboratories.id").where('laboratories.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', ["06", "03"]).count
    @laboratoriesstates = Laboratory.joins(:state).where('laboratories.status=?', 'ACTIVE').group('states.name').count

    @xrayfacilityactive = XrayFacility.where(status: 'ACTIVE').count
    @xrayfacilitynew = XrayFacility.where("extract(year from created_at) = ?", @current_year).count
    @xrayfacilitywithdrawl = XrayFacility.joins("join status_schedules on status_schedules.status_scheduleable_id=xray_facilities.id").where('xray_facilities.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', ["01", "02"]).count
    @xrayfacilitydemised = XrayFacility.joins("join status_schedules on status_schedules.status_scheduleable_id=xray_facilities.id").where('xray_facilities.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', '07').count
    @xrayfacilitynoncomp = XrayFacility.joins("join status_schedules on status_schedules.status_scheduleable_id=xray_facilities.id").where('xray_facilities.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', ["06", "03"]).count
    @xrayfacilitiesstates = XrayFacility.joins(:state).where('xray_facilities.status=?', 'ACTIVE').group('states.name').count

    @radiologistactive = Radiologist.where(status: 'ACTIVE').count
    @radiologistnew = Radiologist.where("extract(year from created_at) = ?", @current_year).count
    @radiologistwithdrawl = Radiologist.joins("join status_schedules on status_schedules.status_scheduleable_id=radiologists.id").where('radiologists.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', ["01", "02"]).count
    @radiologistdemised = Radiologist.joins("join status_schedules on status_schedules.status_scheduleable_id=radiologists.id").where('radiologists.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', '07').count
    @radiologistnoncomp = Radiologist.joins("join status_schedules on status_schedules.status_scheduleable_id=radiologists.id").where('radiologists.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', ["06", "03"]).count
    @radiologiststates = Radiologist.joins(:state).where('radiologists.status=?', 'ACTIVE').group('states.name').count

  end

  def apply_filter
    results = {}
    @filter_params = JSON.parse(params[:filter_params]) rescue nil
    if @filter_params.present? && @filter_params['DateRange'].present? && @filter_params['doctor'].empty? && @filter_params['lab'].empty? && @filter_params['xray'].empty?
      date_range = @filter_params['DateRange'].split(' - ').map { |date| Date.parse(date) }
      start_date = date_range[0]
      end_date = date_range[1]
      @doctorsactive = Doctor.where(created_at: start_date..end_date).where(status: 'ACTIVE').count
      @doctornew = Doctor.where(created_at: start_date..end_date).count

      @doctorwithdrawl = Doctor.joins("JOIN status_schedules ON status_schedules.status_scheduleable_id = doctors.id")
                               .where("doctors.created_at BETWEEN ? AND ?", start_date, end_date)
                               .where("doctors.status = 'INACTIVE' AND status_schedules.status_reason IN ('01', '02') and status_schedules.status_scheduleable_type = 'Doctor'")
                               .count

      @doctordemised = Doctor.joins("JOIN status_schedules ON status_schedules.status_scheduleable_id = doctors.id")
                             .where("doctors.created_at BETWEEN ? AND ?", start_date, end_date)
                             .where("doctors.status = 'INACTIVE' AND status_schedules.status_reason = '07' and status_schedules.status_scheduleable_type = 'Doctor'")
                             .count

      @doctornoncomp = Doctor.joins("JOIN status_schedules ON status_schedules.status_scheduleable_id = doctors.id")
                             .where("doctors.created_at BETWEEN ? AND ?", start_date, end_date)
                             .where("doctors.status = 'INACTIVE' AND status_schedules.status_reason IN ('06', '03') and status_schedules.status_scheduleable_type = 'Doctor'")
                             .count
      @doctorstates = Doctor.joins(:state).where('doctors.status=?', 'ACTIVE').where(created_at: start_date..end_date).group('states.name').count

      @laboratoriesactive = Laboratory.where(created_at: start_date..end_date).where(status: 'ACTIVE').count
      @laboratoriesnew = Laboratory.where(created_at: start_date..end_date).count
      @laboratorywithdrawl = Laboratory.joins("join status_schedules on status_schedules.status_scheduleable_id=laboratories.id").where("laboratories.created_at BETWEEN ? AND ?", start_date, end_date).where('laboratories.status=? and status_schedules.status_reason IN(?) and status_schedules.status_scheduleable_type = ?', 'INACTIVE', ["01", "02"], 'Laboratory').count
      @laboratorydemised = Laboratory.joins("join status_schedules on status_schedules.status_scheduleable_id=laboratories.id").where("laboratories.created_at BETWEEN ? AND ?", start_date, end_date).where('laboratories.status=? and status_schedules.status_reason IN(?) and status_schedules.status_scheduleable_type = ?', 'INACTIVE', '07', 'Laboratory').count
      @laboratorynoncomp = Laboratory.joins("join status_schedules on status_schedules.status_scheduleable_id=laboratories.id").where("laboratories.created_at BETWEEN ? AND ?", start_date, end_date).where('laboratories.status=? and status_schedules.status_reason IN(?) and status_schedules.status_scheduleable_type = ?', 'INACTIVE', ["06", "03"], 'Laboratory').count
      @laboratoriesstates = Laboratory.joins(:state).where('laboratories.status=?', 'ACTIVE').where(created_at: start_date..end_date).group('states.name').count

      @xrayfacilityactive = XrayFacility.where(created_at: start_date..end_date).where(status: 'ACTIVE').count
      @xrayfacilitynew = XrayFacility.where(created_at: start_date..end_date).count
      @xrayfacilitywithdrawl = XrayFacility.joins("join status_schedules on status_schedules.status_scheduleable_id=xray_facilities.id").where("xray_facilities.created_at BETWEEN ? AND ?", start_date, end_date).where('xray_facilities.status=? and status_schedules.status_reason IN(?) and status_schedules.status_scheduleable_type = ?', 'INACTIVE', ["01", "02"], 'XrayFacility').count
      @xrayfacilitydemised = XrayFacility.joins("join status_schedules on status_schedules.status_scheduleable_id=xray_facilities.id").where("xray_facilities.created_at BETWEEN ? AND ?", start_date, end_date).where('xray_facilities.status=? and status_schedules.status_reason IN(?) and status_schedules.status_scheduleable_type = ?', 'INACTIVE', '07', 'XrayFacility').count
      @xrayfacilitynoncomp = XrayFacility.joins("join status_schedules on status_schedules.status_scheduleable_id=xray_facilities.id").where("xray_facilities.created_at BETWEEN ? AND ?", start_date, end_date).where('xray_facilities.status=? and status_schedules.status_reason IN(?) and status_schedules.status_scheduleable_type = ?', 'INACTIVE', ["06", "03"], 'XrayFacility').count
      @xrayfacilitiesstates = XrayFacility.joins(:state).where('xray_facilities.status=?', 'ACTIVE').where(created_at: start_date..end_date).group('states.name').count

      @radiologistactive = Radiologist.where(created_at: start_date..end_date).where(status: 'ACTIVE').count
      @radiologistnew = Radiologist.where(created_at: start_date..end_date).count
      @radiologistwithdrawl = Radiologist.joins("join status_schedules on status_schedules.status_scheduleable_id=radiologists.id").where("radiologists.created_at BETWEEN ? AND ?", start_date, end_date).where('radiologists.status=? and status_schedules.status_reason IN(?) and status_schedules.status_scheduleable_type = ?', 'INACTIVE', ["01", "02"], 'Radiologist').count
      @radiologistdemised = Radiologist.joins("join status_schedules on status_schedules.status_scheduleable_id=radiologists.id").where("radiologists.created_at BETWEEN ? AND ?", start_date, end_date).where('radiologists.status=? and status_schedules.status_reason IN(?) and status_schedules.status_scheduleable_type = ?', 'INACTIVE', '07', 'Radiologist').count
      @radiologistnoncomp = Radiologist.joins("join status_schedules on status_schedules.status_scheduleable_id=radiologists.id").where("radiologists.created_at BETWEEN ? AND ?", start_date, end_date).where('radiologists.status=? and status_schedules.status_reason IN(?) and status_schedules.status_scheduleable_type = ?', 'INACTIVE', ["06", "03"], 'Radiologist').count
      @radiologiststates = Radiologist.joins(:state).where('radiologists.status=?', 'ACTIVE').where(created_at: start_date..end_date).group('states.name').count

      results.merge!({
                       doctorsactive: @doctorsactive,
                       doctorsnew: @doctornew,
                       doctorswithdrawal: @doctorwithdrawl,
                       doctorsdemised: @doctordemised,
                       doctorsnoncomp: @doctornoncomp,
                       doctorsstates: @doctorstates,
                       laboratoriesactive: @laboratoriesactive,
                       laboratoriesnew: @laboratoriesnew,
                       laboratorieswithdrawal: @laboratorywithdrawl,
                       laboratoriesdemised: @laboratorydemised,
                       laboratoriesnoncomp: @laboratorynoncomp,
                       laboratoriesstates: @laboratoriesstates,
                       xrayfacilityactive: @xrayfacilityactive,
                       xrayfacilitynew: @xrayfacilitynew,
                       xrayfacilitywithdrawal: @xrayfacilitywithdrawl,
                       xrayfacilitydemised: @xrayfacilitydemised,
                       xrayfacilitynoncomp: @xrayfacilitynoncomp,
                       xrayfacilitiesstates: @xrayfacilitiesstates,
                       radiologistactive: @radiologistactive,
                       radiologistnew: @radiologistnew,
                       radiologistwithdrawal: @radiologistwithdrawl,
                       radiologistdemised: @radiologistdemised,
                       radiologistnoncomp: @radiologistnoncomp,
                       radiologiststates: @radiologiststates
                     })
    end

    if @filter_params.present? && @filter_params['doctor'].present?
      doctor_code = @filter_params['doctor']
      doctor_exists = Doctor.exists?(code: doctor_code)

      unless doctor_exists
        render json: { error: 'Invalid doctor code' }, status: :unprocessable_entity
        return
      end

      @certifydoctoroverallcount = Transaction.joins(:doctor).where(doctors: { code: doctor_code }).where("laboratory_transmit_date is not null and xray_transmit_date is not null and  certification_date is not null ").count

      # doctor xrays within 24 hours
      @certifydoctorxrayyes = Transaction.joins(:doctor).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date>xray_transmit_date and  DATE_PART('Day',certification_date - xray_transmit_date) < 1 and doctors.code=?", doctor_code).count

      # doctor labs within 24 hours
      @certifydoctorlabyes = Transaction.joins(:doctor).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date<xray_transmit_date and  DATE_PART('Day',certification_date - laboratory_transmit_date) < 1 and doctors.code=?", doctor_code).count

      @certifydoctorwithin24hours = @certifydoctorxrayyes + @certifydoctorlabyes

      @certifydoctorcomply = (@certifydoctoroverallcount != 0) ? ((@certifydoctorwithin24hours / @certifydoctoroverallcount.to_f) * 100).round(1) : 0

      @certifydoctoraccuracycount = Transaction.joins(:transaction_result_updates).joins(:doctor).where(doctors: { code: doctor_code }).where("laboratory_transmit_date is not null and xray_transmit_date is not null and  certification_date is not null").where(transaction_result_updates: { wrong_transmission_doctor: { not: nil } }).count
      @doctoraccuracycertified = Transaction.joins(:transaction_result_updates).joins(:doctor).where("transactions.status not in ('CANCELLED','REJECTED') and transactions.certification_date is not null and doctors.code IN(?)", doctor_code).count
      @doctoraccuracywrongtransmission = Transaction.joins(:transaction_result_updates).joins(:doctor).where("transactions.status not in ('CANCELLED','REJECTED') and transaction_result_updates.wrong_transmission_doctor='TRUE' and doctors.code IN(?)", doctor_code).count

      @doctoraccuracy_comply = (@certifydoctoraccuracycount != 0) ? ((@doctoraccuracycertified / @certifydoctoraccuracycount.to_f) * 100).round(1) : 0

      @doctor_total_percentage = (@certifydoctorcomply + @doctoraccuracy_comply) / 200

      @doctor_grade = performance_grading(@doctor_total_percentage)

      results.merge!({ doctorgrade: @doctor_grade })

    elsif @filter_params.present? && @filter_params['lab'].present?

      lab_code = @filter_params['lab']

      lab_exists = Laboratory.exists?(code: lab_code)

      unless lab_exists
        render json: { error: 'Invalid laboratory code' }, status: :unprocessable_entity
        return
      end

      @laboratoryoverallcount = Transaction.joins(" JOIN laboratory_examinations ON laboratory_examinations.transaction_id = transactions.id ").joins("JOIN laboratories ON laboratories.id = transactions.laboratory_id").where("laboratories.code =  '#{lab_code}'").where("transactions.laboratory_transmit_date is not null and laboratory_examinations.specimen_taken_date is not null and  certification_date is not null ").count
      @laboratorydonutwithin48 = Transaction.joins(" JOIN laboratory_examinations ON laboratory_examinations.transaction_id = transactions.id ").joins("JOIN laboratories ON laboratories.id = transactions.laboratory_id").where("laboratories.code = '#{lab_code}'").where("transactions.status not in ('CANCELLED', 'REJECTED')  and DATE_PART('Day', transactions.laboratory_transmit_date - laboratory_examinations.specimen_taken_date) < 2 ").count
      @laboratorydonutbeyond48 = Transaction.joins(" JOIN laboratory_examinations ON laboratory_examinations.transaction_id = transactions.id ").where("laboratories.code = '#{lab_code}'").where(" transactions.status not in ('CANCELLED', 'REJECTED') and DATE_PART('Day', transactions.laboratory_transmit_date - laboratory_examinations.specimen_taken_date) > 2 ")

      @laboratory_comply = (@laboratoryoverallcount != 0) ? ((@laboratorydonutwithin48 / @laboratoryoverallcount.to_f) * 100).round(1) : 0

      @lab_grade = performance_grading(@laboratory_comply)

      results.merge!({ lab_grade: @lab_grade })
    elsif @filter_params.present? && @filter_params['xray'].present?

      xray_code = @filter_params['xray']

      xray_exists = XrayFacility.exists?(code: xray_code)

      unless xray_exists
        render json: { error: 'Invalid xray code' }, status: :unprocessable_entity
        return
      end

      @xraytransmissionoverallcount = Transaction.joins("JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id").joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where("xray_examinations.transmitted_at is not null and xray_examinations.xray_taken_date is not null and  certification_date is not null ").where("xray_facilities.code = '#{xray_code}'").count

      @self_reporting_within24hours = Transaction.joins("JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id").joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where(" transactions.radiologist_id IS NULL AND transactions.status NOT IN ('CANCELLED', 'REJECTED') AND xray_facilities.radiologist_operated IN ('TRUE', 'FALSE') ").where("xray_facilities.code = '#{xray_code}'").where("DATE_PART('Day', xray_examinations.transmitted_at - xray_examinations.xray_taken_date) < 1").count

      @self_reporting_beyond24hours = Transaction.joins("JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id").joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where(" transactions.radiologist_id IS NULL AND transactions.status NOT IN ('CANCELLED', 'REJECTED') AND xray_facilities.radiologist_operated IN ('TRUE', 'FALSE') ").where("xray_facilities.code = '#{xray_code}'").where("DATE_PART('Day', xray_examinations.transmitted_at - xray_examinations.xray_taken_date) > 1").count

      @radiologist_reporting_within48hours = Transaction.joins("JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id").joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where(" transactions.radiologist_id IS NOT NULL AND transactions.status NOT IN ('CANCELLED', 'REJECTED') AND xray_facilities.radiologist_operated IN ('TRUE', 'FALSE') ").where("xray_facilities.code = '#{xray_code}'").where("DATE_PART('Day', xray_examinations.transmitted_at - xray_examinations.xray_taken_date) < 2 ").count

      @radiologist_reporting_beyond48hours = Transaction.joins("JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id").joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where(" transactions.radiologist_id IS NOT NULL AND transactions.status NOT IN ('CANCELLED', 'REJECTED') AND xray_facilities.radiologist_operated IN ('TRUE', 'FALSE') ").where("xray_facilities.code = '#{xray_code}'").where("DATE_PART('Day', xray_examinations.transmitted_at - xray_examinations.xray_taken_date) > 2 ").count

      @self_report_comply = (@xraytransmissionoverallcount != 0) ? ((@self_reporting_within24hours / @xraytransmissionoverallcount.to_f) * 100).round(1) : 0

      @radiologist_report_comply = (@xraytransmissionoverallcount != 0) ? ((@radiologist_reporting_within48hours / @xraytransmissionoverallcount.to_f) * 100).round(1) : 0

      @xraytransmissionoverallcount = Transaction.joins("JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id").joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where("xray_examinations.transmitted_at is not null and xray_examinations.xray_taken_date is not null and  certification_date is not null ").where("xray_facilities.code = '#{xray_code}'").count
      @qualitycompliance = Transaction.joins(" join xray_facilities on xray_facilities.id = transactions.xray_facility_id ").where("xray_facilities.code = '#{xray_code}'").where("transactions.status not IN('CANCELLED','REJECTED')").count

      @xrayqualitycompliance = (@xraytransmissionoverallcount != 0) ? ((@qualitycompliance / @xraytransmissionoverallcount.to_f) * 100).round(1) : 0

      @xray_grad_total_percentage = (@self_report_comply + @radiologist_report_comply + @xrayqualitycompliance) / 3

      @xray_grade = performance_grading(@xray_grad_total_percentage)

      results.merge!({ xray_grade: @xray_grade })

    end

    render json: results
  end

  def quota_usage_by_doctor

    @filter_params = JSON.parse(params[:filter_params]) rescue nil

    if @filter_params.present? && (@filter_params['doctor'].present?)
      @doctorquotausagezero = 100
      @doctorquotausage1to100 = 500
      @doctorquotausage101to200 = Doctor.where(quota_used: 101..200, code: @filter_params['doctor']).count
      @doctorquotausage201to300 = Doctor.where(quota_used: 201..300, code: @filter_params['doctor']).count
      @doctorquotausage301to400 = Doctor.where(quota_used: 301..400, code: @filter_params['doctor']).count
      @doctorquotausage401to500 = Doctor.where(quota_used: 401..500, code: @filter_params['doctor']).count
      @doctorquotausage501to600 = Doctor.where(quota_used: 501..600, code: @filter_params['doctor']).count
      @doctorquotausage601to700 = Doctor.where(quota_used: 601..700, code: @filter_params['doctor']).count
      @doctorquotausage701to800 = Doctor.where(quota_used: 701..800, code: @filter_params['doctor']).count
    elsif @filter_params.present? && (@filter_params['DateRange'].present?)
      date_range = @filter_params['DateRange'].split(' - ').map { |date| Date.parse(date) }
      start_date = date_range[0]
      end_date = date_range[1]
      @doctorquotausagezero = Doctor.where(quota_used: 0, created_at: date_range[0]..date_range[1]).count
      @doctorquotausage1to100 = Doctor.where(quota_used: 1..100, created_at: start_date..end_date).count
      @doctorquotausage101to200 = Doctor.where(quota_used: 101..200, created_at: start_date..end_date).count
      @doctorquotausage201to300 = Doctor.where(quota_used: 201..300, created_at: start_date..end_date).count
      @doctorquotausage301to400 = Doctor.where(quota_used: 301..400, created_at: start_date..end_date).count
      @doctorquotausage401to500 = Doctor.where(quota_used: 401..500, created_at: start_date..end_date).count
      @doctorquotausage501to600 = Doctor.where(quota_used: 501..600, created_at: start_date..end_date).count
      @doctorquotausage601to700 = Doctor.where(quota_used: 601..700, created_at: start_date..end_date).count
      @doctorquotausage701to800 = Doctor.where(quota_used: 701..800, created_at: start_date..end_date).count
    else
      @doctorquotausagezero = Doctor.where(quota_used: 0).count
      @doctorquotausage1to100 = Doctor.where(quota_used: 1..100).count
      @doctorquotausage101to200 = Doctor.where(quota_used: 101..200).count
      @doctorquotausage201to300 = Doctor.where(quota_used: 201..300).count
      @doctorquotausage301to400 = Doctor.where(quota_used: 301..400).count
      @doctorquotausage401to500 = Doctor.where(quota_used: 401..500).count
      @doctorquotausage501to600 = Doctor.where(quota_used: 501..600).count
      @doctorquotausage601to700 = Doctor.where(quota_used: 601..700).count
      @doctorquotausage701to800 = Doctor.where(quota_used: 701..800).count
    end

    respond_to do |format|
      format.json {
        render json: {
          zero: @doctorquotausagezero,
          oneToHundred: @doctorquotausage1to100,
          oneTwoHundred: @doctorquotausage101to200,
          ThreeHundred: @doctorquotausage201to300,
          fourHundred: @doctorquotausage301to400,
          fiveHundred: @doctorquotausage401to500,
          sixHundred: @doctorquotausage501to600,
          sevenHundred: @doctorquotausage601to700,
          eightHundred: @doctorquotausage701to800
        }
      }
    end
  end

  def certification_by_doctor

    @filter_params = JSON.parse(params[:filter_params]) rescue nil

    if @filter_params.present? && @filter_params['doctor'].present?
      doctor_code = @filter_params['doctor']
      @certifydoctoroverallcount = Transaction.joins(:doctor).where(doctors: { code: doctor_code }).where("laboratory_transmit_date is not null and xray_transmit_date is not null and  certification_date is not null ").count

      # doctor xrays within 24 hours
      @certifydoctorxrayyes = Transaction.joins(:doctor).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date>xray_transmit_date and  DATE_PART('Day',certification_date - xray_transmit_date) < 1 and doctors.code=?", doctor_code).count

      # doctor labs within 24 hours
      @certifydoctorlabyes = Transaction.joins(:doctor).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date<xray_transmit_date and  DATE_PART('Day',certification_date - laboratory_transmit_date) < 1 and doctors.code=?", doctor_code).count

      @certifydoctorwithin24hours = @certifydoctorxrayyes + @certifydoctorlabyes

      @certifydoctorcomply = (@certifydoctoroverallcount != 0) ? ((@certifydoctorwithin24hours / @certifydoctoroverallcount.to_f) * 100).round(1) : 0

    elsif @filter_params.present? && (@filter_params['DateRange'].present?)

      start_date_str, end_date_str = @filter_params['DateRange'].split(' - ').map(&:strip)
      start_date = Date.strptime(start_date_str, '%Y-%m-%d') unless start_date_str.blank?
      end_date = Date.strptime(end_date_str, '%Y-%m-%d') unless end_date_str.blank?

      @certifydoctoroverallcount = Transaction.joins(:doctor).where(created_at: start_date..end_date).where("laboratory_transmit_date is not null and xray_transmit_date is not null and  certification_date is not null ").count

      # doctor xrays within 24 hours
      @certifydoctorxrayyes = Transaction.joins(:doctor).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date > xray_transmit_date and DATE_PART('Day', certification_date - xray_transmit_date) < 1 and transactions.created_at BETWEEN ? AND ?", start_date, end_date).count

      # doctor labs within 24 hours
      @certifydoctorlabyes = Transaction.joins(:doctor).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date<xray_transmit_date and  DATE_PART('Day',certification_date - laboratory_transmit_date) < 1 and transactions.created_at BETWEEN ? AND ?", start_date, end_date).count

      # doctor xrays beyond 24 hours
      @certifydoctorxrayno = Transaction.joins(:doctor).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date>xray_transmit_date and  DATE_PART('Day',certification_date - xray_transmit_date) > 1 and transactions.created_at BETWEEN ? AND ?", start_date, end_date).count

      # doctor labs beyond 24 hours
      @certifydoctorlabno = Transaction.joins(:doctor).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date<xray_transmit_date and  DATE_PART('Day',certification_date - laboratory_transmit_date) > 1 and transactions.created_at BETWEEN ? AND ?", start_date, end_date).count

      @certifydoctorwithin24hours = @certifydoctorxrayyes + @certifydoctorlabyes

      @certifydoctorbeyond24hours = @certifydoctorxrayno + @certifydoctorlabno

      @doctorcomplywithin24hours = (@certifydoctoroverallcount != 0) ? ((@certifydoctorwithin24hours / @certifydoctoroverallcount.to_f) * 100).round(1) : 0

      @doctorcomplybeyond24hours = (@certifydoctoroverallcount != 0) ? ((@certifydoctorbeyond24hours / @certifydoctoroverallcount.to_f) * 100).round(1) : 0

      @certifydoctorcomplycount = @doctorcomplywithin24hours

      if @doctorcomplybeyond24hours < 15
        @certifydoctorcomplycount += 1
      end
      @certifydoctorcomply = (@certifydoctoroverallcount != 0) ? ((@certifydoctorcomplycount / @certifydoctoroverallcount.to_f) * 100).round(1) : 0

    else
      @certifydoctoroverallcount = Transaction.joins(:doctor).where("EXTRACT(year FROM transactions.created_at) = ?", Date.today.year).where("laboratory_transmit_date is not null and xray_transmit_date is not null and certification_date is not null").count

      # doctor xrays within 24 hours
      @certifydoctorxrayyes = Transaction.joins(:doctor).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date>xray_transmit_date and  DATE_PART('Day',certification_date - xray_transmit_date) < 1 and EXTRACT(year FROM transactions.created_at) = ?", Date.today.year).count

      # doctor labs within 24 hours
      @certifydoctorlabyes = Transaction.joins(:doctor).where("laboratory_transmit_date is not null and xray_transmit_date is not null and laboratory_transmit_date<xray_transmit_date and  DATE_PART('Day',certification_date - laboratory_transmit_date) < 1and EXTRACT(year FROM transactions.created_at) = ?", Date.today.year).count

      @certifydoctorwithin24hours = @certifydoctorxrayyes + @certifydoctorlabyes

      @certifydoctorcomply = (@certifydoctoroverallcount != 0) ? ((@certifydoctorwithin24hours / @certifydoctoroverallcount.to_f) * 100).round(1) : 0

    end

    respond_to do |format|
      format.json {
        render json: {
          certification_by_doc: @certifydoctorcomply
        }
      }
    end

  end

  def laboratory_result_transmission

    @filter_params = JSON.parse(params[:filter_params]) rescue nil

    if @filter_params.present? && @filter_params['lab'].present?
      lab_code = @filter_params['lab']
      @laboratoryoverallcount = Transaction.joins(" JOIN laboratory_examinations ON laboratory_examinations.transaction_id = transactions.id ").joins("JOIN laboratories ON laboratories.id = transactions.laboratory_id").where("laboratories.code =  '#{lab_code}'").where("transactions.laboratory_transmit_date is not null and laboratory_examinations.specimen_taken_date is not null and  certification_date is not null ").count
      @laboratorydonutwithin48 = Transaction.joins(" JOIN laboratory_examinations ON laboratory_examinations.transaction_id = transactions.id ").joins("JOIN laboratories ON laboratories.id = transactions.laboratory_id").where("laboratories.code = '#{lab_code}'").where("transactions.status not in ('CANCELLED', 'REJECTED')  and DATE_PART('Day', transactions.laboratory_transmit_date - laboratory_examinations.specimen_taken_date) < 2 ").count
      @laboratorydonutbeyond48 = Transaction.joins(" JOIN laboratory_examinations ON laboratory_examinations.transaction_id = transactions.id ").joins("JOIN laboratories ON laboratories.id = transactions.laboratory_id").where("laboratories.code = '#{lab_code}'").where(" transactions.status not in ('CANCELLED', 'REJECTED') and DATE_PART('Day', transactions.laboratory_transmit_date - laboratory_examinations.specimen_taken_date) > 2 ")

      @laboratory_comply = (@laboratoryoverallcount != 0) ? ((@laboratorydonutwithin48 / @laboratoryoverallcount.to_f) * 100).round(1) : 0

    elsif @filter_params.present? && (@filter_params['DateRange'].present?)
      start_date_str, end_date_str = @filter_params['DateRange'].split(' - ').map(&:strip)
      start_date = Date.strptime(start_date_str, '%Y-%m-%d') unless start_date_str.blank?
      end_date = Date.strptime(end_date_str, '%Y-%m-%d') unless end_date_str.blank?

      @laboratoryoverallcount = Transaction.joins(" JOIN laboratory_examinations ON laboratory_examinations.transaction_id = transactions.id ").joins("JOIN laboratories ON laboratories.id = transactions.laboratory_id").where(created_at: start_date..end_date).where("transactions.laboratory_transmit_date is not null and laboratory_examinations.specimen_taken_date is not null and  certification_date is not null ").count

      @laboratorydonutwithin48 = Transaction.joins(" JOIN laboratory_examinations ON laboratory_examinations.transaction_id = transactions.id ").where(created_at: start_date..end_date).where(" transactions.status not in ('CANCELLED', 'REJECTED')  and DATE_PART('Day', transactions.laboratory_transmit_date - laboratory_examinations.specimen_taken_date) < 2 ").count

      @laboratorydonutbeyond48 = Transaction.joins(" JOIN laboratory_examinations ON laboratory_examinations.transaction_id = transactions.id ").where(created_at: start_date..end_date).where(" transactions.status not in ('CANCELLED', 'REJECTED') and DATE_PART('Day', transactions.laboratory_transmit_date - laboratory_examinations.specimen_taken_date) > 2 ").count

      @laboratorycomplycount = @laboratorydonutwithin48

      if @laboratorydonutbeyond48 < 15
        @laboratorycomplycount += 1
      end
      @laboratory_comply = (@laboratoryoverallcount != 0) ? ((@laboratorycomplycount / @laboratoryoverallcount.to_f) * 100).round(1) : 0
    else
      @laboratoryoverallcount = Transaction.joins(" JOIN laboratory_examinations ON laboratory_examinations.transaction_id = transactions.id ").where("extract(year from transactions.created_at) = ?", Date.today.year).where("transactions.laboratory_transmit_date is not null and laboratory_examinations.specimen_taken_date is not null and  certification_date is not null ").count

      @laboratorydonutwithin48 = Transaction.joins(" JOIN laboratory_examinations ON laboratory_examinations.transaction_id = transactions.id ").where("extract(year from transactions.created_at) = ?", Date.today.year).where(" transactions.status not in ('CANCELLED', 'REJECTED')  and DATE_PART('Day', transactions.laboratory_transmit_date - laboratory_examinations.specimen_taken_date) < 2 ").count

      @laboratorydonutbeyond48 = Transaction.joins(" JOIN laboratory_examinations ON laboratory_examinations.transaction_id = transactions.id ").where("extract(year from transactions.created_at) = ?", Date.today.year).where(" transactions.status not in ('CANCELLED', 'REJECTED') and DATE_PART('Day', transactions.laboratory_transmit_date - laboratory_examinations.specimen_taken_date) > 2 ").count

      @laboratory_comply = (@laboratoryoverallcount != 0) ? ((@laboratorydonutwithin48 / @laboratoryoverallcount.to_f) * 100).round(1) : 0
    end

    respond_to do |format|
      format.json {
        render json: {
          labwithin48: @laboratorydonutwithin48,
          labbeyond48: @laboratorydonutbeyond48
        }
      }
    end

  end

  def xray_transmission

    @filter_params = JSON.parse(params[:filter_params]) rescue nil

    if @filter_params.present? && (@filter_params['xray'].present?)
      xray_code = @filter_params['xray']
      @xraytransmissionoverallcount = Transaction.joins("JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id").joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where("xray_examinations.transmitted_at is not null and xray_examinations.xray_taken_date is not null and  certification_date is not null ").where("xray_facilities.code = '#{xray_code}'").count

      @self_reporting_within24hours = Transaction.joins("JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id").joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where(" transactions.radiologist_id IS NULL AND transactions.status NOT IN ('CANCELLED', 'REJECTED') AND xray_facilities.radiologist_operated IN ('TRUE', 'FALSE') ").where("xray_facilities.code = '#{xray_code}'").where("DATE_PART('Day', xray_examinations.transmitted_at - xray_examinations.xray_taken_date) < 1").count

      @self_reporting_beyond24hours = Transaction.joins("JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id").joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where(" transactions.radiologist_id IS NULL AND transactions.status NOT IN ('CANCELLED', 'REJECTED') AND xray_facilities.radiologist_operated IN ('TRUE', 'FALSE') ").where("xray_facilities.code = '#{xray_code}'").where("DATE_PART('Day', xray_examinations.transmitted_at - xray_examinations.xray_taken_date) > 1").count

      @radiologist_reporting_within48hours = Transaction.joins("JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id").joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where(" transactions.radiologist_id IS NOT NULL AND transactions.status NOT IN ('CANCELLED', 'REJECTED') AND xray_facilities.radiologist_operated IN ('TRUE', 'FALSE') ").where("xray_facilities.code = '#{xray_code}'").where("DATE_PART('Day', xray_examinations.transmitted_at - xray_examinations.xray_taken_date) < 2 ").count

      @radiologist_reporting_beyond48hours = Transaction.joins("JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id").joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where(" transactions.radiologist_id IS NOT NULL AND transactions.status NOT IN ('CANCELLED', 'REJECTED') AND xray_facilities.radiologist_operated IN ('TRUE', 'FALSE') ").where("xray_facilities.code = '#{xray_code}'").where("DATE_PART('Day', xray_examinations.transmitted_at - xray_examinations.xray_taken_date) > 2 ").count

      @self_report_comply = (@xraytransmissionoverallcount != 0) ? ((@self_reporting_within24hours / @xraytransmissionoverallcount.to_f) * 100).round(1) : 0

      @radiologist_report_comply = (@xraytransmissionoverallcount != 0) ? ((@radiologist_reporting_within48hours / @xraytransmissionoverallcount.to_f) * 100).round(1) : 0

    elsif @filter_params.present? && (@filter_params['DateRange'].present?)
      start_date_str, end_date_str = @filter_params['DateRange'].split(' - ').map(&:strip)
      start_date = Date.strptime(start_date_str, '%Y-%m-%d') unless start_date_str.blank?
      end_date = Date.strptime(end_date_str, '%Y-%m-%d') unless end_date_str.blank?

      @xraytransmissionoverallcount = Transaction.joins("JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id").joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where("xray_examinations.transmitted_at is not null and xray_examinations.xray_taken_date is not null and  certification_date is not null ").where("transactions.created_at BETWEEN ? AND ?", start_date, end_date).count

      @self_reporting_within24hours = Transaction.joins("JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id").joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where(" transactions.radiologist_id IS NULL AND transactions.status NOT IN ('CANCELLED', 'REJECTED') AND xray_facilities.radiologist_operated IN ('TRUE', 'FALSE') ").where("DATE_PART('Day', xray_examinations.transmitted_at - xray_examinations.xray_taken_date) < 1").where("transactions.created_at BETWEEN ? AND ?", start_date, end_date).count

      @self_reporting_beyond24hours = Transaction.joins("JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id").joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where(" transactions.radiologist_id IS NULL AND transactions.status NOT IN ('CANCELLED', 'REJECTED') AND xray_facilities.radiologist_operated IN ('TRUE', 'FALSE') ").where("DATE_PART('Day', xray_examinations.transmitted_at - xray_examinations.xray_taken_date) > 1").where("transactions.created_at BETWEEN ? AND ?", start_date, end_date).count

      @radiologist_reporting_within48hours = Transaction.joins("JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id").joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where(" transactions.radiologist_id IS NOT NULL AND transactions.status NOT IN ('CANCELLED', 'REJECTED') AND xray_facilities.radiologist_operated IN ('TRUE', 'FALSE') ").where("DATE_PART('Day', xray_examinations.transmitted_at - xray_examinations.xray_taken_date) < 2 ").where("transactions.created_at BETWEEN ? AND ?", start_date, end_date).count

      @radiologist_reporting_beyond48hours = Transaction.joins("JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id").joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where(" transactions.radiologist_id IS NOT NULL AND transactions.status NOT IN ('CANCELLED', 'REJECTED') AND xray_facilities.radiologist_operated IN ('TRUE', 'FALSE') ").where("DATE_PART('Day', xray_examinations.transmitted_at - xray_examinations.xray_taken_date) > 2 ").where("transactions.created_at BETWEEN ? AND ?", start_date, end_date).count

      @self_report_comply_count = @self_reporting_within24hours

      if @self_reporting_beyond24hours < 15
        @self_report_comply_count += 1
      end

      @self_report_comply = (@xraytransmissionoverallcount != 0) ? ((@self_report_comply_count / @xraytransmissionoverallcount.to_f) * 100).round(1) : 0

      @radiologist_report_comply_count = @self_reporting_within24hours

      if @radiologist_reporting_beyond48hours < 15
        @radiologist_report_comply_count += 1
      end

      @radiologist_report_comply = (@xraytransmissionoverallcount != 0) ? ((@radiologist_report_comply_count / @xraytransmissionoverallcount.to_f) * 100).round(1) : 0

    else
      @xraytransmissionoverallcount = Transaction.joins("JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id").joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where("xray_examinations.transmitted_at is not null and xray_examinations.xray_taken_date is not null and  certification_date is not null ").where("extract(year from transactions.created_at) = ?", Date.today.year).count

      @self_reporting_within24hours = Transaction.joins("JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id").joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where(" transactions.radiologist_id IS NULL AND transactions.status NOT IN ('CANCELLED', 'REJECTED') AND xray_facilities.radiologist_operated IN ('TRUE', 'FALSE') ").where("DATE_PART('Day', xray_examinations.transmitted_at - xray_examinations.xray_taken_date) < 1").where("extract(year from transactions.created_at) = ?", Date.today.year).count

      @self_reporting_beyond24hours = Transaction.joins("JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id").joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where(" transactions.radiologist_id IS NULL AND transactions.status NOT IN ('CANCELLED', 'REJECTED') AND xray_facilities.radiologist_operated IN ('TRUE', 'FALSE') ").where("DATE_PART('Day', xray_examinations.transmitted_at - xray_examinations.xray_taken_date) > 1").where("extract(year from transactions.created_at) = ?", Date.today.year).count

      @radiologist_reporting_within48hours = Transaction.joins("JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id").joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where(" transactions.radiologist_id IS NOT NULL AND transactions.status NOT IN ('CANCELLED', 'REJECTED') AND xray_facilities.radiologist_operated IN ('TRUE', 'FALSE') ").where("DATE_PART('Day', xray_examinations.transmitted_at - xray_examinations.xray_taken_date) < 2 ").where("extract(year from transactions.created_at) = ?", Date.today.year).count

      @radiologist_reporting_beyond48hours = Transaction.joins("JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id").joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where(" transactions.radiologist_id IS NOT NULL AND transactions.status NOT IN ('CANCELLED', 'REJECTED') AND xray_facilities.radiologist_operated IN ('TRUE', 'FALSE') ").where("DATE_PART('Day', xray_examinations.transmitted_at - xray_examinations.xray_taken_date) > 2 ").where("extract(year from transactions.created_at) = ?", Date.today.year).count

      @self_report_comply = (@xraytransmissionoverallcount != 0) ? ((@self_reporting_within24hours / @xraytransmissionoverallcount.to_f) * 100).round(1) : 0

      @radiologist_report_comply = (@xraytransmissionoverallcount != 0) ? ((@radiologist_reporting_within48hours / @xraytransmissionoverallcount.to_f) * 100).round(1) : 0

    end

    respond_to do |format|
      format.json {
        render json: {
          self_reporting: @self_report_comply,
          radiologist_reporting: @radiologist_report_comply
        }
      }
    end

  end

  def xray_compliance

    if @filter_params.present? && (@filter_params['xray'].present?)
      xray_code = @filter_params['xray']
      @xraytransmissionoverallcount = Transaction.joins("JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id").joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where("xray_examinations.transmitted_at is not null and xray_examinations.xray_taken_date is not null and  certification_date is not null ").where("xray_facilities.code = '#{xray_code}'").count
      @qualitycompliance = Transaction.joins(" join xray_facilities on xray_facilities.id = transactions.xray_facility_id ").where("xray_facilities.code = '#{xray_code}'").where("transactions.status not IN('CANCELLED','REJECTED')").count

    elsif @filter_params.present? && (@filter_params['DateRange'].present?)
      start_date_str, end_date_str = @filter_params['DateRange'].split(' - ').map(&:strip)
      start_date = Date.strptime(start_date_str, '%Y-%m-%d') unless start_date_str.blank?
      end_date = Date.strptime(end_date_str, '%Y-%m-%d') unless end_date_str.blank?

      @xraytransmissionoverallcount = Transaction.joins("JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id").joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where("xray_examinations.transmitted_at is not null and xray_examinations.xray_taken_date is not null and  certification_date is not null ").where("transactions.created_at BETWEEN ? AND ?", start_date, end_date).count
      @qualitycompliance = Transaction.joins(" join xray_facilities on xray_facilities.id = transactions.xray_facility_id ").where("transactions.status not IN('CANCELLED','REJECTED')").where("transactions.created_at BETWEEN ? AND ?", start_date, end_date).count
    else
      @xraytransmissionoverallcount = Transaction.joins("JOIN xray_examinations ON xray_examinations.transaction_id = transactions.id").joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where("xray_examinations.transmitted_at is not null and xray_examinations.xray_taken_date is not null and  certification_date is not null ").where("extract(year from transactions.created_at) = ?", Date.today.year).count
      @qualitycompliance = Transaction.joins(" join xray_facilities on xray_facilities.id = transactions.xray_facility_id ").where("transactions.status not IN('CANCELLED','REJECTED') ").where("extract(year from transactions.created_at) = ?", Date.today.year).count

    end

    @xrayqualitycompliance = (@xraytransmissionoverallcount != 0) ? ((@qualitycompliance / @xraytransmissionoverallcount.to_f) * 100).round(1) : 0

    respond_to do |format|
      format.json {
        render json: {
          xray_compliance: @xrayqualitycompliance,
        }
      }
    end

  end

  def accuracy_transmission
    if @filter_params.present? && (@filter_params['doctor'].present?)
      doctor_code = @filter_params['doctor']
      @certifydoctoraccuracycount = Transaction.joins(:transaction_result_updates).joins(:doctor).where(doctors: { code: doctor_code }).where("laboratory_transmit_date is not null and xray_transmit_date is not null and  certification_date is not null").where(transaction_result_updates: { wrong_transmission_doctor: { not: nil } }).count
      @doctoraccuracycertified = Transaction.joins(:transaction_result_updates).joins(:doctor).where("transactions.status not in ('CANCELLED','REJECTED') and transactions.certification_date is not null and doctors.code IN(?)", doctor_code).count
      @doctoraccuracywrongtransmission = Transaction.joins(:transaction_result_updates).joins(:doctor).where("transactions.status not in ('CANCELLED','REJECTED') and transaction_result_updates.wrong_transmission_doctor='TRUE' and doctors.code IN(?)", doctor_code).count

      @doctoraccuracy_comply = (@certifydoctoraccuracycount != 0) ? ((@doctoraccuracycertified / @certifydoctoraccuracycount.to_f) * 100).round(1) : 0

    elsif @filter_params.present? && (@filter_params['DateRange'].present?)
      start_date_str, end_date_str = @filter_params['DateRange'].split(' - ').map(&:strip)
      start_date = Date.strptime(start_date_str, '%Y-%m-%d') unless start_date_str.blank?
      end_date = Date.strptime(end_date_str, '%Y-%m-%d') unless end_date_str.blank?

      @certifydoctoraccuracycount = Transaction.joins(:transaction_result_updates).joins(:doctor).where("laboratory_transmit_date is not null and xray_transmit_date is not null and  certification_date is not null").where(transaction_result_updates: { wrong_transmission_doctor: { not: nil } }).where("transactions.created_at BETWEEN ? AND ?", start_date, end_date).count
      @doctoraccuracycertified = Transaction.joins(:transaction_result_updates).joins(:doctor).joins(:doctor).where("transactions.status not in ('CANCELLED','REJECTED') and transactions.certification_date is not null and transactions.created_at BETWEEN ? AND ?", start_date, end_date).count
      @doctoraccuracywrongtransmission = Transaction.joins(:transaction_result_updates).joins(:doctor).where("transactions.status not in ('CANCELLED','REJECTED') and transaction_result_updates.wrong_transmission_doctor='TRUE' and transactions.created_at BETWEEN ? AND ?", start_date, end_date).count

      @transmission_accuracy = @certifydoctoraccuracycount - @doctoraccuracywrongtransmission

      @doctoraccuracy_comply = (@certifydoctoraccuracycount > 0) ? ((@transmission_accuracy / @certifydoctoraccuracycount.to_f) * 100).round(1) : 0

    else

      @certifydoctoraccuracycount = Transaction.joins(:transaction_result_updates).joins(:doctor).where("laboratory_transmit_date is not null and xray_transmit_date is not null and  certification_date is not null").where(transaction_result_updates: { wrong_transmission_doctor: { not: nil } }).where("extract(year from transactions.created_at) = ?", Date.today.year).count
      @doctoraccuracycertified = Transaction.joins(:transaction_result_updates).joins(:doctor).joins(:doctor).where("transactions.status not in ('CANCELLED','REJECTED') and transactions.certification_date is not null and EXTRACT(year FROM transactions.created_at) = ?", Date.today.year).count
      @doctoraccuracywrongtransmission = Transaction.joins(:transaction_result_updates).joins(:doctor).where("transactions.status not in ('CANCELLED','REJECTED') and transaction_result_updates.wrong_transmission_doctor='TRUE' and EXTRACT(year FROM transactions.created_at) = ?", Date.today.year).count
      @doctoraccuracy_comply = (@certifydoctoraccuracycount != 0) ? ((@doctoraccuracycertified / @certifydoctoraccuracycount.to_f) * 100).round(1) : 0

    end

    respond_to do |format|
      format.json {
        render json: {
          accuracy_transmission: @doctoraccuracy_comply
        }
      }
    end

  end

  def performance_grading(percentage)
    case percentage
    when 80..100
      'A'
    when 70..79
      'B'
    when 60..69
      'C'
    when 50..59
      'D'
    else
      'E'
    end
  end

end


