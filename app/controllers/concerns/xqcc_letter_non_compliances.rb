module XqccLetterNonCompliances

    NON_COMPLIANCE_ISSUE = {
        "INCOMPLETE_IDENTIFICATION" => "Incomplete identification",
        "WRONG_IDENTIFICATION" => "Wrong identification",
        "REGION_OF_INTEREST_CUT_OFF" => "Region of interest cuf off",
        "REGION_OF_INTEREST_NOT_CLEARLY_VISUALIZED" => "Region of interes not clearly visualized",
        "COLLIMATION" => "Collimation (poor/ no)",
        "SCAPULA_NOT_RETRACTED" => "Scapula not retracted",
        "POOR_INSPIRATORY_EFFORT" => "Poor inspiratory effort",
        "OVEREXPOSED" => "Overexposed",
        "UNDEREXPOSED" => "Underexposed",
        "PROCESSING_ARTIFACTS" => "Processing artifacts",
        "POOR_HANDLING_ARTIFACTS" => "Poor handling artifacts",
        "SUPERIMPOSED" => "Superimposed",
        "PRIMARY_ANATOMICAL_MARKER_WRONG_PLACEMENT" => "Primary anatomical marker (wrong placement)",
        "PRIMARY_ANATOMICAL_MARKER_NOT_AVAILABLE" => "Primary anatomical marker (not available)",
        "MOVEMENT" => "Movement",
        "BREATHING" => "Breathing"
    }

    def xqcc_non_compliance_letter_index
        @headers    = [:xray_ref_no, :approver_name_and_designation, :xray_code_and_name, :letter_date, :created_by_user]

        @letters    = XqccLetterNonCompliance.search_by_xray_code(params[:xray_code])
                        .search_by_xray_name(params[:xray_name])
                        .order(id: :desc).page(params[:page]).per(get_per)

        @previews   = { "Letter" => xqcc_non_compliance_letter_internal_xqcc_letter_path(":id_placeholder") }
        default_preview_page
    end

    def xqcc_non_compliance_letter_new
        @letter = XqccLetterNonCompliance.new
    end

    def xqcc_non_compliance_letter_edit
        @letter = XqccLetterNonCompliance.find_by(id: params[:id])
        render action_name.gsub("_edit", "_new")
    end

    def xqcc_non_compliance_letter_save
        @letter = XqccLetterNonCompliance.find_by(id: params[:xqcc_letter_non_compliance][:id]) if params[:xqcc_letter_non_compliance][:id].present?
        @letter ||= XqccLetterNonCompliance.new
        @letter.assign_attributes(xqcc_letter_non_compliance_params)
        @images = []
        @items  = []
        images  = params[:total_images] || {}
        items   = params[:total_items] || {}

        # Removing deleted images & items.
        ids = images.values.map {|hash| hash[:id] }
        @letter.total_image_rows.where.not(id: ids).destroy_all
        ids = items.values.map {|hash| hash[:id] }
        @letter.total_item_rows.where.not(id: ids).destroy_all

        images.keys.each do |key|
            hash            = images[key]
            img_params      = hash.to_unsafe_h
            non_comply_img  = NonComplianceTotalImage.find_by(id: img_params[:id]) if img_params[:id].present?
            non_comply_img  ||= NonComplianceTotalImage.new
            non_comply_img.assign_attributes(img_params.except(:id))
            @images << non_comply_img
        end

        items.keys.each do |key|
            hash            = items[key]
            item_params     = hash.to_unsafe_h
            non_comply_item = NonComplianceItem.find_by(id: item_params[:id]) if item_params[:id].present?
            non_comply_item ||= NonComplianceItem.new
            non_comply_item.assign_attributes(item_params.except(:id))
            @items << non_comply_item
        end

        case params[:commit]
        when "Preview Letter"
            @letter.created_at  = Time.now
            preview_xqcc_non_compliance_letter
        else
            if @letter.save
                @images.each {|image| image.update(xqcc_letter_non_compliance_id: @letter.id) }
                @items.each {|item| item.update(xqcc_letter_non_compliance_id: @letter.id) }
                notice = { notice: "Letter Saved" }
            else
                notice = { error: "Something went wrong. Debug code: WTLS" }
            end

            redirect_to xqcc_non_compliance_letter_index_internal_xqcc_letters_path, notice
        end
    end

    def xqcc_non_compliance_letter_search
        xray_facility = XrayFacility.find_by(code: params[:xray_code])

        results = {
            xray_address:   xray_facility&.xqcc_letter_xray_address,
            xray_name:      xray_facility&.name
        }.transform_keys {|key| "xqcc_letter_non_compliance_#{ key }" }

        render json: results, status: :ok
    end

    def xqcc_non_compliance_letter
        @letter = XqccLetterNonCompliance.find_by(id: params[:id])
        redirect_to xqcc_non_compliance_letter_index_internal_xqcc_letters_path, error: "Could not find the letter by ID: #{ params[:id] }" and return unless @letter
        preview_xqcc_non_compliance_letter
    end
private
    def xqcc_letter_non_compliance_params
        params.require(:xqcc_letter_non_compliance).permit(:xray_ref_no, :issuer_name, :issuer_title, :xray_code, :xray_name, :xray_address, :follow_up_with, :follow_up_date)
    end

    def preview_xqcc_non_compliance_letter
        date        = @letter.letter_date.to_date
        ordinalize  = date.day.ordinalize.insert(-3, '<sup>').insert(-1, '</sup>')
        letter_date = date.strftime("#{ ordinalize } %B %Y")

        @data = {
            ref_number:     @letter.try("xray_ref_no"),
            letter_date:    letter_date,
            letter_title:   "Non-compliance towards chest X-ray quality"
        }

        @images ||= @letter.total_image_rows
        @items  ||= @letter.total_item_rows

        render pdf: "xqcc_non_compliance_letter",
        template: "/internal/xqcc_letters/xqcc_non_compliance_letter.html.erb",
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