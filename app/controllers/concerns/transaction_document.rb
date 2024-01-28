module TransactionDocument

    def bulk_print_medical_form

        @transaction_ids  = params[:ids].split(/,/)

        @transactions = Transaction.where(id: @transaction_ids)

        unless can_print_transactions?(@transactions)
            render html: "<div>You are not allowed to print medical examination form for the selected transaction(s) due to any of the followings:<ul>
        <li>The worker has carried out medical examination</li>
        <li>The transaction has expired</li>
        <li>The transaction has been cancelled</li>
        <li>The transaction has been rejected</li>
        <li>The transaction is pending for approval</li>
        <li>The transaction is pending for clinic selection</li></ul></div>".html_safe and return
        end

        charge_medical_form
    end

    def medical_form_print

        @transaction_ids = [params[:id]]

        @transactions = Transaction.where(id: @transaction_ids)

        can_print = is_transaction_printable

        charge_medical_form if can_print == true
    end

    def print_medical_form
        @transactions = Transaction.includes(doctor_examination: [:doctor], laboratory_examination: [:laboratory], foreign_worker: [:employer, :country]).find(@transaction_ids)

        @title = 'Print Medical Examination Form'
        @cancel_fee = Fee.find_by(code: 'CANCEL_TRANSACTION').amount

        log_print_med_form(@transaction_ids)

        render_pdf
    end

    def render_pdf
        # debug mode on / off

        @debug = false

        # enable debug by passing ?debug param in url
        if params.has_key?(:debug)
            @debug = true
            render 'external/transactions/medical_form_print_v4', layout: 'pdf'
        else
            render pdf: "medical_form_print_v4",
            template: "external/transactions/medical_form_print_v4.html.erb",
            layout: "pdf.html",
            margin: {
                top: 1,
                left: 1,
                right: 3,
                bottom: 0,
            },
            page_size: nil,
            page_height: "29.7cm",
            page_width: "21cm",
            dpi: "300"
        end
    end

    def can_print_transactions?(transactions)

        result = true

        transactions.each do |transaction|
            if !transaction.can_print_medical_examination_form?
                result = false and return
            end
        end

        result
    end

    def log_print_med_form(transaction_ids)

        unless transaction_ids.nil?

            transaction_ids.each do |transaction_id|

                @medical_form_print_log = MedicalFormPrintLog.new({ transaction_id: transaction_id })
                @medical_form_print_log.save

            end

        end

    end

    def unsuitable_slip
        # redirect_to "", alert: "Cannot download slip" and return if !on_nios? && !@transaction.unsuitable_slip_download
        redirect_to "", alert: "Cannot download slip" and return if !on_nios? && @transaction.is_imm_blocked
        reasons             = @transaction.unsuitable_reasons.order(:priority)
        sent_to_immigration = @transaction.myimms_transaction.created_at.strftime("%d/%m/%Y") if @transaction.myimms_transaction.try(:created_at)
        employer            = @transaction.employer
        employer_address    = [employer.name, employer.address1, employer.address2, employer.address3, employer.address4, "#{ employer.postcode } #{ employer&.town&.name }", employer&.state&.name].select(&:present?)

        @data = {
            result_date:        sent_to_immigration,
            slip_date:          Time.now.strftime("%d/%m/%Y"),
            worker_code:        @transaction.fw_code,
            worker_name:        @transaction.fw_name,
            worker_gender:      @transaction.fw_gender == "F" ? "PEREMPUAN" : "LELAKI",
            worker_gender_bi:   @transaction.fw_gender == "F" ? "FEMALE" : "MALE",
            worker_passport:    @transaction.fw_passport_number,
            worker_country:     @transaction.fw_country&.name,
            failed_reasons_bm:  reasons.map {|x| x[:reason_bm]},
            employer_address:   employer_address,
            failed_reasons_bi:  reasons.map {|x| x[:reason_en]}
        }

        render pdf: "unsuitable_slip_template",
        template: "/pdf_templates/unsuitable_slip_template_v2.html.erb",
        layout: "pdf.html",
        margin: {
            top: "2cm",
            left: "2cm",
            right: "2cm",
            bottom: "2cm"
        },
        page_size: nil,
        page_height: "29.7cm",
        page_width: "21cm",
        dpi: "300",
        footer: { font_size: 8, right: "Page " "[page] of [topage]" }
    end

    def medical_report_letter
        redirect_to "", alert: "Cannot download medical report letter" and return if !on_nios? && !@transaction.medical_report_letter_download && @transaction.is_imm_blocked
        employer = @transaction.employer
        doctor = @transaction.doctor
        employer_address = [employer.address1, employer.address2, employer.address3, employer.address4, "#{ employer.postcode } #{ employer&.town&.name }", employer&.state&.name].select(&:present?)
        clinic_address = [doctor.address1, doctor.address2, doctor.address3, doctor.address4, "#{ doctor.postcode } #{ doctor&.town&.name }", doctor&.state&.name].select(&:present?)

        @data = {
            worker_code: @transaction.fw_code,
            worker_name: @transaction.fw_name,
            worker_gender: @transaction.fw_gender == "F" ? "PEREMPUAN" : "LELAKI",
            worker_passport: @transaction.fw_passport_number,
            worker_country:  @transaction.fw_country&.name,
            transaction_code: @transaction.code,
            medical_examination_date: @transaction.medical_examination_date.strftime(get_standard_date_format),
            final_result: @transaction.final_result,
            doctor_name: doctor.name,
            clinic_name: doctor.clinic_name,
            clinic_address: clinic_address,
            clinic_phone: doctor.phone,
            employer_name: employer.name,
            employer_email: employer.email,
            employer_phone: employer.phone,
            employer_address: employer_address,
            company_name: SystemConfiguration.get('COMPANY_NAME'),
            letter_ref_no: "#{@transaction.code}/#{@transaction.fw_code}/#{Time.now.year}-#{"%02d" % Time.now.month}/EMP/MRAD",
        }

        render pdf: "medical_report_letter",
        template: "/pdf_templates/medical_report_letter.html.erb",
        layout: "pdf.html",
        margin: {
            top: "1.5cm",
            left: "2cm",
            right: "2cm",
            bottom: "2cm"
        },
        page_size: nil,
        page_height: "29.7cm",
        page_width: "21cm",
        dpi: "300",
        footer: { font_size: 8, right: "Page " "[page] of [topage]" }
    end

    def new_radiologist_approval_letter
        template = Sablon.template "#{Rails.root.to_s}/app/views/doc_templates/service-provider-approval-letter-new-radiologist-template.docx"

        context = {
            letter_ref_no: '123',
            letter_date: Time.now.strftime("%d/%m/%Y"),
            receipt_trans_no: '6150168',

            radio_name: @transaction.radiologist.name,
            radio_xray_fac_name: @transaction.radiologist.xray_facility_name,
            radio_code: @transaction.radiologist.code,
            radio_address1: @transaction.radiologist.address1,
            radio_address2: @transaction.radiologist.address2,
            radio_address3: @transaction.radiologist.address3,
            radio_address4: @transaction.radiologist.address4,
            radio_town: @transaction.radiologist&.town&.name,
            radio_postcode: @transaction.radiologist.postcode,
            radio_state: @transaction.radiologist&.state&.name,
        }

        properties = {
            start_page_number: 1
        }

        data = template.render_to_string context, properties
        send_data data, filename: "new-radiologist-approval-#{@transaction.code}.docx"

    end

    def examination_report
        template = Sablon.template "#{Rails.root.to_s}/app/views/doc_templates/examination_report.docx"
        doctor      = @transaction.doctor
        reasons     = @transaction.unsuitable_reasons.order(:priority)
        appeal      = @transaction.latest_medical_appeal
        pcr_review  = @transaction.pcr_reviews
        @worker     = @transaction.foreign_worker
        xray_examination =@transaction.xray_examination
        laboratory_examination = @transaction.laboratory_examination
        past_exams  = @worker.transactions.where.not(id: @transaction.try(:id)).where("status ='CERTIFIED'").order(transaction_date: :desc)
        @xray_pending_decisions = @transaction.xray_pending_decisions
        impression = Condition.where(code: ["2014"]).pluck(:id)
        xray_examination_condition_comment = xray_examination.xray_examination_comments.where.not(condition_id: impression)
        xray_examination_comment = xray_examination.xray_examination_comments.where(condition_id: impression).first
        lab_reason = Condition.where(code: ["1056"]).pluck(:id)
        lab_reason_comment = laboratory_examination.laboratory_examination_comments.where(condition_id: lab_reason).first
        med_exam = @transaction.medical_examination || @transaction.doctor_examination

        case med_exam.class.to_s
        when "MedicalExamination"
            @doctor_result = med_exam&.suitability
        when
            @doctor_result = med_exam&.suitability
        end

        if pcr_review.present?
            @pcr_review_date = @transaction.pcr_review&.transmitted_at.strftime(get_standard_date_format)
            @pcr_comment = @transaction.pcr_review&.comment
            @pcr_result = @transaction.pcr_review&.result
            @pcr_name = @transaction.pcr_review.pcr_user&.name
            pcr_id = @transaction.pcr_review&.pcr_id
            radiologist = Radiologist.find_by(user_id: pcr_id)
            @nsr_no = radiologist.present? ? radiologist.nsr_number : ''
        end

        if @xray_pending_decisions.present?
            @xray_decision_approval_date = @transaction.xray_pending_decision&.transmitted_at.strftime(get_standard_date_format)
            @xray_pending_decision_comment = @transaction.xray_pending_decision&.comment
            @xray_pending_desision_result = @transaction.xray_pending_decision&.decision
        end

        if appeal.present?
            @appeal_date         = appeal.created_at.strftime(get_standard_date_format) if appeal.created_at?
            @appeal_release_date = appeal.completed_at.strftime(get_standard_date_format) if appeal.completed_at?
            @appeal_status       = appeal.displayed_status if appeal.status?
            @approval_appeal     = appeal.latest_medical_appeal_approval
        end

        if @approval_appeal.present?
            @approval_comment = @approval_appeal.medical_mle1_comment
        end

        if past_exams.present?
            examination_history = past_exams.each_with_index.map do |transaction, index|
               exam_history = "#{index + 1}. #{transaction.transaction_date.strftime("%d/%m/%Y")} - #{transaction.final_result}"
            end
               @exam_history = examination_history.join("\n")
        end

        if xray_examination_condition_comment.present?
            xray_exam_detail = xray_examination_condition_comment.each_with_index.map do |exam, index|
                @xray_comment_condition = exam.comment
            end
                @xray_comment_condition = xray_exam_detail.join(",")
        end

        if lab_reason_comment.present?
            @lab_reason_comment = lab_reason_comment.comment
        end

        context = {
            worker_name: @transaction.fw_name,
            worker_code: @transaction.fw_code,
            passport_number: @transaction.fw_passport_number,
            country: @transaction.fw_country&.name,
            gender: @transaction.fw_gender == "F" ? "PEREMPUAN" : "LELAKI",
            job_type: @transaction.fw_job_type&.name,
            medical_examination_date: @transaction.medical_examination_date.strftime(get_standard_date_format),
            certification_date: @transaction.certification_date.strftime(get_standard_date_format),
            arrival_date: @transaction.foreign_worker.arrival_date.present? ? @transaction.foreign_worker.arrival_date.strftime(get_standard_date_format) : '',
            final_result: @transaction.final_result,
            unfit_reason: reasons.map {|x| x[:reason_bm]},
            employer_name: @transaction.employer.name,
            employer_address: @transaction.employer&.displayed_address,
            doctor_name: doctor.name,
            clinic_name: doctor.clinic_name,
            lab_name: @transaction.laboratory.name,
            xray_name: @transaction.xray_facility_name,
            xray_report_date: @transaction.xray_transmit_date.strftime(get_standard_date_format),
            laboratory_report_date:@transaction.laboratory_transmit_date.strftime(get_standard_date_format),
            doctor_result: @doctor_result,
            xray_result: @transaction.xray_examination&.result,
            xray_taken_date: @transaction.xray_examination&.xray_taken_date.strftime(get_standard_date_format),
            lab_result: @transaction.laboratory_examination&.result,
            pcr_review_date: @pcr_review_date,
            pcr_comment: @pcr_comment,
            pcr_result: @pcr_result,
            pcr_name: @pcr_name,
            nsr_no: @nsr_no,
            appeal_date: @appeal_date,
            appeal_release_date: @appeal_release_date,
            appeal_status: @appeal_status,
            appeal_comment: @approval_comment.present? ? @approval_comment : '',
            exam_history: @exam_history,
            xray_pending_decision_date: @xray_decision_approval_date,
            xray_pending_decision_comment: @xray_pending_decision_comment,
            xray_pending_desision_result: @xray_pending_desision_result,
            xray_comment_condition: @xray_comment_condition,
            xray_impression: xray_examination_comment.comment.present? ? xray_examination_comment.comment : '',
            lab_reason_comment: @lab_reason_comment
        }

        properties = {
            start_page_number: 1
        }

        data = template.render_to_string context, properties
        send_data data, filename: "examination_report-#{@transaction.code}.docx"
    end


    def tcupi_audit_case_letter
        employer            = @transaction.employer
        employer_address    = [employer.name, employer.address1, employer.address2, employer.address3, employer.address4, "#{ employer.postcode } #{ employer&.town&.name }", employer&.state&.name].select(&:present?)
        doctor              = @transaction.doctor
        tcupi_letter_object = @transaction.tcupi_letters.find_by(letter_type: "audit")
        # tcupi_letter_object = nil if tcupi_letter_object.blank? && @transaction.tcupi_date?
        letter_id           = tcupi_letter_object&.letter_id || 0

        @data = {
            letter_ref_no:          "L#{ "%05i" % letter_id }/#{ @transaction.tcupi_date.strftime("%y") }/PR/Med.Dept/FOM",
            letter_date:            Date.today.strftime("%d/%m/%Y"),
            worker_name:            @transaction.fw_name,
            worker_code:            @transaction.fw_code,
            worker_passport:        @transaction.fw_passport_number,
            doctor_name:            doctor.name,
            clinic_name:            doctor.clinic_name,
            employer_address:       employer_address,
            phone:                  employer.phone,
            fax:                    employer.fax
        }

        render pdf: "tcupi_audit_letter",
        template: "/pdf_templates/tcupi_audit_letter.html.erb",
        layout: "pdf.html",
        show_as_html: params[:debug].present?,
        margin: {
            top: "1.5cm",
            left: "2cm",
            right: "2cm",
            bottom: "2cm",
        },
        page_size: nil,
        page_height: "29.7cm",
        page_width: "21cm",
        dpi: "300",
        footer: {font_size: 8, right: "Page " "[page] of [topage]" }
    end

    def tcupi_nonaudit_case_letter
        employer                = @transaction.employer
        employer_address        = [employer.name, employer.address1, employer.address2, employer.address3, employer.address4, "#{ employer.postcode } #{ employer&.town&.name }", employer&.state&.name].select(&:present?)
        doctor                  = @transaction.doctor
        reasons                 = @transaction.pending_review_criteria_check
        tcupi_todos             = @transaction.latest_tcupi_review.list_of_tcupi_todos
        non_audit_todos         = (tcupi_todos - ["To audit CXR by FOMEMA"])
        tcupi_letter_object     = @transaction.tcupi_letters.find_by(letter_type: "nonaudit")
        letter_id               = tcupi_letter_object&.letter_id || 0

        @data = {
            letter_ref_no:          "L#{ "%05i" % letter_id }/#{ @transaction.tcupi_date.strftime("%y") }/PR/Med.Dept/FOM",
            letter_date:            Date.today.strftime("%d/%m/%Y"),
            worker_name:            @transaction.fw_name,
            worker_code:            @transaction.fw_code,
            worker_passport:        @transaction.fw_passport_number,
            doctor_name:            doctor.name,
            clinic_name:            doctor.clinic_name,
            employer_address:       employer_address,
            phone:                  employer.phone,
            fax:                    employer.fax,
            reasons:                reasons,
            todo_list:              non_audit_todos
        }

        render pdf: "tcupi_nonaudit_letter",
        template: "/pdf_templates/tcupi_nonaudit_letter.html.erb",
        layout: "pdf.html",
        show_as_html: params[:debug].present?,
        margin: {
            top: "1.5cm",
            left: "2cm",
            right: "2cm",
            bottom: "2cm",
        },
        page_size: nil,
        page_height: "29.7cm",
        page_width: "21cm",
        dpi: "300",
        footer: {font_size: 8, right: "Page " "[page] of [topage]" }
    end

    def report_print
        @type = current_user.userable_type

        if @type == XrayFacility.to_s || @type == Radiologist.to_s
            @pdf_layout = 'H'
            @template_url = "pdf_templates/xray_result_report.html.erb"
            @title = "CHEST X-RAY FINDINGS"
            @pdf = "xray_result_report"
        elsif @type == Doctor.to_s || Employer.to_s
            @pdf_layout = 'V'
            @template_url = "pdf_templates/doctor_examination_results/doctor_result_report.html.erb"
            @title = "MEDICAL EXAMINATION RESULT"
            @pdf = "doctor_result_report"
        end
        render_result_report_pdf
    end

    def render_result_report_pdf
        # horizontal or vertical
        if @pdf_layout == 'H'
            page_height = "21cm"
            page_width = "29.7cm"
            margin = {
                top: 10,
                left: 10,
                right: 10,
                bottom: 15,
            }
        else
            page_height = "29.7cm"
            page_width = "21cm"
            margin = {
                top: 18,
                left: 10,
                right: 10,
                bottom: 15,
            }
        end

        @debug = false
        @print_datetime = Time.now.strftime("%d/%m/%Y %H:%M:%S")

        if params.has_key?(:debug)
            @debug = true
            render @template_url, layout: 'pdf'
        else
            render pdf: @pdf,
            template: @template_url,
            layout: "pdf.html",
            margin: margin,
            page_size: nil,
            page_height: page_height,
            page_width: page_width,
            dpi: "300",
            header: {
                html: {
                    template: '/pdf_templates/medical_result_header',
                }
            },
            footer: {
                html: {
                    template: '/pdf_templates/medical_result_footer',
                    locals: {
                        print_datetime: @print_datetime
                    }
                }
            }
        end
    end

    def charge_medical_form
        if site == 'PORTAL'
            check_reprint = SystemConfiguration.get("REPRINTPLY", "0")
            if check_reprint == '0'
                print_medical_form
                return
            end
        end

        # check if all transactions are from the same employer
        employers = @transactions.pluck(:employer_id).uniq
        if employers.count > 1
            flash[:warning] = "Make sure all the transactions selected are from the same employer"
            redirect_to request.referrer and return
        end

        # charge if reprint
        first_print = true
        failed_messages = []
        @transactions.each do |transaction|
            medical_form_prints = transaction.medical_form_print_logs
            # if site == 'PORTAL'
            #     medical_form_prints = medical_form_prints.where(:created_by => current_user.id)
            # end

            if medical_form_prints.count >= 1
                first_print = false

                order_item = Order.where(:category => 'REPRINT_MEDICAL_FORM', :status => ['NEW','PENDING_PAYMENT'])
                .joins(:order_items)
                .where(order_items:{ order_itemable_type: 'Transaction', order_itemable_id: transaction.id}).first

                if order_item.present?
                    failed_messages << "Transaction #{transaction.code} still has pending reprint medical payment."
                end

            end
        end

        if first_print
            print_medical_form
            return
        end

        if failed_messages.length > 0
            flash[:errors] = failed_messages
            redirect_to request.referrer and return
        end

        case site
        when "NIOS"
            @redirect_to = reprint_medical_form_internal_transactions_path(:ids => @transactions.pluck(:id).join(','))
        when "PORTAL"
            fee = Fee.find_by(code: "REPRINT_MEDICAL_FORM")

            @order = Order.create({
                customerable: Employer.find(employers.first),
                category: "REPRINT_MEDICAL_FORM",
                amount: 0,
                additional_information: {
                    transaction_ids: @transactions.pluck(:id)
                }
            })

            @transactions.each do |transaction|
                print_count = transaction.medical_form_print_logs.count
                if print_count > 0
                    @order.order_items.create({
                        order_itemable: transaction,
                        fee_id: fee.id,
                        amount: fee.amount,
                    })
                end
            end

            @order.update_total_amount

            if fee.amount > 0
                @redirect_to = edit_external_order_path(@order)
            else
                @order.update({
                    status: 'PAID',
                    paid_at: DateTime.now,
                    payment_method: PaymentMethod.find_by(code: "FOC")
                })
                print_medical_form
                return
            end
        end

        redirect_to @redirect_to and return
    end

    def is_transaction_printable
        print = true
        message = ''
        @transactions.each do |transaction|
           case transaction.status
           when 'CANCELLED'
                print = false
                message = "The transaction has been cancelled. You are not allowed to print medical examination form." and break
           when 'REJECTED'
                print = false
                message = "The transaction has been rejected. You are not allowed to print medical examination form." and break
           when 'NEW_PENDING_APPROVAL'
                print = false
                message = "Transaction is pending for approval. You are not allowed to print medical examination form." and break
           end

           case transaction.approval_status
           when 'UPDATE_PENDING_APPROVAL'
                print = false
                message = "Transaction is pending for approval. You are not allowed to print medical examination form." and break
           end

           if transaction.expired_at < Time.now && [nil,'',false].include?(transaction.ignore_expiry)
                print = false
                message = "The transaction has expired. You are not allowed to print medical examination form." and break
           end

            if transaction.doctor_id.blank?
                print = false
                message = "Transaction is pending for doctor selection. You are not allowed to print medical examination form." and break
            end

            if !transaction.certification_date.blank?
                print = false
                message = "Medical examination has completed. You are not allowed to print medical examination form." and break
            end
        end

        if print == false
            render plain: message
        end

        return print
    end

    def appeal_pdpa_form
        appeal_id = params[:appeal_id]

        appeal              = @transaction.medical_appeals.find_by(id: appeal_id)
        reasons             = @transaction.unsuitable_reasons.order(:priority)
        employer            = @transaction.employer
        employer_address    = [employer.address1, employer.address2, employer.address3, employer.address4, "#{ employer.postcode } #{ employer&.town&.name }", employer&.state&.name].select(&:present?)
        agency            = @transaction.agency

        @data = {
            consented_date:     appeal&.employer_consented_at.try(:strftime, get_standard_date_format) || Time.now.try(:strftime, get_standard_date_format),
            worker_code:        @transaction.fw_code,
            worker_name:        @transaction.fw_name,
            worker_gender:      @transaction.fw_gender == "F" ? "PEREMPUAN" : "LELAKI",
            worker_passport:    @transaction.fw_passport_number,
            worker_country:     @transaction.fw_country&.name,
            worker_dob:         @transaction.fw_date_of_birth.try(:strftime, get_standard_date_format),
            failed_reasons_bm:  reasons.map {|x| x[:reason_bm]},
            employer_address:   employer_address,
            employer_name:      employer.name,
            employer_phone:     employer.phone,
            employer_email:     employer.email,
            agency_name:        agency&.name,
            agency_phone:       agency&.phone,
            agency_email:       agency&.email,
            clinic_name:        @transaction.doctor.clinic_name,
            examination_date:   @transaction.medical_examination_date.try(:strftime, get_standard_date_format),
            certification_date: @transaction.certification_date.try(:strftime, get_standard_date_format)
        }
        if (appeal.registered_by_type == "Employer")
            pdf = "appeal_pdpa_form_template"
            template = "/pdf_templates/appeal_pdpa_form_template.html.erb"
        elsif (appeal.registered_by_type == "Agency")
            pdf = "appeal_agency_pdpa_form_template"
            template = "/pdf_templates/appeal_agency_pdpa_form_template.html.erb"
        end
        render pdf: pdf,
        template: template,
        layout: "pdf.html",
        margin: {
            top: "1cm",
            left: "1.5cm",
            right: "1.5cm",
            bottom: "1cm"
        },
        page_size: nil,
        page_height: "29.7cm",
        page_width: "21cm",
        dpi: "300",
        footer: { font_size: 8, right: "Page " "[page] of [topage]" }
    end

    def special_renewal_authorisation_letter
        transaction_id = params[:transaction_id]

        employer            = @transaction.employer
        employer_address    = [employer.address1, employer.address2, employer.address3, employer.address4, "#{ employer.postcode } #{ employer&.town&.name }", employer&.state&.name].select(&:present?)
        agency              = @transaction.agency

        @data = {
            letter_date:        Date.today.strftime("%d/%m/%Y"),
            worker_code:        @transaction.fw_code,
            worker_name:        @transaction.fw_name,
            worker_passport:    @transaction.fw_passport_number,
            worker_country:     @transaction.fw_country&.name,
            employer_address:   employer_address,
            employer_name:      employer.name,
            employer_phone:     employer.phone,
            employer_pic:       employer.pic_name? ?  employer.pic_name : employer.name,
            employer_ic_roc:    employer.business_registration_number? ?  employer.business_registration_number : employer.ic_passport_number,
            agency_name:        agency&.name,
            agency_phone:       agency&.phone,
        }

        if !@agency.nil?
            pdf = "special_renewal_agency_authorisation_form_template"
            template = "/pdf_templates/special_renewal_agency_authorisation_form_template.html.erb"
        else
            pdf = "special_renewal_employer_authorisation_form_template"
            template = "/pdf_templates/special_renewal_employer_authorisation_form_template.html.erb"
        end

        render pdf: pdf,
        template: template,
        layout: "pdf.html",
        margin: {
            top: "1cm",
            left: "2cm",
            right: "2cm",
            bottom: "1cm"
        },
        page_size: nil,
        page_height: "29.7cm",
        page_width: "21cm",
        dpi: "300",
        footer: { font_size: 8, right: "Page " "[page] of [topage]" }
    end

end