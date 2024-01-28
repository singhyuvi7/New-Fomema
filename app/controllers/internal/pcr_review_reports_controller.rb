class Internal::PcrReviewReportsController < InternalController
    def show
        # employer            = @transaction.employer
        # employer_address    = [employer.name, employer.address1, employer.address2, employer.address3, employer.address4, "#{ employer.postcode } #{ employer&.town&.name }", employer&.state&.name].select(&:present?)
        # doctor              = @transaction.doctor
        # tcupi_letter_object = @transaction.tcupi_letters.find_by(letter_type: "audit")
        # # tcupi_letter_object = nil if tcupi_letter_object.blank? && @transaction.tcupi_date?
        # letter_id           = tcupi_letter_object&.letter_id || 0

        @pcr_review = PcrReview.find(params[:id])

        if @pcr_review.medical_appeal_id?
            appeal      = @pcr_review.medical_appeal
            transaction = appeal.transactionz
            type        = "Appeal"
            source      = @pcr_review.poolable&.xray_retake
        else
            transaction = @pcr_review.transactionz
            type        = "Normal"
            source      = @pcr_review.transactionz
        end

        xray_examination    = source.xray_examination
        reporter            = source&.xray_facility
        inhouse             = @pcr_review.pcr_user

        @data = {
            worker_name:            transaction.fw_name,
            worker_code:            transaction.fw_code,
            country:                transaction.fw_country&.name,
            transaction_code:       source&.code,
            passport:               transaction.fw_passport_number,
            xray_report_date:       xray_examination&.xray_taken_date&.strftime("%d-%m-%Y"),
            xray_taken_date:        xray_examination&.transmitted_at&.strftime("%d-%m-%Y"),
            xray_audit_date:        @pcr_review&.transmitted_at&.strftime("%d-%m-%Y"),
            inhouse_radiologist:    inhouse&.code,
            xray_ref_number:        xray_examination&.xray_ref_number,
            reported_by:            "#{ reporter&.code }-#{ reporter&.name }",
            type:                   type
        }

        render pdf: "pcr_review_report",
        template: "/pdf_templates/pcr_review_report.html.erb",
        layout: "pdf.html",
        show_as_html: params[:debug].present?,
        margin: {
            top: "1.5cm",
            left: "2cm",
            right: "2cm",
            bottom: "2cm",
        },
        page_size: nil,
        page_width: "21cm",
        page_height: "29.7cm",
        dpi: "300",
        footer: {font_size: 8, right: "Page " "[page] of [topage]" }
    end
end