module XrayWebServiceHelper
    def checking_digital_xray_available(xray_exam_id)
        return false if on_development? # Salinee Integration does not work until they whitelist the IP.
        xray_exam   = XrayExamination.find_by(id: xray_exam_id)
        return false if xray_exam.blank?
        source      = xray_exam.sourceable
        code        = xray_exam.xray_ref_number.present? ? xray_exam.xray_ref_number : source&.code
        xray_ws     = XrayWebService.new(source: source, exam: xray_exam, code: code, user_id: current_user.id, params: params.to_unsafe_h.merge(url: request.url))
        xray_ws.is_digital_xray_available
    end
end