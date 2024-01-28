module XqccLetterFraudCases
    def xqcc_fraud_case_letter_index
        @headers    = [:transaction_code, :letter_xray_and_employer_ref_number, :xray_code_and_name, :worker_code_name_and_passport, :doctor_code, :employer_code, :letter_date, :created_by_user]

        @letters    = XqccLetterFraudCase.search_by_xray_code(params[:xray_code])
                        .search_by_xray_name(params[:xray_name])
                        .search_by_transaction_code(params[:trans_code])
                        .search_by_worker_code(params[:worker_code])
                        .order(id: :desc).page(params[:page]).per(get_per)

        @previews   = {
            "Xray"      => xqcc_fraud_case_letter_internal_xqcc_letter_path(":id_placeholder", type: "xray"),
            "Employer"  => xqcc_fraud_case_letter_internal_xqcc_letter_path(":id_placeholder", type: "employer")
        }

        default_preview_page
    end

    def xqcc_fraud_case_letter_new
        @letter = XqccLetterFraudCase.new
    end

    def xqcc_fraud_case_letter_edit
        @letter = XqccLetterFraudCase.find_by(id: params[:id])
        render action_name.gsub("_edit", "_new")
    end

    def xqcc_fraud_case_letter_save
        @letter = XqccLetterFraudCase.find_by(id: params[:xqcc_letter_fraud_case][:id]) if params[:xqcc_letter_fraud_case][:id].present?
        @letter ||= XqccLetterFraudCase.new
        @letter.assign_attributes(xqcc_fraud_case_letter_params)

        case params[:commit]
        when "Preview Xray Letter", "Preview Employer Letter"
            params[:type]       = params[:commit].include?("Xray") ? "xray" : "employer"
            @letter.created_at  = Time.now
            preview_xqcc_fraud_case_letter
        else
            notice = @letter.save ? { notice: "Letter Saved" } : { error: "Something went wrong. Debug code: WTLS" }
            redirect_to xqcc_fraud_case_letter_index_internal_xqcc_letters_path, notice
        end
    end

    def xqcc_fraud_case_letter_search
        transaction = Transaction.find_by(code: params[:transaction_code])

        results     = {
            xray_code:          transaction&.xray_facility&.code,
            xray_name:          transaction&.xray_facility&.name,
            doctor_code:        transaction&.doctor&.code,
            employer_code:      transaction&.employer&.code,
            worker_code:        transaction&.fw_code,
            worker_name:        transaction&.fw_name,
            worker_passport:    transaction&.fw_passport_number,
            xray_address:       transaction&.xray_facility&.xqcc_letter_xray_address,
            doctor_address:     transaction&.doctor&.xqcc_letter_doctor_address,
            employer_address:   transaction&.employer&.xqcc_letter_employer_address,
            xray_date:          transaction&.xray_examination&.xray_taken_date&.strftime("%d/%m/%Y"),
            audit_date:         transaction&.pcr_review&.transmitted_at&.strftime("%d/%m/%Y"),
            employer_name:      transaction&.employer&.name

        }.transform_keys {|key| "xqcc_letter_fraud_case_#{ key }" }

        render json: results, status: :ok
    end

    def xqcc_fraud_case_letter
        @letter = XqccLetterFraudCase.find_by(id: params[:id])
        redirect_to xqcc_fraud_case_letter_index_internal_xqcc_letters_path, error: "Could not find the letter by ID: #{ params[:id] }" and return unless @letter
        preview_xqcc_fraud_case_letter
    end
private
    def xqcc_fraud_case_letter_params
        params.require(:xqcc_letter_fraud_case).permit(:transaction_code, :xray_ref_no, :employer_ref_no, :xray_code, :xray_name, :doctor_code, :employer_code, :worker_code, :worker_name, :worker_passport, :xray_address, :doctor_address, :employer_address, :xray_date, :audit_date, :employer_name,:issuer_name, :issuer_title)
    end

    def preview_xqcc_fraud_case_letter
        date        = @letter.letter_date.to_date
        ordinalize  = date.day.ordinalize.insert(-3, '<sup>').insert(-1, '</sup>')
        letter_date = date.strftime("#{ ordinalize } %B %Y")

        @data = {
            ref_number:     @letter.try("#{ params[:type] }_ref_no"),
            letter_date:    letter_date,
            letter_title:   params[:type] == "xray" ? "Improper verification of foreign worker's identity" : "Amendment to the medical status of the foreign worker"
        }

        render pdf: "xqcc_fraud_case_letter_#{ params[:type] }",
        template: "/internal/xqcc_letters/xqcc_fraud_case_letter_#{ params[:type] }.html.erb",
        layout: "pdf.html",
        show_as_html: params[:debug].present?,
        margin: {
            top: "3.5cm",
            left: "2cm",
            right: "2cm",
            bottom: "2cm",
        },
        page_size: nil,
        page_height: "29.7cm",
        page_width: "21cm",
        dpi: "300",
        footer: { font_size: 8, spacing: 3, right: "Page " "[page] of [topage]", center: "" },
        header: {
            html: {
                template: '/internal/xqcc_letters/xqcc_letter_headers',
                locals: @data
            },
            spacing: 3 # Adds a little space below the header.
        }
    end
end