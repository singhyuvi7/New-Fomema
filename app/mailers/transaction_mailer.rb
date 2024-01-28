class TransactionMailer < ApplicationMailer
    def cancel_email
        @transaction = params[:transaction]
        @employer = @transaction.employer
        @supplement_employer = @transaction.foreign_worker.employer_supplement
        @agency = @transaction.agency
        @customer = !@agency.nil? ? @agency : @employer

        if @transaction.foreign_worker.employer_supplement.blank? || !@agency.nil?
            mail(to: @customer.email, subject: "Transaction cancelled")
        else
            mail(to: @supplement_employer.email, cc: @employer.email, subject: "Transaction cancelled")
        end
    end

    def send_unsuitable_letter_cannot_appeal(transaction_id)
        @transaction        = Transaction.find(transaction_id)
        @employer           = @transaction.employer
        @agency              = @transaction.agency
        employer_address    = [@employer.name, @employer.address1, @employer.address2, @employer.address3, @employer.address4, "#{ @employer.postcode } #{ @employer&.town&.name }", @employer&.state&.name].select(&:present?)
        reasons             = @transaction.unsuitable_reasons.order(:priority)

        @data = {
            slip_date:          Time.now.strftime("%d/%m/%Y"),
            worker_code:        @transaction.fw_code,
            worker_name:        @transaction.fw_name,
            worker_gender:      @transaction.fw_gender == "F" ? "PEREMPUAN" : "LELAKI",
            worker_gender_bi:      @transaction.fw_gender == "F" ? "FEMALE" : "MALE",
            worker_passport:    @transaction.fw_passport_number,
            worker_country:     @transaction.fw_country&.name,
            employer_address:   employer_address,
            failed_reasons_bm:  reasons.map {|x| x[:reason_bm]},
            failed_reasons_bi:  reasons.map {|x| x[:reason_en]}
        }

        # body_html = render_to_string( partial: "/pdf_templates/unsuitable_letter.html.erb" )

        # pdf = WickedPdf.new.pdf_from_string(
        #     body_html,
        #     margin: {
        #         top: "1.5cm",
        #         left: "1.5cm",
        #         right: "1.5cm",
        #         bottom: "1.5cm"
        #     },
        #     page_size: nil,
        #     page_height: "29.7cm",
        #     page_width: "21cm",
        #     dpi: "300",
        #     footer: {font_size: 8, right: "Page " "[page] of [topage]" }
        # )

        # attachments["#{ @transaction.fw_code } - #{ @transaction.fw_name }.pdf"] = pdf
        attachments.inline["fomema-logo.png"]  = File.read(Rails.root.join("app/assets/images/logo/", "fomema-logo.png"))
        # attachments.inline["logojim2.png"]          = File.read(Rails.root.join("app/assets/images/logo/", "logojim2.png"))

        if Rails.env.production? || Rails.env.production1? || Rails.env.production2? || Rails.env.production3?
            if !@agency.nil?
                mail(to: @employer.email, cc:@agency.email, bcc: "pbo@imi.gov.my", subject: "NOTIS PENGHANTARAN PULANG KE NEGARA ASAL UNTUK PEKERJA ASING DIDAPATI TIDAK SESUAI SELEPAS PEMERIKSAAN KESIHATAN FOMEMA")
            else
                mail(to: @employer.email, bcc: "pbo@imi.gov.my", subject: "NOTIS PENGHANTARAN PULANG KE NEGARA ASAL UNTUK PEKERJA ASING DIDAPATI TIDAK SESUAI SELEPAS PEMERIKSAAN KESIHATAN FOMEMA")
            end
        else
            if !@agency.nil?
                 mail(to: @employer.email, cc:@agency.email, subject: "NOTIS PENGHANTARAN PULANG KE NEGARA ASAL UNTUK PEKERJA ASING DIDAPATI TIDAK SESUAI SELEPAS PEMERIKSAAN KESIHATAN FOMEMA")
            else
                mail(to: @employer.email, subject: "NOTIS PENGHANTARAN PULANG KE NEGARA ASAL UNTUK PEKERJA ASING DIDAPATI TIDAK SESUAI SELEPAS PEMERIKSAAN KESIHATAN FOMEMA")
            end
         end
    end

    def send_unsuitable_appeal_reminder(transaction_id)
        @transaction        = Transaction.find(transaction_id)
        @employer           = @transaction.employer
        @agency              = @transaction.agency
        employer_address    = [@employer.name, @employer.address1, @employer.address2, @employer.address3, @employer.address4, "#{ @employer.postcode } #{ @employer&.town&.name }", @employer&.state&.name].select(&:present?)
        reasons             = @transaction.unsuitable_reasons.order(:priority)

        @data = {
            slip_date:          Time.now.strftime("%d/%m/%Y"),
            worker_code:        @transaction.fw_code,
            worker_name:        @transaction.fw_name,
            worker_gender:      @transaction.fw_gender == "F" ? "PEREMPUAN" : "LELAKI",
            worker_gender_bi:   @transaction.fw_gender == "F" ? "FEMALE" : "MALE",
            worker_passport:    @transaction.fw_passport_number,
            worker_country:     @transaction.fw_country&.name,
            employer_address:   employer_address,
            failed_reasons_bm:  reasons.map {|x| x[:reason_bm]},
            failed_reasons_bi:  reasons.map {|x| x[:reason_en]}
        }

        attachments.inline["fomema-logo.png"]  = File.read(Rails.root.join("app/assets/images/logo/", "fomema-logo.png"))

        if !@agency.nil?
            mail(to: @employer.email, cc:@agency.email, subject: "PERMOHONAN RAYUAN UNTUK PEKERJA ASING DIDAPATI TIDAK SESUAI SELEPAS PEMERIKSAAN KESIHATAN FOMEMA")
        else
            mail(to: @employer.email, subject: "PERMOHONAN RAYUAN UNTUK PEKERJA ASING DIDAPATI TIDAK SESUAI SELEPAS PEMERIKSAAN KESIHATAN FOMEMA")
        end
    end

    def send_unsuitable_letter(transaction_id)
        @transaction        = Transaction.find(transaction_id)
        @employer           = @transaction.employer
        @employer           = @transaction.employer
        @agency              = @transaction.agency
        employer_address    = [@employer.name, @employer.address1, @employer.address2, @employer.address3, @employer.address4, "#{ @employer.postcode } #{ @employer&.town&.name }", @employer&.state&.name].select(&:present?)
        reasons             = @transaction.unsuitable_reasons.order(:priority)

        @data = {
            slip_date:          Time.now.strftime("%d/%m/%Y"),
            worker_code:        @transaction.fw_code,
            worker_name:        @transaction.fw_name,
            worker_gender:      @transaction.fw_gender == "F" ? "PEREMPUAN" : "LELAKI",
            worker_passport:    @transaction.fw_passport_number,
            worker_country:     @transaction.fw_country&.name,
            employer_address:   employer_address,
            failed_reasons_bm:  reasons.map {|x| x[:reason_bm]},
            failed_reasons_bi:  reasons.map {|x| x[:reason_en]}
        }

        attachments.inline["fomema-logo.png"]  = File.read(Rails.root.join("app/assets/images/logo/", "fomema-logo.png"))

        if Rails.env.production? || Rails.env.production1? || Rails.env.production2? || Rails.env.production3?
            if !@agency.nil?
                mail(to: @employer.email, cc:@agency.email, bcc: "pbo@imi.gov.my", subject: "NOTIS PENGHANTARAN PULANG KE NEGARA ASAL UNTUK PEKERJA ASING DIDAPATI TIDAK SESUAI SELEPAS PEMERIKSAAN KESIHATAN FOMEMA")
            else
                mail(to: @employer.email, bcc: "pbo@imi.gov.my", subject: "NOTIS PENGHANTARAN PULANG KE NEGARA ASAL UNTUK PEKERJA ASING DIDAPATI TIDAK SESUAI SELEPAS PEMERIKSAAN KESIHATAN FOMEMA")
            end
        else
            if !@agency.nil?
                 mail(to: @employer.email, cc:@agency.email, subject: "NOTIS PENGHANTARAN PULANG KE NEGARA ASAL UNTUK PEKERJA ASING DIDAPATI TIDAK SESUAI SELEPAS PEMERIKSAAN KESIHATAN FOMEMA")
            else
                mail(to: @employer.email, subject: "NOTIS PENGHANTARAN PULANG KE NEGARA ASAL UNTUK PEKERJA ASING DIDAPATI TIDAK SESUAI SELEPAS PEMERIKSAAN KESIHATAN FOMEMA")
            end
         end
    end

    def transaction_amend_email
        @transaction = params[:transaction]
        @employer = params[:employer]
        @agency = params[:agency]
        @do_refund = params[:do_refund]
        @service_fee = params[:service_fee]
        approval_request = @transaction.approval_items
        .joins('join approval_requests on approval_items.request_id = approval_requests.id')
        .select('approval_requests.category, approval_requests.approval_decision')
        .first
        @approval_comment = @transaction.approval_items
        .joins('join approval_comments on approval_items.id = approval_comments.request_id')
        .select('approval_comments.content')
        .order("approval_comments.created_at desc")
        .pluck('approval_comments.content').first

        @category = approval_request&.category
        @approval_status = approval_request&.approval_decision
        @customer = !@agency.nil? ? @agency : @employer

        if !@agency.nil?
            mail(to: [@agency.email, @agency.user&.email, @agency.user&.unconfirmed_email].find { |email| !email.blank? }, cc: @employer.user&.email, subject: "#{@category.gsub("_", " ").titleize}")
        else
            if @transaction.foreign_worker.employer_supplement.blank?
                mail(to: [@employer.email, @employer.user&.email, @employer.user&.unconfirmed_email].find { |email| !email.blank? }, subject: "#{@category.gsub("_", " ").titleize}")
            else
                employer_supplement_user = User.find_by(employer_supplement_id: @transaction.foreign_worker.employer_supplement_id)
                mail(to: [@transaction.foreign_worker.employer_supplement.email, employer_supplement_user.email, employer_supplement_user.unconfirmed_email].find { |email| !email.blank? }, subject: "#{@category.gsub("_", " ").titleize}")
            end
        end
    end

    def agency_document_rejected_email
        @reason = params[:reason]
        @employer = params[:employer]
        @agency = params[:agency]
        @fw = params[:fw]
        mail(to: params[:recipient], subject: "Foreign Worker's documents rejected")
    end

    def agency_document_incomplete_email
        @url = params[:url]
        @reason = params[:reason]
        @employer = params[:employer]
        @agency = params[:agency]
        @fw = params[:fw]
        mail(to: params[:recipient], subject: "Foreign Worker's documents incomplete")
    end

    def amended_notifiable_transaction_email
        @transaction = params[:transaction]
        @doctor_email = params[:email]
        @doctor_name = params[:doctor_name]
        @clinic_name = params[:clinic_name]

        mail(to: @doctor_email, subject: "PLEASE NOTIFY THIS CASE (NOTIFIABLE DISEASE) TO THE NEAREST DISTRICT HEALTH OFFICE")
    end

    def amended_notifiable_transaction_tuberculosis_email
        @transaction = params[:transaction]
        @doctor_email = params[:email]
        @doctor_name = params[:doctor_name]
        @clinic_name = params[:clinic_name]
        @doctor_address = params[:doctor_address]
        @exam_date = params[:exam_date]
        @xray_taken_date = params[:xray_taken_date]
        @certification_date = params[:certification_date]
        @fw_name = params[:fw_name]
        @fw_code = params[:fw_code]
        @fw_passport_number = params[:fw_passport_number]
        @xray_pending_decision_comment = params[:xray_pending_decision_comment]
        @doctor_info = params[:doctor_info]
        @notifiable_type = params[:notifiable_type]
        @xray_result = params[:xray_result]

        mail(to: @doctor_email, subject: "NOTIFYING DISTRICT HEALTH OFFICE OF MISREAD TUBERCULOSIS CASES")
    end

    def bypass_fingerprint_approval_email
        @decision = params[:decision]
        @decision_bm = params[:decision_bm]
        @approval_comment = params[:approval_comment]
        @transaction = params[:transaction]
        @transaction_verify_doc = params[:transaction_verify_doc]
        recipient = User.find_by(id: @transaction_verify_doc.submitted_by)

        mail(to: recipient.email, subject: "#{@transaction.foreign_worker.code} Bypass fingerprint request #{@decision}")
    end
end