module XqccLetterAuditRadiographers
    def xqcc_audit_radiograph_letter_index
        @headers    = [:xray_ref_no, :approver_name_and_designation, :xray_code_and_name, :panel_year, :letter_date, :created_by_user]

        @letters    = XqccLetterAuditRadiographer.search_by_xray_code(params[:xray_code])
                        .search_by_xray_name(params[:xray_name])
                        .order(id: :desc).page(params[:page]).per(get_per)

        @previews   = { "Letter" => xqcc_audit_radiograph_letter_internal_xqcc_letter_path(":id_placeholder") }
        default_preview_page
    end

    def xqcc_audit_radiograph_letter_new
        @letter = XqccLetterAuditRadiographer.new
    end

    def xqcc_audit_radiograph_letter_edit
        @letter = XqccLetterAuditRadiographer.find_by(id: params[:id])
        render action_name.gsub("_edit", "_new")
    end

    def xqcc_audit_radiograph_letter_save
        @letter = XqccLetterAuditRadiographer.find_by(id: params[:xqcc_letter_audit_radiographer][:id]) if params[:xqcc_letter_audit_radiographer][:id].present?
        @letter ||= XqccLetterAuditRadiographer.new
        @letter.assign_attributes(xqcc_letter_audit_radiographer_params)

        case params[:commit]
        when "Preview Letter"
            @letter.created_at  = Time.now
            preview_xqcc_audit_radiograph_letter
        else
            notice = @letter.save ? { notice: "Letter Saved" } : { error: "Something went wrong. Debug code: WTLS" }
            redirect_to xqcc_audit_radiograph_letter_index_internal_xqcc_letters_path, notice
        end
    end

    def xqcc_audit_radiograph_letter_search
        xray_facility = XrayFacility.find_by(code: params[:xray_code])

        results     = {
            xray_address:   xray_facility&.xqcc_letter_xray_address,
            xray_name:      xray_facility&.name
        }.transform_keys {|key| "xqcc_letter_audit_radiographer_#{ key }" }

        render json: results, status: :ok
    end

    def xqcc_audit_radiograph_letter
        @letter = XqccLetterAuditRadiographer.find_by(id: params[:id])
        redirect_to xqcc_audit_radiograph_letter_index_internal_xqcc_letters_path, error: "Could not find the letter by ID: #{ params[:id] }" and return unless @letter
        preview_xqcc_audit_radiograph_letter
    end
private
    def xqcc_letter_audit_radiographer_params
        params.require(:xqcc_letter_audit_radiographer).permit(:xray_ref_no, :issuer_name, :issuer_title, :panel_year, :xray_code, :xray_name, :xray_address)
    end

    def preview_xqcc_audit_radiograph_letter
        date        = @letter.letter_date.to_date
        ordinalize  = date.day.ordinalize.insert(-3, '<sup>').insert(-1, '</sup>')
        letter_date = date.strftime("#{ ordinalize } %B %Y")

        @data = {
            ref_number:     @letter.try("xray_ref_no"),
            letter_date:    letter_date,
            letter_title:   "Audit Radiograph"
        }

        render pdf: "xqcc_audit_radiograph_letter",
        template: "/internal/xqcc_letters/xqcc_audit_radiograph_letter.html.erb",
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