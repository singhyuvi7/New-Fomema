module XqccLetterAuditResults
    def xqcc_audit_result_letter_index
        @headers    = [:transaction_code, :letter_xray_and_employer_ref_number, :amended_status, :xray_code_and_name, :worker_code_name_and_passport, :doctor_code, :employer_code, :letter_date, :created_by_user]

        @letters    = XqccLetterAuditResult.search_by_xray_code(params[:xray_code])
                        .search_by_xray_name(params[:xray_name])
                        .search_by_transaction_code(params[:trans_code])
                        .search_by_worker_code(params[:worker_code])
                        .order(id: :desc).page(params[:page]).per(get_per)

        @previews   = {
            "Xray"      => xqcc_audit_result_letter_internal_xqcc_letter_path(":id_placeholder", type: "xray"),
            "Employer"  => xqcc_audit_result_letter_internal_xqcc_letter_path(":id_placeholder", type: "employer")
        }

        default_preview_page
    end

    def xqcc_audit_result_letter_new
        @letter = XqccLetterAuditResult.new
    end

    def xqcc_audit_result_letter_edit
        @letter = XqccLetterAuditResult.find_by(id: params[:id])
        render action_name.gsub("_edit", "_new")
    end

    def xqcc_audit_result_letter_save
        @letter = XqccLetterAuditResult.find_by(id: params[:xqcc_letter_audit_result][:id]) if params[:xqcc_letter_audit_result][:id].present?
        @letter ||= XqccLetterAuditResult.new
        @letter.assign_attributes(xqcc_letter_audit_result_params)

        case params[:commit]
        when "Preview Xray Letter", "Preview Employer Letter"
            params[:type]       = params[:commit].include?("Xray") ? "xray" : "employer"
            @letter.created_at  = Time.now
            preview_xqcc_audit_result_letter
        else
            notice = @letter.save ? { notice: "Letter Saved" } : { error: "Something went wrong. Debug code: WTLS" }
            redirect_to xqcc_audit_result_letter_index_internal_xqcc_letters_path, notice
        end
    end

    def xqcc_audit_result_letter_search
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
            employer_address:   transaction&.employer&.xqcc_letter_employer_address
        }.transform_keys {|key| "xqcc_letter_audit_result_#{ key }" }

        render json: results, status: :ok
    end

    def xqcc_audit_result_letter
        @letter = XqccLetterAuditResult.find_by(id: params[:id])
        redirect_to xqcc_audit_result_letter_index_internal_xqcc_letters_path, error: "Could not find the letter by ID: #{ params[:id] }" and return unless @letter
        preview_xqcc_audit_result_letter
    end
private
    def xqcc_letter_audit_result_params
        params.require(:xqcc_letter_audit_result).permit(:transaction_code, :amended_status, :xray_ref_no, :employer_ref_no, :xray_code, :xray_name, :doctor_code, :employer_code, :worker_code, :worker_name, :worker_passport, :xray_address, :doctor_address, :employer_address)
    end

    def preview_xqcc_audit_result_letter
        date        = @letter.letter_date.to_date
        ordinalize  = date.day.ordinalize.insert(-3, '<sup>').insert(-1, '</sup>')
        letter_date = date.strftime("#{ ordinalize } %B %Y")

        @data = {
            ref_number:     @letter.try("#{ params[:type] }_ref_no"),
            letter_date:    letter_date,
            letter_title:   "Medical status of foreign worker"
        }

        render pdf: "xqcc_audit_result_letter_#{ params[:type] }",
        template: "/internal/xqcc_letters/xqcc_audit_result_letter_#{ params[:type] }.html.erb",
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
        footer: { font_size: 8, spacing: 3, right: "Page " "[page] of [topage]", center: "***This letter is computer generated and no signature is required.***" },
        header: {
            html: {
                template: '/internal/xqcc_letters/xqcc_letter_headers',
                locals: @data
            },
            spacing: 3 # Adds a little space below the header.
        }
    end
end