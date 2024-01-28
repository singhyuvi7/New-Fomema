class Internal::AppealsController < InternalController
    include MedicalExaminationInitializer
    include Sms
    include WorkerBlocking
    include Watermark

    before_action -> { can_access?("CREATE_APPEALS") },                             only: [:new, :create]
    before_action -> { can_access?("VIEW_APPEALS") },                               only: [:index, :appeal_results, :document_completed_report, :appeal_employer_instruction_letter, :appeal_doctor_instruction_letter]
    before_action -> { can_access?("REVIEW_APPEALS", "REVIEW_MOH_APPEALS") },       only: [:update, :cancel_appeal_approval_request]
    before_action -> { can_access?("REVIEW_APPEALS") },                             only: [:pcr_second_opinion, :pcr_third_opinion, :repeat_xray]
    before_action -> { can_access?("APPROVE_APPEALS", "REVIEW_MOH_APPEALS") },      only: [:appeal_approval, :appeal_approval_decision]
    before_action -> { can_access?("COMMENT_IN_APPEALS") },                         only: [:new_comment]
    before_action :set_appeal_instance,                         only: [:show, :update, :new_comment, :appeal_approval, :appeal_approval_decision, :appeal_results, :cancel_appeal_approval_request, :pcr_second_third_opinion, :repeat_xray, :appeal_employer_instruction_letter, :appeal_doctor_instruction_letter, :send_reminder_sms, :send_appeal_reminder_email]
    before_action :set_company_name, only: [:document_completed_report]

    def index
        # Only for Pending Review & Pending Review Approval Transactions Listing page. This is a requirement from Medical PR team, probably Munirah. NF-801.
        if params[:cookied_path] == "y" && session[:cookied_appeals_path].present?
            redirect_to "#{ request.path }?#{ session[:cookied_appeals_path] }" and return
        elsif request.url.include?("?")
            session[:cookied_appeals_path] = request.url.split("?")[1].gsub("cookied_path=y", "")
        end

        appeals     = MedicalAppeal.includes(:officer_in_charge, :doctor, transactionz: [:foreign_worker]).order(:id)
            .search_by_id(params[:appeal_id])
            .search_foreign_worker_name_or_code(params[:worker_code])
            .search_foreign_worker_name(params[:worker_name])
            .search_by_status(params[:status], params[:appeal_id], params[:worker_code])
            .search_appeal_date_start(params[:appeal_date_start])
            .search_appeal_date_end(params[:appeal_date_end])
            .search_doctor_name_or_code(params[:doctor_code])
            .search_officer_name_or_code(params[:mle1_code])
            .search_moh_appeal(params[:is_moh])
            .search_is_specialist(params[:is_specialist])

        if current_user.role.code == "MOH_APPROVER"
            appeals = appeals.search_moh_appeal(true)
        end

        @appeals    = appeals.page(params[:page]).per(get_per)
    end

    def new
        @transaction        = Transaction.find_by(id: params[:transaction])
        redirect_to internal_appeals_path and return if @transaction.blank?
        set_transaction_results_instances
        @officer_list       = appeal_officer_list
        @appeal             = @transaction.latest_medical_appeal
        @appeal             = @transaction.medical_appeals.new(status: "NEW") if @appeal.blank? || @appeal.status == "CLOSED"
    end

    def create
        @transaction        = Transaction.find_by(id: params[:medical_appeal][:id])
        redirect_to internal_appeals_path and return if @transaction.blank?
        @appeal             = @transaction.latest_medical_appeal
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
            status = "PENDING_TODO"
        end

        if @appeal.blank? || @appeal.status == "CLOSED"
            @appeal         = @transaction.medical_appeals.new(registered_by_type: "User", status: status, created_at: Time.now, officer_assigned_at: Time.now)
            @appeal.update(medical_appeal_params)
            flash[:newly_created] = "true"
            send_appeal_reminder_email if @transaction.medical_appeals.count == 1
            send_reminder_sms if @transaction.medical_appeals.count == 1
        else
            flash[:alert]   = "Cannot create a new appeal when there is an ongoing appeal."
        end

        redirect_to internal_appeal_path(@appeal.id, p_tab: "appeal", tab: "appeal_reason")
    end

    def show
        # After creating an Appeal, it will first redirect to show page, where a popup will make the user redirect back to transactions.
        # Must disable check if they have permission to create, but not permission to view.
        can_access?("VIEW_APPEALS", "REVIEW_APPEALS") unless has_permission?("CREATE_APPEALS") && flash[:newly_created].present?
        redirect_to appeal_results_internal_appeal_path and return if @appeal.status == "CLOSED"
        redirect_to internal_appeals_path and return if !@appeal.is_moh && current_user.role.code == "MOH_APPROVER"

        @transaction        = @appeal.transactionz
        @officer_list       = appeal_officer_list
        set_transaction_results_instances
        @appeal_todos       = @appeal.medical_appeal_todos.includes(:appeal_todo)
        appeal_ids          = @appeal_todos.map(&:appeal_todo_id)
        @all_appeals        = AppealTodo.order(:id).sort_by {|todo| appeal_ids.include?(todo.id) ? -1 : 1 }
        @appeal_comments    = @appeal.medical_appeal_comments.order(:id)
        @xray_retake        = @appeal.current_xray_retake
        @appeal_approval    = @appeal.latest_medical_appeal_approval
        @previous_approval  = @appeal.previous_medical_appeal_approval
        @pcr_review_count   = PcrPool.unscoped.joins(:xray_retake).where(medical_appeal_id: @appeal.id, xray_retakes: { current_appeal_retake: true }).count
    end

    def update
        original_officer            = @appeal.officer_in_charge_id
        original_doctor             = @appeal.doctor_id
        original_is_moh             = @appeal.is_moh

        # Delete Comments
        if params[:remove_appeal_comments].present?
            remove_comments             = params[:remove_appeal_comments].split("/").select(&:present?)
            MedicalAppealComment.where(medical_appeal_id: @appeal.id, id: remove_comments).destroy_all
        end

        # Update To Dos
        appeal_to_dos               = params[:appeal_to_dos].to_unsafe_h.select {|to_do, value| value == "YES"}.map(&:first)
        to_dos                      = AppealTodo.where(id: appeal_to_dos).map(&:id)
        @appeal.medical_appeal_todos.where.not(appeal_todo_id: to_dos).destroy_all
        MedicalAppealTodo.with_deleted.where(medical_appeal_id: @appeal.id, appeal_todo_id: to_dos).update(deleted_at: nil)
        to_dos.each {|todo_id| @appeal.medical_appeal_todos.find_or_create_by(appeal_todo_id: todo_id)}

        # Check for Doctor/Laboratory todos which aren't completed & update doctor_done_at/laboratory_done_at.
        check_for_todos             = @appeal.medical_appeal_todos.map {|todo| [todo.secondary_type, todo.completed_at?]}.uniq
        @appeal.doctor_done_at      = nil if check_for_todos.include? [nil, false]
        @appeal.laboratory_done_at  = nil if check_for_todos.include? ["Laboratory", false]

        # Set other values for statuses and xray facilities.
        @appeal.status              = "EXAMINATION" if ["DOCTOR_NEW", "PENDING_TODO"].include?(@appeal.status) && params.require(:medical_appeal)[:is_moh] == "false"
        @appeal.status              = "PENDING_MOH_DOCUMENT" if ["DOCTOR_NEW", "PENDING_TODO"].include?(@appeal.status) && params.require(:medical_appeal)[:is_moh] == "true"
        @appeal.status              = "PENDING_MOH_DOCUMENT" if ["EXAMINATION"].include?(@appeal.status) && params.require(:medical_appeal)[:is_moh] == "true" && params.require(:medical_appeal)[:is_moh] != original_is_moh
        @appeal.status              = params[:document_completed_checkbox] == "true" ? "DOCUMENT_COMPLETED" : @appeal.status
        @appeal.xray_facility_id    = params[:selected_xray_facility_id]
        @appeal.xray_selected_at    = Time.now if params[:selected_xray_facility_id].present?

        # Set document uploaded
        doctor_uploaded = @appeal.uploads.where("created_by = ?", Doctor.find_by(id: @appeal.doctor_id)&.user&.id).count > 0 ? true : nil
        lab_uploaded = @appeal.uploads.where("created_by = ?", Laboratory.find_by(id: @appeal.laboratory_id)&.user&.id).count > 0 ? true : nil
        @appeal.doctor_document_uploaded        = params[:doctor_document_incomplete_checkbox] == "true" ? false : doctor_uploaded
        @appeal.laboratory_document_uploaded    = params[:laboratory_document_incomplete_checkbox] == "true" ? false : lab_uploaded

        # Digital Xray
        if check_for_todos.map(&:first).include?("Xray")
            retake                      = XrayRetake.find_or_initialize_by(requestable_type: "MedicalAppeal", requestable_id: @appeal.id, transaction_id: @appeal.transaction_id)
            retake.update(status: "NEW") unless retake.id?
            xray_exam                   = XrayExamination.find_or_initialize_by(transaction_id: @appeal.transaction_id, sourceable: retake)
            xray_exam.update(xray_ref_number: retake.code) unless xray_exam.id?
        end

        # Setting Laboratory ID now set at Doctor's end. Doctor must first confirm the todo list before Lab can start.
        @appeal.laboratory_id       = nil if !@appeal.medical_appeal_todos.map(&:secondary_type).include?("Laboratory") #? @appeal.transactionz.laboratory_id : nil
        @appeal.update(medical_appeal_params)

        # Record changes if user is changed. Not sure if should use this in the view at all.
        MedicalAppealAssignment.create(medical_appeal_id: @appeal.id, original_user_type: "Doctor", original_user_id: original_doctor) if @appeal.doctor_id != original_doctor
        MedicalAppealAssignment.create(medical_appeal_id: @appeal.id, original_user_type: "User", original_user_id: original_officer) if @appeal.officer_in_charge_id != original_officer

        send_appeal_reminder_email if @appeal.doctor_id != original_doctor
        send_reminder_sms if @appeal.doctor_id != original_doctor

        @appeal_approval = @appeal.latest_medical_appeal_approval
        @appeal_approval ||= @appeal.medical_appeal_approvals.new
        @appeal_approval.assign_attributes(medical_appeal_decision)
        @appeal_approval.update(medical_mle1_id: current_user.id, medical_mle1_decision_at: Time.now)

        # Add and remove documents
        if params.has_key?(:appeal)
            if params[:appeal][:uploads]
                params[:appeal][:uploads].each do |upload|
                    if (!upload[:category].nil? && !upload[:documents].nil?)
                        add_watermark(upload[:documents])
                        upl = @appeal.uploads.create(category: upload[:category])
                        upl.documents.attach(upload[:documents])
                    end
                end
            end
        end

        if params[:remove_uploaded_file].present?
            ids = params[:remove_uploaded_file].split(",")
            @appeal.uploads.where(id: ids).destroy_all
        end

        if params[:commit] == "Submit For Appeal Approval"
            if ['UNSUCCESSFUL', 'CANCEL/CLOSE'].include?(params[:medical_mle1_decision])
                @appeal.assign_attributes(status: "CLOSED", result: params[:medical_mle1_decision], completed_at: Time.now)
                @appeal.save
                redirect_to internal_appeals_path(cookied_path: "y"), notice: "Appeal #{@appeal.id} has been submitted as #{params[:medical_mle1_decision]}."
            else
                @appeal.update(status: "PENDING_APPROVAL")
                redirect_to internal_appeals_path(cookied_path: "y"), notice: "Appeal #{@appeal.id} submitted for approval"
            end
        else
            # Change the appeal status to PENDING_TODO if MOH decide DEFERRED (for FOMEMA to do further test).
            # MLE to change the appeal to NOT MOH Appeal and continue the process as normal
            if params[:medical_mle1_decision] == "DEFERRED" && @appeal.status == "PENDING_MOH_APPROVAL"
                @appeal.update(status: "PENDING_TODO")
                redirect_to internal_appeals_path(cookied_path: "y"), notice: "Appeal #{ @appeal.id } submitted as Deferred."
            else
                redirect_to internal_appeal_path(@appeal.id, p_tab: params[:p_tab], tab: params[:tab])
            end
        end
    end

    def appeal_approval
        @transaction        = @appeal.transactionz
        set_transaction_results_instances
        @appeal_todos       = @appeal.medical_appeal_todos.includes(:appeal_todo)
        @appeal_comments    = @appeal.medical_appeal_comments.order(:id)
        @appeal_approval    = @appeal.latest_medical_appeal_approval
        has_xray            = @appeal_todos.find_by(secondary_type: "Xray")

        if has_xray
            pcr_review      = @appeal.pcr_reviews.order(id: :desc).limit(1).first
            retake          = @appeal.current_xray_retake

            @xray_results   =
                if pcr_review.present?
                    @appeal.pcr_result
                elsif retake.present?
                    @appeal.xray_result
                end
        end
    end

    def appeal_approval_decision
        @appeal_approval        = @appeal.latest_medical_appeal_approval
        @appeal_approval.assign_attributes(medical_mle2_id: current_user.id, medical_mle2_decision_at: Time.now, medical_mle2_comment: params[:medical_mle2_comment])
        @transaction            = @appeal.transactionz
        original_final_result   = @transaction.final_result

        if params[:commit] == "Reject"
            @appeal_approval.update(medical_mle2_decision: "REJECTED")
            notice          = "has been rejected"
            !@appeal.is_moh ? @appeal.update(status: "EXAMINATION") : @appeal.update(status: "PENDING_MOH_APPROVAL")
            @appeal.medical_appeal_approvals.create
        else
            @appeal_approval.update(medical_mle2_decision: "APPROVED")
            notice          = "has been approved"
            @appeal.assign_attributes(status: "CLOSED", result: @appeal_approval.medical_mle1_decision, completed_at: Time.now)

            if @appeal.result == "UNSUCCESSFUL" && original_final_result == "SUITABLE"
                @appeal.is_amendment = true
                @transaction.update(final_result: "UNSUITABLE")
            end

            @appeal.save
        end

        case @appeal.result
        when "SUCCESSFUL", "CONDITIONAL_SUCCESSFUL"
            @transaction.update(final_result: "SUITABLE")
            certification_conditions    = Condition.where(code: DoctorExamination::CERTIFICATION.values).pluck(:id)

            # Users want the DoctorExamination conditions to be untouched, so only update on MedicalExaminations.
            # If there is no medical exam (when there is no PR), then initialize a new one.
            create_medical_examination(@transaction) if @transaction.medical_examination.blank?

            # Sets all certification conditions to false.
            medical_examination         = MedicalExamination.find_by(transaction_id: @appeal.transaction_id)
            medical_examination.medical_examination_details.where(condition_id: certification_conditions).destroy_all
        end

        if @appeal.result == "CONDITIONAL_SUCCESSFUL"
            block_reason = BlockReason.find_by(code: "MOHCASE", category: "BLOCK")
            block_comment = "Conditional Appeal successful (MOH allowed for one year only), therefore the following year this worker are not allowed to register again at FOMEMA."
            block_reg_medical(@transaction.foreign_worker, block_reason, block_comment, user: current_user)
        end

        redirect_to internal_appeals_path(cookied_path: "y"), notice: "Appeal #{ @appeal.id } #{ notice }"
    end

    def appeal_results
        redirect_to internal_appeals_path and return if !@appeal.is_moh && current_user.role.code == "MOH_APPROVER"
        @transaction        = @appeal.transactionz
        @appeal_todos       = @appeal.medical_appeal_todos.includes(:appeal_todo)
        @appeal_comments    = @appeal.medical_appeal_comments.order(:id)
        set_transaction_results_instances
    end

    def new_comment
        @appeal.medical_appeal_comments.create(comment: params[:new_comment])
        redirect_to internal_appeal_path(@appeal.id, p_tab: "appeal", tab: "appeal_comments")
    end

    def cancel_appeal_approval_request
        approval_attributes = @appeal.latest_medical_appeal_approval.slice(:medical_appeal_id, :medical_mle1_decision, :medical_mle1_id, :medical_mle1_decision_at, :medical_mle1_comment)
        @appeal.latest_medical_appeal_approval.destroy
        MedicalAppealApproval.create(approval_attributes) # Create exact one, because user still wants to see his/her comment.
        !@appeal.is_moh ? @appeal.update(status: "EXAMINATION") : @appeal.update(status: "PENDING_MOH_APPROVAL")
        redirect_to internal_appeal_path(@appeal.id, p_tab: "appeal", tab: "appeal_reason")
    end

    def appeal_employer_instruction_letter
        @transaction        = @appeal.transactionz
        doctor              = @appeal.doctor
        render plain: "Unable to generate letter without a selected doctor" and return if doctor.blank?
        employer            = @appeal.employer
        employer_address    = [employer.name, employer.address1, employer.address2, employer.address3, employer.address4, "#{ employer.postcode } #{ employer&.town&.name }", employer&.state&.name].select(&:present?)
        doctor_address      = [doctor.clinic_name, doctor.address1, doctor.address2, doctor.address3, doctor.address4, "#{ doctor.postcode } #{ doctor&.town&.name }", doctor&.state&.name].select(&:present?)
        display_doc_tag     = "DR " if doctor.name[0..1] != "DR"

        @data = {
            letter_ref_no:          "L#{ @appeal.id }/#{ Date.today.strftime("%Y-%m") }/EMP/MED-APPEAL/FOM",
            letter_date:            Date.today.strftime("%d/%m/%Y"),
            employer_address:       employer_address,
            worker_name:            @transaction.fw_name,
            worker_passport_no:     @transaction.fw_passport_number,
            doctor_name:            "#{ display_doc_tag }#{ doctor.name }",
            doctor_address:         doctor_address,
            doctor_phone:           doctor.phone,
            doctor_fax:             doctor.fax,
        }

        render pdf: "appeal_employer_instruction_letter",
        template: "/internal/appeals/appeal_employer_instruction_letter.html.erb",
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

    def pcr_second_third_opinion
        unless second_third_opinion_check
            PcrPool.create(medical_appeal_id: @appeal.id, case_type: "XRAY_APPEAL_NORMAL", status: "PCR_POOL", source: "MERTS", xray_retake_id: @retake.try(:id))

            DigitalXrayMovement.create(
                transaction_id:     @appeal.transaction_id,
                moveable_type:      "XrayRetake",
                moveable_id:        @retake.id,
                status:             "APPEAL-PCR-POOL-#{ @pcr_count == 2 ? "THIRD" : "SECOND" }-OPINION",
                description:        "Appeal Retake Examination Results sent to PCR Pool for #{ @pcr_count == 2 ? "3rd" : "2nd" } opinion"
            )

            @retake.update(status: "PCR_REVIEW", pcr_id: nil, pcr_picked_up_at: nil)
            @appeal.update(pcr_result: nil)
            flash[:notice] = "Submitted x-ray results to PCR Pool for #{ @pcr_count == 2 ? "3rd" : "2nd" } opinion"
        end

        redirect_to internal_appeal_path(@appeal.id, p_tab: "appeal", tab: "appeal_todos")
    end

    def repeat_xray
        redicect_to internal_appeal_path(@appeal.id, p_tab: "appeal", tab: "appeal_todos"), error: "This retake is still under review" and return if @appeal.current_xray_retake&.status != "CLOSED"
        @appeal.xray_retakes.update(current_appeal_retake: false)
        retake      = XrayRetake.find_or_create_by(requestable_type: "MedicalAppeal", requestable_id: @appeal.id, status: "NEW", transaction_id: @appeal.transaction_id)
        xray_exam   = XrayExamination.find_or_initialize_by(transaction_id: @appeal.transaction_id, sourceable: retake)
        xray_exam.update(xray_ref_number: retake.code) unless xray_exam.id?
        @appeal.update(xray_result: nil, pcr_result: nil, radiologist_id: nil, xray_facility_id: nil, xray_selected_at: nil, xray_facility_done_at: nil, radiologist_done_at: nil)
        redirect_to internal_appeal_path(@appeal.id, p_tab: "appeal", tab: "appeal_todos"), notice: "Repeating X-Ray Examination. Please select a new X-Ray Facility."
    end

    def document_completed_report
        appeal_ids  = params[:appeals].split(",")
        @appeals    = MedicalAppeal.where(id: appeal_ids).includes(:latest_medical_appeal_approval, :transactionz, :medical_appeal_conditions, foreign_worker: [:job_type]).order(:id)
        @condition_id_display_hash  = DoctorExamination.certification_conditions_for_appeal_document
        @condition_id_keys          = @condition_id_display_hash.keys

        @data = {
            date: Date.today.strftime("%d-%m-%Y"),
            time: Time.now.strftime("%l:%M:%S %p"),
            name: current_user.name
        }

        @other_hits = []

        @condition_id_hits = @appeals.map do |appeal|
            conditions  = appeal.medical_appeal_conditions.map(&:condition_id)
            cond_hits   = (conditions & @condition_id_keys).map {|condition_id| @condition_id_display_hash[condition_id] }.sort.uniq.compact

            if cond_hits.include?("OTHERS")
                @other_hits << appeal.transaction_id
                cond_hits -= ["OTHERS"]
            end

            [appeal.id, cond_hits]
        end.to_h

        other_condition_comment = Condition.find_by(code: "5501").id
        med_exam_comments       = MedicalExaminationComment.where(transaction_id: @other_hits, condition_id: other_condition_comment).pluck(:transaction_id, :comment).to_h
        doc_exam_comments       = DoctorExaminationComment.where(transaction_id: @other_hits, condition_id: other_condition_comment).pluck(:transaction_id, :comment).to_h

        @other_comments = @other_hits.map do |transaction_id|
            comment = med_exam_comments[transaction_id] || doc_exam_comments[transaction_id]
            [transaction_id, comment]
        end.to_h

        render pdf: "appeal_report_summary",
        template: "/pdf_templates/appeal_report_summary.html.erb",
        layout: "pdf.html",
        margin: {
            top: 14,
            left: 14,
            right: 14,
            bottom: 14,
        },
        page_size: nil,
        page_height: "21cm",
        page_width: "29.7cm",
        dpi: "300",
        header: {
            html: {
                template: '/pdf_templates/appeal_report_summary_header'
            }
        }
    end

    def send_appeal_reminder_email
        AppealMailer.with({
            appeal: @appeal.reload,
        }).employer_appeal_reminder_email.deliver_later

        unless @appeal.reload.doctor_id.blank?
            AppealMailer.with({
                appeal: @appeal.reload,
                url: "#{ENV["APP_URL_MERTS"]}appeals/#{@appeal.id}/appeal_doctor_instruction_letter",
            }).doctor_appeal_reminder_email.deliver_later
        end
    end

    def send_reminder_sms
        return if SystemConfiguration.get("MSG_ENABLE_SMS") == "0"

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
private
    def set_appeal_instance
        id      = params[:appeal_id] || params[:id]
        @appeal = MedicalAppeal.find_by(id: id)
        redirect_to internal_appeals_path(cookied_path: "y"), alert: "Appeal does not exist" if @appeal.blank?
    end

    def medical_appeal_params
        params.require(:medical_appeal).permit(:appeal_reason, :officer_in_charge_id, :doctor_id, :is_moh, :is_specialist)
    end

    def medical_appeal_decision
        params.permit(:medical_mle1_comment, :medical_mle1_decision)
    end

    def set_transaction_results_instances
        @medical_review         = @transaction.latest_medical_review
        @tcupi_review           = @transaction.latest_tcupi_review
        @pcr_comments           = @transaction.pcr_reviews
        @xray_pending_decisions = @transaction.xray_pending_decisions

        # NF-1722 - show only transaction's related, no need previous blah blah blah
        # @previous_xqcc_pd       = XrayPendingDecision.joins(:transactionz).where(status: "TRANSMITTED", transactions: { foreign_worker_id: @transaction.foreign_worker_id}).where.not(transaction_id: @transaction.id).includes(:transactionz).order(id: :desc)

        # NF-1835 - Display transaction_comments & xqcc_transaction_comments from migrated data.
        @display_t_comments     = @transaction.transaction_comments.order(:created_at)
        @display_xt_comments    = @transaction.xqcc_transaction_comments.order(:created_at)

        @result_updates         = @transaction.transaction_result_updates.includes(:user).order(id: :desc)
        @amendments             = @transaction.transaction_amendments.includes(:user, :approved_by).order(id: :desc)
        @skip_visited           = true
    end

    def second_third_opinion_check
        @retake             = @appeal.current_xray_retake
        flash[:error]       = "This retake is still under review" and return true if @retake&.status != "CLOSED"
        @pcr_count          = PcrPool.unscoped.joins(:xray_retake).where(medical_appeal_id: @appeal.id, xray_retakes: { current_appeal_retake: true }).count
        flash[:error]       = "There are already #{ @pcr_count } reviews. Cannot request for more." and return true if @pcr_count > 2
        return false
    end

    def appeal_officer_list
        review_permissions  = Role.joins(:role_permissions).where(status: "ACTIVE", category: "Organization", role_permissions: { permission: "REVIEW_APPEALS" }).pluck(:id)
        approve_permissions = Role.joins(:role_permissions).where(status: "ACTIVE", category: "Organization", role_permissions: { permission: "APPROVE_APPEALS" }).pluck(:id)
        User.where(status: "ACTIVE", userable_type: "Organization", role_id: review_permissions - approve_permissions)
    end

    def set_company_name
        @company_name = SystemConfiguration.find_by(code: 'COMPANY_NAME')&.value.try(:upcase)
    end
end