class SharedController < ApplicationController
    layout false

    def check_for_user_account
        render json: User.find_by(email: params[:email]).present?, status: :ok
    end

    def search_for_xray_facilities
        @xray_facilities = XrayFacility.order(:name)
            .search_code(params[:code])
            .search_name(params[:name])
            .search_state(params[:state_id])
            .search_town(params[:town_id])
            .search_postcode(params[:postcode])
            .page(params[:page]).per(params[:per])
    end

    def search_for_doctors # Only used in Appeals. This modal's content follows their prodbmon system.
        # If both Postcode and Area are not empty, priority given to Postcode.
        doctor_ids =
            if params[:postcode].blank? && params[:area].blank?
                Doctor.none
            elsif params[:postcode].present?
                Doctor.order(:code)
                    .search_postcode(params[:postcode])
            else
                Doctor.order(:code)
                    .search_area(params[:area])
            end

        @doctor_ids         = doctor_ids.where(status: "ACTIVE").select(:id).order(:code).page(params[:page]).per(params[:per])
        date                = Time.now.beginning_of_year
        exclude_previous    = params[:exclude_previous_year] == "true"
        doctors             = Doctor.where(id: @doctor_ids.map(&:id))

        if exclude_previous
            transactions = Transaction.where(doctor_id: doctors.map(&:id)).where("transaction_date BETWEEN ? AND ?", date, date + 1.year).select(:id, :doctor_id, :transaction_date, :certification_date, :final_result).includes(:doctor_examination)
        else
            previous_year = Time.parse("00:00 1 Jan #{ params[:previous_year] }")
            transactions = Transaction.where(doctor_id: doctors.map(&:id)).where("(transaction_date BETWEEN ? AND ?) OR (transaction_date BETWEEN ? AND ?)", date, date + 1.year, previous_year, previous_year + 1.year).select(:id, :doctor_id, :transaction_date, :certification_date, :final_result).includes(:doctor_examination)
        end

        previous_year_mapping   = Hash.new(nil)
        current_year_mapping    = Hash.new(nil)

        transactions.each do |transaction|
            if transaction.transaction_date >= date && transaction.transaction_date < date + 1.year
                hash = current_year_mapping[transaction.doctor_id] || Hash.new(0)
            else
                hash = previous_year_mapping[transaction.doctor_id] || Hash.new(0)
            end

            doc_exam_result         = transaction.doctor_examination.try(:suitability)
            hash[:total]            += 1
            hash[:unfit]            += 1 if transaction.final_result == "UNSUITABLE"
            hash[:pending_cert]     += 1 if transaction.certification_date.blank?

            # Cases where after amendment the status have changed.
            if [["SUITABLE", "UNSUITABLE"], ["UNSUITABLE", "SUITABLE"]].include?([doc_exam_result, transaction.final_result])
                hash[:change]   += 1
            end

            if transaction.transaction_date >= date && transaction.transaction_date < date + 1.year
                current_year_mapping[transaction.doctor_id] = hash
            else
                previous_year_mapping[transaction.doctor_id] = hash
            end
        end

        all_states = State.pluck(:id, :name).to_h

        @doctors = doctors.map do |doctor|
            prev_values     = previous_year_mapping[doctor.id] unless exclude_previous
            prev_values     ||= Hash.new(0)
            current_values  = current_year_mapping[doctor.id]
            current_values  ||= Hash.new(0)

            {
                id:                     doctor.id,
                code:                   doctor.code,
                name:                   doctor.name,
                clinic:                 doctor.clinic_name,
                status:                 doctor.status,
                xray:                   doctor.has_xray? ? "YES" : "NO",
                state:                  all_states[doctor.state_id],
                total_previous:         prev_values[:total],
                unfit_previous:         prev_values[:unfit],
                change_previous:        prev_values[:change],
                total_current:          current_values[:total],
                pending_cert_current:   current_values[:no_exam],
                unfit_current:          current_values[:unfit],
                change_current:         current_values[:change]
            }
        end

        render "search_for_doctors", layout: false
    end

    def get_xray_taken_date
        xray_exam       = XrayExamination.find_by(id: params[:xray_exam_id])
        date            = xray_exam.try(:xray_taken_date)
        parsed_date     = date.strftime("%d/%m/%Y") if date.present?
        error_msg       = xray_exam.xray_api_error
        render json: { date: parsed_date, error_msg: error_msg }, status: :ok
    end

    def view_xray_image
        xray_exam       = XrayExamination.find_by(id: params[:xray_exam_id])
        render plain: "Could not find xray exam by the ID: #{ params[:xray_exam_id] }" and return if xray_exam.blank?
        source          = xray_exam.sourceable
        code            = xray_exam.xray_ref_number.present? ? xray_exam.xray_ref_number : source&.code
        xray_exam.update(xray_viewed: true) # mark as xray viewed at xray examination

        unless on_development?
            xray_ws     = XrayWebService.new(source: source, exam: xray_exam, code: code, user_id: params[:user_id], params: params.to_unsafe_h.merge(url: request.url))
            @image_url  = xray_ws.view_tab_digital_xray_trans_id
        end

        # For debugging only.
        # @image_url = [
        # ["Sat, 29 Aug 2020".to_date, "https://xray.fomema.my/M_Launch_Viewer.asp?transaction_id=20200812514398&studyInstanceUid=1.2.840.113564.2.64.62.128.8.1.20200828203717859.10230"],
        # ["Thu, 20 Aug 2020".to_date, "https://xray.fomema.my/M_Launch_Viewer.asp?transaction_id=20200812514398&studyInstanceUid=1.2.840.113564.2.96.176.127.8.1.20200819110036671.1026"]]

        if @image_url.blank?
            render plain: "#{ code } X-Ray image not available" and return
        elsif @image_url == :timeout_error
            render "shared/timeout_error_page", layout: false
        elsif @image_url.class == Array
            @date_images    = @image_url.sort
        else
            redirect_to @image_url and return
        end
    end

    def check_to_update_image_status
        xray_exam       = XrayExamination.find_by(id: params[:xray_exam_id])

        if xray_exam.present?
            source      = xray_exam.sourceable
            code        = xray_exam.xray_ref_number.present? ? xray_exam.xray_ref_number : source&.code

            unless on_development?
                xray_ws     = XrayWebService.new(source: source, exam: xray_exam, code: code, user_id: params[:user_id], params: params.to_unsafe_h.merge(url: request.url))
                @image_url  = xray_ws.view_tab_digital_xray_trans_id
            else
                # CAN ONLY DO THIS ON DEVELOPMENT!!!
                xray_exam.update(xray_taken_date: Time.now, digital_xray_available: true)
            end

            xray_exam.reload
            render json: xray_exam.slice(:xray_taken_date, :digital_xray_available)
        else
            render json: { xray_taken_date: nil, digital_xray_available: false }
        end
    end
end