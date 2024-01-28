class External::AppealsController < ExternalController
    include XrayExaminationModule
    include Sms
    include ProfileInfoCheck
    include Watermark
    include AgencySopAcknowledgeCheck

    before_action -> { can_access?("VIEW_APPEALS") },   only: [:index, :appeal_employer_decision_letter, :show_appeal_todos]
    before_action -> { can_access?("REVIEW_APPEALS") }, only: [:show, :update, :submit_xray_exam]
    before_action -> { can_access?("CREATE_APPEALS") }, only: [:new, :create]
    before_action :set_appeal_instance,                 only: [:show, :update, :submit_xray_exam, :appeal_employer_decision_letter, :upload_document, :upload_document_update, :send_appeal_reminder_email, :show_appeal_todos, :send_reminder_sms, :appeal_doctor_instruction_letter]
    before_action -> { pending_profile_update?(Employer.find_by(id: current_user.userable_id)) }, if: -> { current_user.userable_type == 'Employer' }, only: [ :index]
    before_action -> { agency_sop_acknowledge_check?(Agency.find_by(id: current_user.userable_id)) }, if: -> { current_user.userable_type == 'Agency' }, only: [ :index]

    def index
        appeals         = MedicalAppeal.where(latest_appeal: true).includes(:registered_by)

        case current_user.userable_type
        when "Doctor"
            appeals     = appeals.where(doctor_id: current_user.userable_id)
        when "Laboratory"
            appeals     = appeals.where(laboratory_id: current_user.userable_id)
        when "XrayFacility"
            appeals     = appeals.where(xray_facility_id: current_user.userable_id).includes(:current_xray_retake)
        when "Radiologist"
            appeals     = appeals.where(radiologist_id: current_user.userable_id).includes(:current_xray_retake)
        when "Employer"
            appeals     = appeals.joins(:transactionz).where(transactions: { employer_id: current_user.userable_id })
        when "Agency"
            appeals     = appeals.joins(:transactionz).where(transactions: { agency_id: current_user.userable_id })
        else
            redirect_to external_transactions_path and return
        end

        @appeals        = appeals.includes(:officer_in_charge, :doctor, transactionz: [:foreign_worker])
            .search_foreign_worker_name_or_code(params[:worker_code])
            .search_foreign_worker_name(params[:worker_name])
            .search_appeal_date_start(params[:appeal_date_start])
            .search_appeal_date_end(params[:appeal_date_end])
            .search_clinic_or_doctor_name(params[:clinic_doctor_name])
            .search_officer_name_or_code(params[:mle1_code])
            .search_by_appeal_status_external(params[:appeal_status])
            .search_registered_by_type(params[:registered_by_type])
            .order_by_active
            .order(id: :asc)
            .page(params[:page]).per(get_per)
    end

    def new
        @transaction            = Transaction.find_by(id: params[:transaction])
        redirect_to external_appeals_path and return if @transaction.blank? || !["Doctor", "Employer", "Agency"].include?(current_user.userable_type)
        redirect_to external_appeals_path and return if @transaction.blocked_appeal_list("Doctor").present? || @transaction.blocked_appeal_list("Employer").present? || @transaction.blocked_appeal_list("Agency").present?
        @appeal                 = @transaction.medical_appeals.new(status: "DOCTOR_NEW")
        set_transaction_results_instances
        @transaction.medical_appeals.build if @transaction.latest_medical_appeal.blank?
    end

    def create
        @transaction    = Transaction.find_by(id: params[:medical_appeal][:id])
        redirect_to external_appeals_path and return if @transaction.blank? || !["Doctor", "Employer", "Agency"].include?(current_user.userable_type)
        redirect_to external_appeals_path and return if @transaction.blocked_appeal_list("Doctor").present? || @transaction.blocked_appeal_list("Employer").present? || @transaction.blocked_appeal_list("Agency").present?
        consented_at = ["Employer", "Agency"].include?(current_user.userable_type) ? DateTime.now : nil
        condition_tuberculosis = Condition.where(code: ["3502"]).pluck(:id)
        condition_other = Condition.where(code: ["3520"]).pluck(:id)
        med_exam = @transaction.medical_examination || @transaction.doctor_examination

        case med_exam.class.to_s
        when "MedicalExamination"
            count_condition = med_exam.medical_examination_details.count
            condition_tb = med_exam.medical_examination_details.where(condition_id: condition_tuberculosis)
            condition_others = med_exam.medical_examination_details.where(condition_id: condition_other)
        when
            count_condition = med_exam.doctor_examination_details.count
            condition_tb = med_exam.doctor_examination_details.where(condition_id: condition_tuberculosis)
            condition_others = med_exam.doctor_examination_details.where(condition_id: condition_other)
        end

        #condition one only and not condition others & tb
        if count_condition == 1 && !condition_tb&.exists? && !condition_others&.exists?
            status = "EXAMINATION"
        else
            status = "DOCTOR_NEW"
        end

        @appeal         = MedicalAppeal.find_or_initialize_by(transaction_id: @transaction.id, registered_by_type: current_user.userable_type, created_by: current_user.userable_id, doctor_id: @transaction.doctor_id, status: status, employer_consented_at: consented_at)
        @appeal.update(medical_appeal_params)

        if !@transaction.medical_examination_details.where(condition_id: condition_tuberculosis).exists? ||  !@transaction.doctor_examination_details.where(condition_id: condition_tuberculosis).exists?
            send_appeal_reminder_email
            send_reminder_sms
        end

        flash[:notice_reminders] = @transaction
        redirect_to external_appeals_path, notice: "Appeal submitted"
    end

    def show
        redirect_to external_appeals_path and return if !["EXAMINATION", "DOCUMENT_COMPLETED", "PENDING_APPROVAL", "CLOSED"].include?(@appeal.status)
        @readonly = ["PENDING_APPROVAL", "CLOSED"].include?(@appeal.status)

        case current_user.userable_type
        when "Doctor"
            external_appeals_path if @appeal.doctor_id != current_user.userable_id
        when "Laboratory"
            external_appeals_path if @appeal.laboratory_id != current_user.userable_id
        when "XrayFacility", "Radiologist"
            external_appeals_path if @appeal.xray_facility_id != current_user.userable_id
        else
            redirect_to external_transactions_path
        end

        @transaction        = @appeal.transactionz
        @appeal_comments    = @appeal.medical_appeal_comments.order(:id)

        case current_user.userable_type
        when "Doctor"
            appeal_todos            = @appeal.medical_appeal_todos.order(:id).includes(:appeal_todo)
            @appeal_todos           = appeal_todos.to_a.select {|todo| todo.secondary_type.blank?}
            @lab_todos              = appeal_todos.to_a.select {|todo| todo.secondary_type == "Laboratory"}
            @xray_todos             = appeal_todos.to_a.select {|todo| todo.secondary_type == "Xray"}
            set_transaction_results_instances
        when "Laboratory"
            @appeal_todos           = @appeal.medical_appeal_todos.where(secondary_type: "Laboratory").where.not(secondary_sent_at: nil).order(:id).includes(:appeal_todo)
        when "XrayFacility", "Radiologist"
            check_retry = xray_examination_instances(:appeal_retakes)
            redirect_to check_retry[:url] and return if check_retry.class == Hash && check_retry[:error] == :xray_exam_page_retry
        end
    end

    def update
        @appeal_todos   = @appeal.medical_appeal_todos
        @appeal.assign_attributes(medical_appeal_todo_params)

        if params[:appeal_todos].present?
            todos = params[:appeal_todos].to_unsafe_h

            todos.each do |id, hash|
                todo = @appeal_todos.to_a.find {|record| record.id == id.to_i}
                next if todo.blank?
                todo.comment = hash[:remarks]
                todo.completed_at   = Time.now if todo.completed_at.blank? && hash[:test_done] == "true"
                todo.completed_at   = nil if hash[:test_done] == "false"
                todo.save
            end
        end

        case current_user.userable_type
        when "Doctor"
            completed_check             = @appeal.medical_appeal_todos.where(secondary_type: nil).map(&:completed_at?)
            @appeal.doctor_done_at      = Time.now if !completed_check.include?(false)

            # Setting Laboratory Todo confirmations & checks.
            if params[:laboratory_todos].present?
                @appeal.laboratory_id   = @appeal.transactionz.laboratory_id
                lab_todo_list           = @appeal_todos.where(secondary_type: "Laboratory")
                lab_todo_ids            = params[:laboratory_todos].map(&:to_i)

                lab_todo_list.each do |lab_todo_item|
                    if !lab_todo_item.secondary_sent_at? && lab_todo_ids.include?(lab_todo_item.id)
                        lab_todo_item.update(secondary_sent_at: Time.now)
                    elsif lab_todo_item.secondary_sent_at? && !lab_todo_ids.include?(lab_todo_item.id)
                        lab_todo_item.update(secondary_sent_at: nil)
                    end
                end

                if @appeal.medical_appeal_todos.where(secondary_type: "Laboratory", completed_at: nil).where.not(secondary_sent_at: nil).count > 0
                    @appeal.laboratory_done_at = nil
                end
            else
                lab_todo_list           = @appeal_todos.where(secondary_type: "Laboratory").where.not(secondary_sent_at: nil).update(secondary_sent_at: nil)
                @appeal.laboratory_id   = nil
            end
        when "Laboratory"
            completed_check             = @appeal.medical_appeal_todos.where(secondary_type: "Laboratory").where.not(secondary_sent_at: nil).map(&:completed_at?)
            @appeal.laboratory_done_at  = Time.now if !completed_check.include?(false)
        end

        document_uploaded_count = @appeal.uploads.where("created_by = ?", current_user.id).count
        new_document_count = 0

        if params.has_key?(:appeal)
            if params[:appeal][:uploads]
                params[:appeal][:uploads].each do |upload|
                    if (!upload[:category].nil? && !upload[:documents].nil?)
                        add_watermark(upload[:documents])
                        upl = @appeal.uploads.create(category: upload[:category])
                        upl.documents.attach(upload[:documents])
                        document_uploaded_count += 1
                        new_document_count += 1
                    end
                end
            end
        end

        if params[:remove_uploaded_file].present?
            ids = params[:remove_uploaded_file].split(",")
            @appeal.uploads.where(id: ids).destroy_all
            document_uploaded_count = document_uploaded_count - ids.count
        end

        case current_user.userable_type
        when "Doctor"
            if @appeal.doctor_document_uploaded == false
                @appeal.doctor_document_uploaded = true if new_document_count > 0
            else
                @appeal.doctor_document_uploaded = document_uploaded_count > 0 ? true : nil
            end
        when "Laboratory"
            if @appeal.laboratory_document_uploaded == false
                @appeal.laboratory_document_uploaded = true if new_document_count > 0
            else
                @appeal.laboratory_document_uploaded = document_uploaded_count > 0 ? true : nil
            end
        end

        @appeal.save
        redirect_to external_appeal_path(@appeal.id, p_tab: params[:p_tab], tab: params[:tab])
    end

    def submit_xray_exam
        @current_time   = Time.now
        @xray_retake    = @appeal.current_xray_retake
        @xray_exam      = @xray_retake.xray_examination
        @transaction    = @appeal.transactionz

        # Reset XrayExamination if Radiologist aborts transaction.
        if params[:commit] == "Abort"
            @xray_exam.radiologist_aborted_at = @current_time
            @xray_exam.update(xray_default_parameters)
            @xray_exam.reset_all_details_and_comments
            flash[:sp_aborted]          = current_user.userable_type
            flash[:sp_aborted_worker]   = @transaction.fw_code
            redirect_to external_appeal_path(@appeal, aborted: "yes") and return
        end

        # Check if reporter type has been changed.
        original_radiologist    = @xray_retake.radiologist_id
        original_reporter       = @xray_retake.xray_reporter_type

        unless params[:xe_attributes].present? && params[:xe_attributes].to_unsafe_h.size == 2 && params[:xe_attributes][:xray_examination_not_done] == "YES"
            @xray_retake.assign_attributes(xray_examination_params)
        end

        # If Xray Facility selects a new radiologist or changes the reporter type.
        if original_radiologist != @xray_retake.radiologist_id || original_reporter != @xray_retake.xray_reporter_type
            @xray_exam.assign_attributes(xray_default_parameters)
            @xray_exam.reset_all_details_and_comments
            @appeal.radiologist_id = @xray_retake.radiologist_id
        end

        if params[:xe_attributes].present?
            @xray_exam.assign_attributes(xe_attributes__regular_params)

            @xray_exam.save_examination_details_and_comments(
                detail_fields:  xe_attributes__details,
                comment_fields: xe_attributes__comments
            )
        end

        # Ensure radiologist id is nil if reporter_type is SELF.
        if @xray_retake.xray_reporter_type == "SELF" && @xray_retake.radiologist_id?
            @xray_retake.radiologist_id         = nil
            @xray_exam.radiologist_assigned_at  = nil
            @appeal.radiologist_id              = nil
        end

        @xray_exam.radiologist_assigned_at      ||= @current_time if @xray_retake.radiologist_id?

        # If Xray facility changes radiologists.
        @xray_exam.radiologist_aborted_at       = nil if original_radiologist != @xray_retake.radiologist_id && original_reporter == @xray_retake.xray_reporter_type
        @xray_exam.radiologist_assigned_at      = @current_time if @xray_retake.radiologist_id? && original_radiologist != @xray_retake.radiologist_id
        @xray_exam.radiologist_saved_at         = @current_time if current_user.userable_type == "Radiologist" && @xray_retake.xray_reporter_type == "RADIOLOGIST"
        @xray_exam.result                       = @xray_exam.result_of_exam ? "ABNORMAL" : "NORMAL"

        # for skipping fingerprint verification
        @xray_retake.xray_fp_result             = 2 if @xray_retake.xray_fp_result.nil?

        if params[:commit] == "Save and Transmit"
            if current_user.userable_type == "Radiologist" && @xray_retake.xray_reporter_type == "RADIOLOGIST" && params[:visited_xray] == "true"
                @xray_exam.radiologist_transmitted_at   = @current_time
                flash[:sp_completed]                    = current_user.userable_type
                flash[:sp_completed_worker]             = @transaction.fw_code
                @appeal.radiologist_done_at             = @current_time
            elsif current_user.userable_type == "XrayFacility"
                @xray_exam.transmitted_at               = @current_time
                flash[:sp_completed]                    = current_user.userable_type
                flash[:sp_completed_worker]             = @transaction.fw_code
                @xray_retake.status                     = @xray_exam.result == "NORMAL" ? "PCR_REVIEW" : "CLOSED"
                @xray_retake.completed_at               = @current_time
                @appeal.xray_facility_done_at           = @current_time
                @appeal.xray_result                     = @xray_exam.result
            end

        end

        @appeal.save
        @xray_retake.save
        @xray_exam.save

        if current_user.userable_type == "XrayFacility" && params[:commit] == "Save and Transmit"
            movement = DigitalXrayMovement.new(transaction_id: @appeal.transaction_id, moveable_type: "XrayRetake", moveable_id: @xray_retake.id)

            if @xray_exam.result == "NORMAL"
                PcrPool.create(medical_appeal_id: @appeal.id, case_type: "XRAY_APPEAL_NORMAL", status: "PCR_POOL", source: "MERTS", xray_retake_id: @xray_retake.try(:id))
                movement.update(status: "APPEAL-PCR-POOL", description: "Appeal Retake Examination Results sent to PCR Pool")
            else
                movement.update(status: "APPEAL-RETAKE-UNSUITABLE", description: "Appeal Retake Examination Transmitted")
            end
        end

        redirect_to external_appeal_path(@appeal.id, p_tab: "appeal", tab: "xray_info")
    end

    def appeal_employer_decision_letter
        @transaction        = @appeal.transactionz
        doctor              = @appeal.doctor
        employer            = @appeal.employer
        employer_address    = [employer.name, employer.address1, employer.address2, employer.address3, employer.address4, "#{ employer.postcode } #{ employer&.town&.name }", employer&.state&.name].select(&:present?)

        if doctor.present?
            display_doc_tag = "DR " if doctor.name[0..1] != "DR"
            doctor_address  = ["#{ display_doc_tag }#{ doctor.name }", doctor.clinic_name, doctor.address1, doctor.address2, doctor.address3, doctor.address4, "#{ doctor.postcode } #{ doctor&.town&.name }", doctor&.state&.name].select(&:present?)
        else
            doctor_address  = []
        end

        letter_type         = @appeal.result

        @data = {
            letter_ref_no:      "L#{ @appeal.id }/#{ @appeal.completed_at.strftime("%Y-%m") }/EMP (UA)/MED-DEPT/FOM",
            letter_date:        @appeal.completed_at.strftime("%d/%m/%Y"),
            employer_address:   employer_address,
            worker_name:        @transaction.fw_name,
            worker_passport_no: @transaction.fw_passport_number,
            doctor_address:     doctor_address,
            letter_type:        letter_type,
            reappeal:           MedicalAppeal.where(transaction_id: @appeal.transaction_id).where.not(id: @appeal.id).count > 0
        }

        render pdf: "appeal_employer_decision_letter",
        template: "/external/appeals/appeal_employer_decision_letter.html.erb",
        layout: "pdf.html",
        margin: {
            top: "1.5cm",
            left: "2cm",
            right: "2cm",
            bottom: "2cm",
        },
        page_size: nil,
        page_height: "29.7cm",
        page_width: "21cm",
        dpi: "300"
    end

    def show_appeal_todos
        @transaction        = @appeal.transactionz
        @appeal_comments    = @appeal.medical_appeal_comments.order(:id)
    end

    def upload_document
    end

    def upload_document_update
        if params[:appeal][:uploads]
            params[:appeal][:uploads].each do |upload|
                if (!upload[:category].nil? && !upload[:documents].nil?)
                    add_watermark(upload[:documents])
                    upl = @appeal.uploads.create(category: upload[:category])
                    upl.documents.attach(upload[:documents])
                end
            end

            @appeal.status = "PENDING_MOH_APPROVAL"
            @appeal.employer_document_uploaded = true
            @appeal.employer_document_uploaded_date = Time.now
            @appeal.save

            flash_add(:notices, "Document(s) uploaded successfully. Appeal is pending for approval.")

            redirect_to external_appeals_path and return
        end
    end

    def send_appeal_reminder_email
        @appeal.reload
        if @appeal.registered_by_type != "Doctor"
            AppealMailer.with({
                appeal: @appeal,
            }).employer_appeal_reminder_email.deliver_later

            AppealMailer.with({
                appeal: @appeal,
            }).doctor_appeal_reminder_email.deliver_later
        end
    end

    def send_reminder_sms
        return if SystemConfiguration.get("MSG_ENABLE_SMS") == "0"

        # Do not send to agency - requested by Letchumy
        # case @appeal.registered_by_type
        # when "Employer"
        #     @customer = Employer.find(@appeal.created_by)
        # when "Agency"
        #     @customer = Agency.find(@appeal.created_by)
        # else
        #     @customer = @appeal.transactionz.employer
        # end
        @customer = @appeal.transactionz.employer

        recipients = ['Customer', 'Doctor']
        recipients.each do |recipient|
            phone = ""
            if recipient == 'Customer'
                message = "#{ENV['MESSAGING_FROM']} Hi #{@customer.name}. We have received your appeal application for #{@appeal.transactionz.fw_name} (#{@appeal.transactionz.fw_code}). Please make an appointment with Dr #{@appeal.doctor.name} of #{@appeal.doctor.clinic_name} for the next step in processing this appeal. Kindly refer to your registered email (#{@customer.email}) for more details."
                phone = @customer.phone.strip if @customer.phone_is_mobile_with_country_code? || @customer.phone_is_mobile_without_country_code?
                phone = @customer.pic_phone.strip if @customer.pic_phone_is_mobile_with_country_code? || @customer.pic_phone_is_mobile_without_country_code?
            elsif recipient == 'Doctor'
                message = "#{ENV['MESSAGING_FROM']} Hi Dr #{@appeal.doctor.name} of #{@appeal.doctor.clinic_name}. Please be informed that appeal case of #{@appeal.transactionz.fw_name} (#{@appeal.transactionz.fw_code}) has been registered. The employer (#{@customer.name}) will contact you/your clinic for next action. Please log in MERTS for more details."
                phone = @appeal.doctor.mobile.strip if @appeal.doctor.mobile_with_country_code? || @appeal.doctor.mobile_without_country_code?
            end

            phone = "#{ENV['MOBILE_PREFIX']}#{phone}" if !phone.blank? && !phone.start_with?(ENV['MOBILE_PREFIX'])

            unless phone == ""
                data = {
                    app_code: ENV['MESSAGING_MEDICAL_CODE'],
                    app_secret: ENV['MESSAGING_MEDICAL_SECRET'],
                    message: message,
                    type: ENV['MESSAGING_TYPE'],
                    to: phone
                }
                send_sms(data)
            end
        end
    end

    def appeal_doctor_instruction_letter
        @transaction        = @appeal.transactionz
        doctor              = @appeal.doctor
        render plain: "Unable to generate letter without a selected doctor" and return if doctor.blank?
        employer            = @appeal.employer
        display_doc_tag     = "DR " if doctor.name[0..1] != "DR"
        doctor_address      = ["#{ display_doc_tag }#{ doctor.name }", doctor.clinic_name, doctor.address1, doctor.address2, doctor.address3, doctor.address4, "#{ doctor.postcode } #{ doctor&.town&.name }", doctor&.state&.name].select(&:present?)
        comments            = @appeal.medical_appeal_comments.pluck(:comment)

        @data = {
            letter_ref_no:          "L#{ @appeal.id }/#{ Date.today.strftime("%Y-%m") }/GP/MED-APPEAL/FOM",
            letter_date:            Date.today.strftime("%d/%m/%Y"),
            doctor_address:         doctor_address,
            worker_name:            @transaction.fw_name,
            worker_passport_no:     @transaction.fw_passport_number,
            worker_code:            @transaction.fw_code,
            employer_name:          employer.name,
            employer_phone:         employer.phone,
            appeal_comments:        comments
        }

        render pdf: "appeal_doctor_instruction_letter",
        template: "/internal/appeals/appeal_doctor_instruction_letter.html.erb",
        layout: "pdf.html",
        margin: {
            top: "1.5cm",
            left: "2cm",
            right: "2cm",
            bottom: "2cm",
        },
        page_size: nil,
        page_height: "29.7cm",
        page_width: "21cm",
        dpi: "300"
    end

