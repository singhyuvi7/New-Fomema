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
    if @filter_params.present? && @filter_params['doctor'].present?
      @doctorsactive = Doctor.where(status: 'ACTIVE', code: @filter_params['doctor']).count
      @doctornew = Doctor.where("extract(year from created_at) = ?", @current_year).where(code: @filter_params['doctor']).count
      @doctorwithdrawl = Doctor.joins("join status_schedules on status_schedules.status_scheduleable_id=doctors.id").where("doctors.status=? and  doctors.code=? and status_schedules.status_reason IN(?)", 'INACTIVE', @filter_params['doctor'], ["01", "02"]).count
      @doctordemised = Doctor.joins("join status_schedules on status_schedules.status_scheduleable_id=doctors.id").where('doctors.status=? and  doctors.code=? and status_schedules.status_reason IN(?)', 'INACTIVE', @filter_params['doctor'], '07').count
      @doctornoncomp = Doctor.joins("join status_schedules on status_schedules.status_scheduleable_id=doctors.id").where('doctors.status=? and  doctors.code=? and status_schedules.status_reason IN(?)', 'INACTIVE', @filter_params['doctor'], ["06", "03"]).count
      @doctorstates = Doctor.joins(:state).where('doctors.status=?','ACTIVE').where('doctors.code=?', @filter_params['doctor']).group('states.name').count

      results.merge!({
                       doctorsactive: @doctorsactive,
                       doctorsnew: @doctornew,
                       doctorswithdrawal: @doctorwithdrawl,
                       doctorsdemised: @doctordemised,
                       doctorsnoncomp: @doctornoncomp,
                       doctorsstates: @doctorstates
                     })

    elsif @filter_params.present? && @filter_params['DateRange'].present?
      date_range = @filter_params['DateRange'].split(' - ').map { |date| Date.parse(date) }
      start_date = date_range[0]
      end_date = date_range[1]
      @doctorsactive = Doctor.where(created_at: start_date..end_date).where(status: 'ACTIVE').count
      @doctornew = Doctor.where(created_at: start_date..end_date).count

      @doctorwithdrawl = Doctor.joins("JOIN status_schedules ON status_schedules.status_scheduleable_id = doctors.id")
                               .where("doctors.created_at BETWEEN ? AND ?", start_date, end_date)
                               .where("doctors.status = 'INACTIVE' AND status_schedules.status_reason IN ('01', '02')")
                               .count

      @doctordemised = Doctor.joins("JOIN status_schedules ON status_schedules.status_scheduleable_id = doctors.id")
                             .where("doctors.created_at BETWEEN ? AND ?", start_date, end_date)
                             .where("doctors.status = 'INACTIVE' AND status_schedules.status_reason = '07'")
                             .count

      @doctornoncomp = Doctor.joins("JOIN status_schedules ON status_schedules.status_scheduleable_id = doctors.id")
                             .where("doctors.created_at BETWEEN ? AND ?", start_date, end_date)
                             .where("doctors.status = 'INACTIVE' AND status_schedules.status_reason IN ('06', '03')")
                             .count
      @doctorstates = Doctor.joins(:state).where('doctors.status=?','ACTIVE').where(created_at: start_date..end_date).group('states.name').count

      results.merge!({
                       doctorsactive: @doctorsactive,
                       doctorsnew: @doctornew,
                       doctorswithdrawal: @doctorwithdrawl,
                       doctorsdemised: @doctordemised,
                       doctorsnoncomp: @doctornoncomp,
                       doctorsstates: @doctorstates
                     })
    end

    if @filter_params.present? && (@filter_params['lab'].present?)
      @laboratoriesactive = Laboratory.where(status: 'ACTIVE', code: @filter_params['lab']).count
      @laboratoriesnew = Laboratory.where("extract(year from created_at) = ? AND code = ?", @current_year, @filter_params['lab']).count

      @laboratorywithdrawl = Laboratory.joins("JOIN status_schedules ON status_schedules.status_scheduleable_id = laboratories.id")
                                       .where('laboratories.status=? AND status_schedules.status_reason IN(?) AND laboratories.code = ?', 'INACTIVE', ["01", "02"], @filter_params['lab']).count

      @laboratorydemised = Laboratory.joins("JOIN status_schedules ON status_schedules.status_scheduleable_id = laboratories.id")
                                     .where('laboratories.status=? AND status_schedules.status_reason IN(?) AND laboratories.code = ?', 'INACTIVE', '07', @filter_params['lab']).count

      @laboratorynoncomp = Laboratory.joins("JOIN status_schedules ON status_schedules.status_scheduleable_id = laboratories.id")
                                     .where('laboratories.status=? AND status_schedules.status_reason IN(?) AND laboratories.code = ?', 'INACTIVE', ["06", "03"], @filter_params['lab']).count

      @laboratoriesstates = Laboratory.joins(:state).where('laboratories.status=?','ACTIVE').where('laboratories.code = ?', @filter_params['lab']).group('states.name').count

      results.merge!({
                       laboratoriesactive: @laboratoriesactive,
                       laboratoriesnew: @laboratoriesnew,
                       laboratorieswithdrawal: @laboratorywithdrawl,
                       laboratoriesdemised: @laboratorydemised,
                       laboratoriesnoncomp: @laboratorynoncomp,
                       laboratoriesstates: @laboratoriesstates
                     })

    elsif @filter_params.present? && @filter_params['DateRange'].present?
      date_range = @filter_params['DateRange'].split(' - ').map { |date| Date.parse(date) }
      start_date = date_range[0]
      end_date = date_range[1]
      @laboratoriesactive = Laboratory.where(created_at: start_date..end_date).where(status: 'ACTIVE').count
      @laboratoriesnew = Laboratory.where(created_at: start_date..end_date).count
      @laboratorywithdrawl = Laboratory.joins("join status_schedules on status_schedules.status_scheduleable_id=laboratories.id").where("laboratories.created_at BETWEEN ? AND ?", start_date, end_date).where('laboratories.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', ["01", "02"]).count
      @laboratorydemised = Laboratory.joins("join status_schedules on status_schedules.status_scheduleable_id=laboratories.id").where("laboratories.created_at BETWEEN ? AND ?", start_date, end_date).where('laboratories.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', '07').count
      @laboratorynoncomp = Laboratory.joins("join status_schedules on status_schedules.status_scheduleable_id=laboratories.id").where("laboratories.created_at BETWEEN ? AND ?", start_date, end_date).where('laboratories.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', ["06", "03"]).count
      @laboratoriesstates = Laboratory.joins(:state).where('laboratories.status=?','ACTIVE').where(created_at: start_date..end_date).group('states.name').count

      results.merge!({
                       laboratoriesactive: @laboratoriesactive,
                       laboratoriesnew: @laboratoriesnew,
                       laboratorieswithdrawal: @laboratorywithdrawl,
                       laboratoriesdemised: @laboratorydemised,
                       laboratoriesnoncomp: @laboratorynoncomp,
                       laboratoriesstates: @laboratoriesstates
                     })

    end

    if @filter_params.present? && (@filter_params['xray'].present?)
      @xrayfacilityactive = XrayFacility.where(status: 'ACTIVE', code: @filter_params['xray']).count
      @xrayfacilitynew = XrayFacility.where("extract(year from created_at) = ? AND code = ?", @current_year, @filter_params['xray']).count

      @xrayfacilitywithdrawl = XrayFacility.joins("JOIN status_schedules ON status_schedules.status_scheduleable_id = xray_facilities.id")
                                           .where('xray_facilities.status=? AND status_schedules.status_reason IN(?) AND xray_facilities.code = ?', 'INACTIVE', ["01", "02"], @filter_params['xray']).count

      @xrayfacilitydemised = XrayFacility.joins("JOIN status_schedules ON status_schedules.status_scheduleable_id = xray_facilities.id")
                                         .where('xray_facilities.status=? AND status_schedules.status_reason IN(?) AND xray_facilities.code = ?', 'INACTIVE', '07', @filter_params['xray']).count

      @xrayfacilitynoncomp = XrayFacility.joins("JOIN status_schedules ON status_schedules.status_scheduleable_id = xray_facilities.id")
                                         .where('xray_facilities.status=? AND status_schedules.status_reason IN(?) AND xray_facilities.code = ?', 'INACTIVE', ["06", "03"], @filter_params['xray']).count

      @xrayfacilitiesstates = XrayFacility.joins(:state).where('xray_facilities.status=?','ACTIVE').where('xray_facilities.code = ?', @filter_params['xray']).group('states.name').count

      results.merge!({
                       xrayfacilityactive: @xrayfacilityactive,
                       xrayfacilitynew: @xrayfacilitynew,
                       xrayfacilitywithdrawal: @xrayfacilitywithdrawl,
                       xrayfacilitydemised: @xrayfacilitydemised,
                       xrayfacilitynoncomp: @xrayfacilitynoncomp,
                       xrayfacilitiesstates: @xrayfacilitiesstates
                     })

    elsif @filter_params.present? && @filter_params['DateRange'].present?
      date_range = @filter_params['DateRange'].split(' - ').map { |date| Date.parse(date) }
      start_date = date_range[0]
      end_date = date_range[1]
      @xrayfacilityactive = XrayFacility.where(created_at: start_date..end_date).where(status: 'ACTIVE').count
      @xrayfacilitynew = XrayFacility.where(created_at: start_date..end_date).count
      @xrayfacilitywithdrawl = XrayFacility.joins("join status_schedules on status_schedules.status_scheduleable_id=xray_facilities.id").where("xray_facilities.created_at BETWEEN ? AND ?", start_date, end_date).where('xray_facilities.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', ["01", "02"]).count
      @xrayfacilitydemised = XrayFacility.joins("join status_schedules on status_schedules.status_scheduleable_id=xray_facilities.id").where("xray_facilities.created_at BETWEEN ? AND ?", start_date, end_date).where('xray_facilities.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', '07').count
      @xrayfacilitynoncomp = XrayFacility.joins("join status_schedules on status_schedules.status_scheduleable_id=xray_facilities.id").where("xray_facilities.created_at BETWEEN ? AND ?", start_date, end_date).where('xray_facilities.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', ["06", "03"]).count
      @xrayfacilitiesstates = XrayFacility.joins(:state).where('xray_facilities.status=?','ACTIVE').where(created_at: start_date..end_date).group('states.name').count

      results.merge!({
                       xrayfacilityactive: @xrayfacilityactive,
                       xrayfacilitynew: @xrayfacilitynew,
                       xrayfacilitywithdrawal: @xrayfacilitywithdrawl,
                       xrayfacilitydemised: @xrayfacilitydemised,
                       xrayfacilitynoncomp: @xrayfacilitynoncomp,
                       xrayfacilitiesstates: @xrayfacilitiesstates
                     })
    end

    if @filter_params.present? && @filter_params['DateRange'].present?
      @xrayfacilityactive = XrayFacility.where(status: 'ACTIVE', code: @filter_params['xray']).count
      @xrayfacilitynew = XrayFacility.where("extract(year from created_at) = ? AND code = ?", @current_year, @filter_params['xray']).count

      @xrayfacilitywithdrawl = XrayFacility.joins("JOIN status_schedules ON status_schedules.status_scheduleable_id = xray_facilities.id")
                                           .where('xray_facilities.status=? AND status_schedules.status_reason IN(?) AND xray_facilities.code = ?', 'INACTIVE', ["01", "02"], @filter_params['xray']).count

      @xrayfacilitydemised = XrayFacility.joins("JOIN status_schedules ON status_schedules.status_scheduleable_id = xray_facilities.id")
                                         .where('xray_facilities.status=? AND status_schedules.status_reason IN(?) AND xray_facilities.code = ?', 'INACTIVE', '07', @filter_params['xray']).count

      @xrayfacilitynoncomp = XrayFacility.joins("JOIN status_schedules ON status_schedules.status_scheduleable_id = xray_facilities.id")
                                         .where('xray_facilities.status=? AND status_schedules.status_reason IN(?) AND xray_facilities.code = ?', 'INACTIVE', ["06", "03"], @filter_params['xray']).count

      @xrayfacilitiesstates = XrayFacility.joins(:state).where('xray_facilities.status=?','ACTIVE').where('xray_facilities.code = ?', @filter_params['xray']).group('states.name').count

      results.merge!({
                       xrayfacilityactive: @xrayfacilityactive,
                       xrayfacilitynew: @xrayfacilitynew,
                       xrayfacilitywithdrawal: @xrayfacilitywithdrawl,
                       xrayfacilitydemised: @xrayfacilitydemised,
                       xrayfacilitynoncomp: @xrayfacilitynoncomp,
                       xrayfacilitiesstates: @xrayfacilitiesstates
                     })

    end

    if @filter_params.present? && @filter_params['DateRange'].present?
      date_range = @filter_params['DateRange'].split(' - ').map { |date| Date.parse(date) }
      start_date = date_range[0]
      end_date = date_range[1]

      @radiologistactive = Radiologist.where(created_at: start_date..end_date).where(status: 'ACTIVE').count
      @radiologistnew = Radiologist.where(created_at: start_date..end_date).count
      @radiologistwithdrawl = Radiologist.joins("join status_schedules on status_schedules.status_scheduleable_id=radiologists.id").where("radiologists.created_at BETWEEN ? AND ?", start_date, end_date).where('radiologists.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', ["01", "02"]).count
      @radiologistdemised = Radiologist.joins("join status_schedules on status_schedules.status_scheduleable_id=radiologists.id").where("radiologists.created_at BETWEEN ? AND ?", start_date, end_date).where('radiologists.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', '07').count
      @radiologistnoncomp = Radiologist.joins("join status_schedules on status_schedules.status_scheduleable_id=radiologists.id").where("radiologists.created_at BETWEEN ? AND ?", start_date, end_date).where('radiologists.status=? and status_schedules.status_reason IN(?)', 'INACTIVE', ["06", "03"]).count
      @radiologiststates = Radiologist.joins(:state).where('radiologists.status=?','ACTIVE').where(created_at: start_date..end_date).group('states.name').count

      results.merge!({
                       radiologistactive: @radiologistactive,
                       radiologistnew: @radiologistnew,
                       radiologistwithdrawal: @radiologistwithdrawl,
                       radiologistdemised: @radiologistdemised,
                       radiologistnoncomp: @radiologistnoncomp,
                       radiologiststates: @radiologiststates
                     })
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

    if @filter_params.present? && (@filter_params['doctor'].present?)
      @certifydoctoroverallcount = Transaction.joins("JOIN doctors on doctors.id = transactions.doctor_id")
                                              .group(:doctor_id).where(doctors: { code: @filter_params['doctor'] })
                                              .count
      @certifydoctorxrayyes = Transaction.joins("JOIN doctors ON doctors.id = transactions.doctor_id")
                                         .group(:doctor_id).where(doctors: { code: @filter_params['doctor'] })
                                         .where(" transactions.laboratory_transmit_date > transactions.xray_transmit_date AND EXTRACT(DAY FROM transactions.certification_date - transactions.xray_transmit_date) < 1")
                                         .count

      @certifydoctorlabyes = Transaction.joins("JOIN doctors ON doctors.id = transactions.doctor_id")
                                        .group(:doctor_id).where(doctors: { code: @filter_params['doctor'] })
                                        .where("transactions.laboratory_transmit_date < transactions.xray_transmit_date AND EXTRACT(DAY FROM transactions.certification_date - transactions.laboratory_transmit_date) < 1")
                                        .count

      @certifydoctorxrayno = Transaction.joins("JOIN doctors ON doctors.id = transactions.doctor_id")
                                        .group(:doctor_id).where(doctors: { code: @filter_params['doctor'] })
                                        .where("transactions.laboratory_transmit_date > transactions.xray_transmit_date AND EXTRACT(DAY FROM transactions.certification_date - transactions.xray_transmit_date) > 1")
                                        .count

      @certifydoctorlabno = Transaction.joins("JOIN doctors ON doctors.id = transactions.doctor_id")
                                       .group(:doctor_id).where(doctors: { code: @filter_params['doctor'] })
                                       .where("transactions.laboratory_transmit_date < transactions.xray_transmit_date AND EXTRACT(DAY FROM transactions.certification_date - transactions.laboratory_transmit_date) > 1")
                                       .count

      @certifydoctorxrayyes = @certifydoctorxrayyes&.count || 0
      @certifydoctorlabyes = @certifydoctorlabyes&.count || 0

      @certifydoctorxrayno_count = @certifydoctorxrayno&.count || 0
      @certifydoctorlabno_count = @certifydoctorlabno&.count || 0

      @certifydoctorwithin24hours = @certifydoctorxrayyes + @certifydoctorlabyes
      @certifydoctorbeyond24hours = @certifydoctorxrayno_count + @certifydoctorlabno_count

      @certitotalcount = @certifydoctorwithin24hours + @certifydoctorbeyond24hours

      if @certitotalcount > 0
        @ceritifydoctorperyestotal = @certitotalcount
      else
        @ceritifydoctorperyestotal = @certifydoctoroverallcount
      end

    elsif @filter_params.present? && (@filter_params['DateRange'].present?)
      date_range = @filter_params['DateRange'].split(' - ').map { |date| Date.parse(date) }
      start_date = date_range[0]
      end_date = date_range[1]

      @certifydoctoroverallcount = Transaction.joins("JOIN doctors on doctors.id = transactions.doctor_id")
                                              .group(:doctor_id).where(created_at: start_date..end_date)
                                              .count
      @certifydoctorxrayyes = Transaction.joins("JOIN doctors ON doctors.id = transactions.doctor_id")
                                         .group(:doctor_id).where(created_at: start_date..end_date)
                                         .where(" transactions.laboratory_transmit_date > transactions.xray_transmit_date AND EXTRACT(DAY FROM transactions.certification_date - transactions.xray_transmit_date) < 1")
                                         .count

      @certifydoctorlabyes = Transaction.joins("JOIN doctors ON doctors.id = transactions.doctor_id")
                                        .group(:doctor_id).where(created_at: start_date..end_date)
                                        .where("transactions.laboratory_transmit_date < transactions.xray_transmit_date AND EXTRACT(DAY FROM transactions.certification_date - transactions.laboratory_transmit_date) < 1")
                                        .count

      @certifydoctorxrayno = Transaction.joins("JOIN doctors ON doctors.id = transactions.doctor_id")
                                        .group(:doctor_id).where(created_at: start_date..end_date)
                                        .where("transactions.laboratory_transmit_date > transactions.xray_transmit_date AND EXTRACT(DAY FROM transactions.certification_date - transactions.xray_transmit_date) > 1")
                                        .count

      @certifydoctorlabno = Transaction.joins("JOIN doctors ON doctors.id = transactions.doctor_id")
                                       .group(:doctor_id).where(created_at: start_date..end_date)
                                       .where("transactions.laboratory_transmit_date < transactions.xray_transmit_date AND EXTRACT(DAY FROM transactions.certification_date - transactions.laboratory_transmit_date) > 1")
                                       .count

      @certifydoctorxrayyes = @certifydoctorxrayyes&.count || 0
      @certifydoctorlabyes = @certifydoctorlabyes&.count || 0

      @certifydoctorxrayno_count = @certifydoctorxrayno&.count || 0
      @certifydoctorlabno_count = @certifydoctorlabno&.count || 0

      @certifydoctorwithin24hours = @certifydoctorxrayyes + @certifydoctorlabyes
      @certifydoctorbeyond24hours = @certifydoctorxrayno_count + @certifydoctorlabno_count

      @certitotalcount = @certifydoctorwithin24hours + @certifydoctorbeyond24hours
      if @certitotalcount > 0
        @ceritifydoctorperyestotal = @certitotalcount
      else
        @ceritifydoctorperyestotal = @certifydoctoroverallcount
      end

    else

      @certifydoctoroverallcount = Transaction.joins("JOIN doctors on doctors.id = transactions.doctor_id")
                                              .where("extract(year from transactions.created_at) = ?", Date.today.year)
                                              .group(:doctor_id)
                                              .count
      @certifydoctorxrayyes = Transaction.joins("JOIN doctors ON doctors.id = transactions.doctor_id")
                                         .where("extract(year from transactions.created_at) = ?", Date.today.year)
                                         .group(:doctor_id)
                                         .where(" transactions.laboratory_transmit_date > transactions.xray_transmit_date AND EXTRACT(DAY FROM transactions.certification_date - transactions.xray_transmit_date) < 1")
                                         .count

      @certifydoctorlabyes = Transaction.joins("JOIN doctors ON doctors.id = transactions.doctor_id")
                                        .where("extract(year from transactions.created_at) = ?", Date.today.year)
                                        .group(:doctor_id)
                                        .where("transactions.laboratory_transmit_date < transactions.xray_transmit_date AND EXTRACT(DAY FROM transactions.certification_date - transactions.laboratory_transmit_date) < 1")
                                        .count

      @certifydoctorxrayno = Transaction.joins("JOIN doctors ON doctors.id = transactions.doctor_id")
                                        .where("extract(year from transactions.created_at) = ?", Date.today.year)
                                        .group(:doctor_id)
                                        .where("transactions.laboratory_transmit_date > transactions.xray_transmit_date AND EXTRACT(DAY FROM transactions.certification_date - transactions.xray_transmit_date) > 1")
                                        .count

      @certifydoctorlabno = Transaction.joins("JOIN doctors ON doctors.id = transactions.doctor_id")
                                       .where("extract(year from transactions.created_at) = ?", Date.today.year)
                                       .group(:doctor_id)
                                       .where("transactions.laboratory_transmit_date < transactions.xray_transmit_date AND EXTRACT(DAY FROM transactions.certification_date - transactions.laboratory_transmit_date) > 1")
                                       .count

      @certifydoctorxrayyes = @certifydoctorxrayyes&.count || 0
      @certifydoctorlabyes = @certifydoctorlabyes&.count || 0

      @certifydoctorxrayno_count = @certifydoctorxrayno&.count || 0
      @certifydoctorlabno_count = @certifydoctorlabno&.count || 0

      @certifydoctorwithin24hours = @certifydoctorxrayyes + @certifydoctorlabyes
      @certifydoctorbeyond24hours = @certifydoctorxrayno_count + @certifydoctorlabno_count

      @certitotalcount = @certifydoctorwithin24hours + @certifydoctorbeyond24hours

      if @certitotalcount > 0
        @ceritifydoctorperyestotal = @certitotalcount
      else
        @ceritifydoctorperyestotal = @certifydoctoroverallcount
      end
    end

    respond_to do |format|
      format.json {
        render json: {
          certification_by_doc: @ceritifydoctorperyestotal
        }
      }
    end
  end

  def laboratory_result_transmission

    @filter_params = JSON.parse(params[:filter_params]) rescue nil

    if @filter_params.present? && (@filter_params['lab'].present?)
      @laboratorydonutwithin48 = Transaction
                                   .joins(" JOIN laboratory_examinations ON laboratory_examinations.transaction_id = transactions.id ")
                                   .joins("JOIN laboratories ON laboratories.id = transactions.laboratory_id")
                                   .where("laboratories.code: @filter_params['lab']")
                                   .where(" transactions.status not in ('CANCELLED', 'REJECTED')  and DATE_PART('Day', transactions.laboratory_transmit_date - laboratory_examinations.specimen_taken_date) < 2 ")
                                   .count

      @laboratorydonutbeyond48 = Transaction
                                   .joins(" JOIN laboratory_examinations ON laboratory_examinations.transaction_id = transactions.id ").where("laboratories.code: @filter_params['lab']")
                                   .where(" transactions.status not in ('CANCELLED', 'REJECTED') and DATE_PART('Day', transactions.laboratory_transmit_date - laboratory_examinations.specimen_taken_date) > 2 ")
    elsif @filter_params.present? && (@filter_params['DateRange'].present?)
      date_range = @filter_params['DateRange'].split(' - ').map { |date| Date.parse(date) }
      start_date = date_range[0]
      end_date = date_range[1]

      @laboratorydonutwithin48 = Transaction
                                   .joins(" JOIN laboratory_examinations ON laboratory_examinations.transaction_id = transactions.id ").where(created_at: start_date..end_date)
                                   .where(" transactions.status not in ('CANCELLED', 'REJECTED')  and DATE_PART('Day', transactions.laboratory_transmit_date - laboratory_examinations.specimen_taken_date) < 2 ")
                                   .count

      @laboratorydonutbeyond48 = Transaction
                                   .joins(" JOIN laboratory_examinations ON laboratory_examinations.transaction_id = transactions.id ").where(created_at: start_date..end_date)
                                   .where(" transactions.status not in ('CANCELLED', 'REJECTED') and DATE_PART('Day', transactions.laboratory_transmit_date - laboratory_examinations.specimen_taken_date) > 2 ")
    else
      @laboratorydonutwithin48 = Transaction
                                   .joins(" JOIN laboratory_examinations ON laboratory_examinations.transaction_id = transactions.id ")
                                   .where("extract(year from transactions.created_at) = ?", Date.today.year)
                                   .where(" transactions.status not in ('CANCELLED', 'REJECTED')  and DATE_PART('Day', transactions.laboratory_transmit_date - laboratory_examinations.specimen_taken_date) < 2 ")
                                   .count

      @laboratorydonutbeyond48 = Transaction
                                   .joins(" JOIN laboratory_examinations ON laboratory_examinations.transaction_id = transactions.id ")
                                   .where("extract(year from transactions.created_at) = ?", Date.today.year)
                                   .where(" transactions.status not in ('CANCELLED', 'REJECTED') and DATE_PART('Day', transactions.laboratory_transmit_date - laboratory_examinations.specimen_taken_date) > 2 ")

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
      @Xrayfacilitywithinhours24 = Transaction.joins(" join xray_facilities on xray_facilities.id = transactions.xray_facility_id ").joins(" join xray_examinations on xray_examinations.transaction_id = transactions.id ").where("xray_facilities.code = '#{@filter_params['xray']}'").where(" xray_facilities.radiologist_operated = 'TRUE' and transactions.radiologist_id is null and xray_facilities.radiologist_operated = 'FALSE'  and transactions.status not IN('CANCELLED', 'REJECTED') and DATE_PART('Day', xray_examinations.transmitted_at - xray_examinations.xray_taken_date) < 1 ").count
      @Xrayfacilitywithinhours48 = Transaction.joins(" join xray_facilities on xray_facilities.id = transactions.xray_facility_id ").joins(" join xray_examinations on xray_examinations.transaction_id = transactions.id ").where("xray_facilities.code = '#{@filter_params['xray']}'").where(" xray_facilities.radiologist_operated = 'TRUE' and transactions.radiologist_id is not null and xray_facilities.radiologist_operated = 'FALSE' and transactions.status not IN('CANCELLED', 'REJECTED') and DATE_PART('Day', xray_examinations.transmitted_at - xray_examinations.xray_taken_date) < 2 ").count

      @xraytransmissionpercentage = @Xrayfacilitywithinhours24 + @Xrayfacilitywithinhours48
      @xraytransmissionpercentagetotal = @xraytransmissionpercentage / 2

      @total_self_reporting = Transaction.joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where("xray_facilities.code = '#{@filter_params['xray']}'")
                                         .where(" transactions.radiologist_id IS NULL AND transactions.status NOT IN ('CANCELLED', 'REJECTED') AND xray_facilities.radiologist_operated IN ('TRUE', 'FALSE') ").count

      @total_radiologist_reporting = Transaction.joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where("xray_facilities.code = '#{@filter_params['xray']}'")
                                                .where("transactions.radiologist_id IS NOT NULL AND transactions.status NOT IN ('CANCELLED', 'REJECTED') AND xray_facilities.radiologist_operated IN ('TRUE', 'FALSE') ").count

      @total_xray_report = @total_self_reporting + @total_radiologist_reporting

      @self_reporting_percent = ((@total_self_reporting.to_f / @total_xray_report)).round(1) * 100

      @radiologist_rep_percent = ((@total_radiologist_reporting.to_f / @total_xray_report)).round(1) * 100

    elsif @filter_params.present? && (@filter_params['DateRange'].present?)
      date_range = @filter_params['DateRange'].split(' - ').map { |date| Date.parse(date) }
      start_date = date_range[0]
      end_date = date_range[1]

      @Xrayfacilitywithinhours24 = Transaction.joins(" join xray_facilities on xray_facilities.id = transactions.xray_facility_id ").joins(" join xray_examinations on xray_examinations.transaction_id = transactions.id ").where(created_at: start_date..end_date).where(" xray_facilities.radiologist_operated = 'TRUE' and transactions.radiologist_id is null and xray_facilities.radiologist_operated = 'FALSE'  and transactions.status not IN('CANCELLED', 'REJECTED') and DATE_PART('Day', xray_examinations.transmitted_at - xray_examinations.xray_taken_date) < 1 ").count
      @Xrayfacilitywithinhours48 = Transaction.joins(" join xray_facilities on xray_facilities.id = transactions.xray_facility_id ").joins(" join xray_examinations on xray_examinations.transaction_id = transactions.id ").where(created_at: start_date..end_date).where(" xray_facilities.radiologist_operated = 'TRUE' and transactions.radiologist_id is not null and xray_facilities.radiologist_operated = 'FALSE' and transactions.status not IN('CANCELLED', 'REJECTED') and DATE_PART('Day', xray_examinations.transmitted_at - xray_examinations.xray_taken_date) < 2 ").count

      @xraytransmissionpercentage = @Xrayfacilitywithinhours24 + @Xrayfacilitywithinhours48
      @xraytransmissionpercentagetotal = @xraytransmissionpercentage / 2

      @total_self_reporting = Transaction.joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where(created_at: start_date..end_date)
                                         .where(" transactions.radiologist_id IS NULL AND transactions.status NOT IN ('CANCELLED', 'REJECTED') AND xray_facilities.radiologist_operated IN ('TRUE', 'FALSE') ").count

      @total_radiologist_reporting = Transaction.joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where(created_at: start_date..end_date)
                                                .where("transactions.radiologist_id IS NOT NULL AND transactions.status NOT IN ('CANCELLED', 'REJECTED') AND xray_facilities.radiologist_operated IN ('TRUE', 'FALSE') ").count

      @total_xray_report = @total_self_reporting + @total_radiologist_reporting

      @self_reporting_percent = ((@total_self_reporting.to_f / @total_xray_report)).round(1) * 100

      @radiologist_rep_percent = ((@total_radiologist_reporting.to_f / @total_xray_report)).round(1) * 100
    else
      @Xrayfacilitywithinhours24 = Transaction.joins(" join xray_facilities on xray_facilities.id = transactions.xray_facility_id ").joins(" join xray_examinations on xray_examinations.transaction_id = transactions.id ").where("extract(year from transactions.created_at) = ?", Date.today.year).where(" xray_facilities.radiologist_operated = 'TRUE' and transactions.radiologist_id is null and xray_facilities.radiologist_operated = 'FALSE'  and transactions.status not IN('CANCELLED', 'REJECTED') and DATE_PART('Day', xray_examinations.transmitted_at - xray_examinations.xray_taken_date) < 1 ").count
      @Xrayfacilitywithinhours48 = Transaction.joins(" join xray_facilities on xray_facilities.id = transactions.xray_facility_id ").joins(" join xray_examinations on xray_examinations.transaction_id = transactions.id ").where("extract(year from transactions.created_at) = ?", Date.today.year).where(" xray_facilities.radiologist_operated = 'TRUE' and transactions.radiologist_id is not null and xray_facilities.radiologist_operated = 'FALSE' and transactions.status not IN('CANCELLED', 'REJECTED') and DATE_PART('Day', xray_examinations.transmitted_at - xray_examinations.xray_taken_date) < 2 ").count

      @xraytransmissionpercentage = @Xrayfacilitywithinhours24 + @Xrayfacilitywithinhours48
      @xraytransmissionpercentagetotal = @xraytransmissionpercentage / 2

      @total_self_reporting = Transaction.joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where("extract(year from transactions.created_at) = ?", Date.today.year)
                                         .where(" transactions.radiologist_id IS NULL AND transactions.status NOT IN ('CANCELLED', 'REJECTED') AND xray_facilities.radiologist_operated IN ('TRUE', 'FALSE') ").count

      @total_radiologist_reporting = Transaction.joins(" JOIN xray_facilities ON transactions.xray_facility_id = xray_facilities.id ").where("extract(year from transactions.created_at) = ?", Date.today.year)
                                                .where("transactions.radiologist_id IS NOT NULL AND transactions.status NOT IN ('CANCELLED', 'REJECTED') AND xray_facilities.radiologist_operated IN ('TRUE', 'FALSE') ").count

      @total_xray_report = @total_self_reporting + @total_radiologist_reporting

      @self_reporting_percent = @total_xray_report.zero? ? 0 : ((@total_self_reporting.to_f / @total_xray_report).round(1) * 100).to_i
      @radiologist_rep_percent = @total_xray_report.zero? ? 0 : ((@total_radiologist_reporting.to_f / @total_xray_report).round(1) * 100).to_i
    end


    respond_to do |format|
      format.json {
        render json: {
          xray_transmission: @xraytransmissionpercentagetotal,
          self_reporting: @self_reporting_percent,
          radiologist_reporting: @radiologist_rep_percent
        }
      }
    end

  end

  def xray_compliance
    if @filter_params.present? && (@filter_params['xray'].present?)
      @xrayqualitycompliance = Transaction.joins(" join xray_facilities on xray_facilities.id = transactions.xray_facility_id ").where("xray_facilities.code = '#{@filter_params['xray']}'").where("transactions.status not IN('CANCELLED') and transactions.xray_film_type IN ('DIGITAL') ").group(" xray_facilities.code ").count
    elsif @filter_params.present? && (@filter_params['DateRange'].present?)
      date_range = @filter_params['DateRange'].split(' - ').map { |date| Date.parse(date) }
      start_date = date_range[0]
      end_date = date_range[1]
      @xrayqualitycompliance = Transaction.joins(" join xray_facilities on xray_facilities.id = transactions.xray_facility_id ").where(created_at: start_date..end_date).where("transactions.status not IN('CANCELLED') and transactions.xray_film_type IN ('DIGITAL') ").group(" xray_facilities.code ").count
    else
      @xrayqualitycompliance = Transaction.joins(" join xray_facilities on xray_facilities.id = transactions.xray_facility_id ").where("extract(year from transactions.created_at) = ?", Date.today.year).where("transactions.status not IN('CANCELLED') and transactions.xray_film_type IN ('DIGITAL') ").group(" xray_facilities.code ").count
    end
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
      @doctor_accuracy_transmission = Transaction
                                        .joins("JOIN doctors ON doctors.id = transactions.doctor_id")
                                        .where(doctors: { code: @filter_params['doctor'] })
                                        .where(" transactions.status not in ('CANCELLED', 'REJECTED')")
                                        .group(" doctors.name ")
                                        .count
    elsif @filter_params.present? && (@filter_params['DateRange'].present?)
      date_range = @filter_params['DateRange'].split(' - ').map { |date| Date.parse(date) }
      start_date = date_range[0]
      end_date = date_range[1]
      @doctor_accuracy_transmission = Transaction
                                        .joins("JOIN doctors ON doctors.id = transactions.doctor_id")
                                        .where(created_at: start_date..end_date)
                                        .where(" transactions.status not in ('CANCELLED', 'REJECTED')")
                                        .group(" doctors.name ")
                                        .count
    else
      @doctor_accuracy_transmission = Transaction
                                        .joins("JOIN doctors ON doctors.id = transactions.doctor_id")
                                        .where(" transactions.status not in ('CANCELLED', 'REJECTED')")
                                        .group(" doctors.name ")
                                        .count
    end

    respond_to do |format|
      format.json {
        render json: {
          accuracy_transmission: @doctor_accuracy_transmission,
        }
      }
    end
  end

end
