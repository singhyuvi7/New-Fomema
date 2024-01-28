module XqccLetterIdenticals
    def xqcc_identical_letter_index
        @headers    = [:transaction_code, :letter_xray_and_employer_ref_number, :retake_period, :reply_period, :approver_name_and_designation, :xray_code_and_name, :doctor_code, :employer_code, :letter_date, :created_by_user]

        @letters    = XqccLetterIdentical.search_by_xray_code(params[:xray_code])
                        .search_by_xray_name(params[:xray_name])
                        .search_by_transaction_code(params[:trans_code])
                        .search_by_worker_code(params[:worker_code])
                        .order(id: :desc).page(params[:page]).per(get_per)

        @previews   = {
            "Xray"      => xqcc_identical_letter_internal_xqcc_letter_path(":id_placeholder", type: "xray"),
            "Employer"  => xqcc_identical_letter_internal_xqcc_letter_path(":id_placeholder", type: "employer")
        }

        default_preview_page
    end

    def xqcc_identical_letter_new
        @letter = XqccLetterIdentical.new
    end

    def xqcc_identical_letter_edit
        @letter = XqccLetterIdentical.find_by(id: params[:id])
        render action_name.gsub("_edit", "_new")
    end

    def xqcc_identical_letter_save
        @letter = XqccLetterIdentical.find_by(id: params[:xqcc_letter_identical][:id]) if params[:xqcc_letter_identical][:id].present?
        @letter ||= XqccLetterIdentical.new
        @letter.assign_attributes(xqcc_letter_identical_params)
        @foreign_workers    = []
        foreign_workers     = params[:foreign_workers] || {}

        # Removing deleted workers.
        ids = foreign_workers.values.map {|hash| hash[:id] }
        @letter.identical_workers.where.not(id: ids).destroy_all

        foreign_workers.keys.each do |key|
            hash            = foreign_workers[key]
            fw_params       = hash.to_unsafe_h
            fw_identical    = XqccLetterIdenticalWorker.find_by(id: fw_params[:id]) if fw_params[:id].present?
            fw_identical    ||= XqccLetterIdenticalWorker.new
            fw_identical.assign_attributes(fw_params.except(:id))
            @foreign_workers << fw_identical
        end

        case params[:commit]
        when "Preview Xray Letter", "Preview Employer Letter"
            params[:type]       = params[:commit].include?("Xray") ? "xray" : "employer"
            @letter.created_at  = Time.now
            @letter.valid? # Need to do this to make sure before_validation runs.
            preview_xqcc_identical_letter
        else
            if @letter.save
                @foreign_workers.each {|worker| worker.update(xqcc_letter_identical_id: @letter.id) }
                notice = { notice: "Letter Saved" }
            else
                notice = { error: "Something went wrong. Debug code: WTLS" }
            end

            redirect_to xqcc_identical_letter_index_internal_xqcc_letters_path, notice
        end
    end

    def xqcc_identical_letter_search
        transaction = Transaction.find_by(code: params[:transaction_code])

        results     = {
            xray_code:          transaction&.xray_facility&.code,
            xray_name:          transaction&.xray_facility&.name,
            doctor_code:        transaction&.doctor&.code,
            employer_code:      transaction&.employer&.code,
            xray_address:       transaction&.xray_facility&.xqcc_letter_xray_address,
            doctor_address:     transaction&.doctor&.xqcc_letter_doctor_address,
            employer_address:   transaction&.employer&.xqcc_letter_employer_address
        }.transform_keys {|key| "xqcc_letter_identical_#{ key }" }

        render json: results, status: :ok
    end

    def xqcc_identical_foreign_worker_search
        transaction = Transaction.find_by(code: params[:transaction_code])

        results     = if transaction.blank?
            { no_results: true }
        else
            {
                worker_code:        transaction.fw_code,
                worker_name:        transaction.fw_name,
                worker_passport:    transaction.fw_passport_number,
                xray_date:          transaction.xray_examination&.xray_taken_date&.strftime("%d/%m/%Y"),
                audit_date:         nil,
                employer_name:      transaction&.employer&.name
            }.transform_keys {|key| "foreign_workers_placeholder_0_#{ key }" }
        end

        render json: results, status: :ok
    end

    def xqcc_identical_letter
        @letter = XqccLetterIdentical.find_by(id: params[:id])
        redirect_to xqcc_identical_letter_index_internal_xqcc_letters_path, error: "Could not find the letter by ID: #{ params[:id] }" and return unless @letter
        preview_xqcc_identical_letter
    end
private
    def xqcc_letter_identical_params
        params.require(:xqcc_letter_identical).permit(:transaction_code, :retake_period, :reply_period, :xray_ref_no, :employer_ref_no, :issuer_name, :issuer_title, :xray_code, :xray_name, :doctor_code, :employer_code, :xray_address, :doctor_address, :employer_address)
    end

    def preview_xqcc_identical_letter
        date        = @letter.letter_date.to_date
        ordinalize  = date.day.ordinalize.insert(-3, '<sup>').insert(-1, '</sup>')
        letter_date = date.strftime("#{ ordinalize } %B %Y")

        @data = {
            ref_number:     @letter.try("#{ params[:type] }_ref_no"),
            letter_date:    letter_date,
            letter_title:   params[:type] == "xray" ? "IDENTICAL CHEST X-RAY FROM THE X-RAY FACILITY" : "REPEAT CHEST X-RAY DUE TO IDENTICAL CHEST X-RAY"
        }

        @foreign_workers ||= @letter.identical_workers

        render pdf: "xqcc_identical_letter_#{ params[:type] }",
        template: "/internal/xqcc_letters/xqcc_identical_letter_#{ params[:type] }.html.erb",
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