private
    def set_appeal_instance
        id      = params[:appeal_id] || params[:id]
        @appeal = MedicalAppeal.find_by(id: id)
        redirect_to external_appeals_path, alert: "Appeal does not exist" if @appeal.blank?
    end

    def set_transaction_results_instances
        @tcupi_review           = @transaction.latest_tcupi_review
        @medical_review         = @transaction.latest_medical_review
        @xray_pending_decisions = @transaction.xray_pending_decisions
        @result_updates         = @transaction.transaction_result_updates.includes(:user).order(id: :desc)
        @amendments             = @transaction.transaction_amendments.includes(:user, :approved_by).order(id: :desc)
    end

    def medical_appeal_params
        params.require(:medical_appeal).permit(:doctor_reason)
    end

    def medical_appeal_todo_params
        params.require(:medical_appeal).permit(:xray_facility_id)
    end

    def xray_examination_params
        params[:transaction].slice(:xray_worker_identity_confirmed, :xray_film_type, :xray_reporter_type, :radiologist_id).to_unsafe_h
    end

    def xe_attributes__regular_params
        params[:xe_attributes].slice(:xray_examination_not_done, :xray_taken_date, :xray_ref_number).to_unsafe_h
    end

    def xe_attributes__details
        params[:xe_attributes].slice(:thoracic_cage, :heart_shape_and_size, :lung_fields, :mediastinum_and_hila, :pleura_hemidiaphragms_costopherenic_angles, :focal_lesion, :other_findings).to_unsafe_h
    end

    def xe_attributes__comments
        params[:xe_attributes].slice(:thoracic_cage_comment, :heart_shape_and_size_comment, :lung_fields_comment, :mediastinum_and_hila_comment, :pleura_hemidiaphragms_costopherenic_angles_comment, :focal_lesion_comment, :other_findings_comment, :impression).to_unsafe_h
    end

    def xray_default_parameters
        default_parameters = [:xray_examination_not_done, :xray_taken_date, :xray_ref_number, :result, :radiologist_started_at, :radiologist_saved_at].map {|key| [key, nil]}.to_h
    end
end