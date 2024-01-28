# bundle exec sidekiq -q default -q mailers

class XrayMailer < ApplicationMailer
    def arl_email
        @xray_code = params[:xray_code]
        @xray_email = params[:xray_email]
        @current_year = params[:current_year]
        @xray_clinic_name = params[:xray_clinic_name]
        @xray_doctor_name = params[:xray_doctor_name]
        @no_req = params[:no_req]
        mail(to: params[:recipient], subject: "(Ref:#{@no_req}) REQUEST FOR AUDIT RADIOGRAPH LETTER")
    end

    def xray_license_expiry_reminder_email
        email               = params[:email]
        csv                 = params[:csv]
        attachments["Xray License Expired List.csv"] = { mime_type: 'text/csv', content: csv }
        mail(to: email, subject: 'LIST OF XRAY FACILITY EXPIRED LICENSE')
    end

    def xray_license_expiry_rejected_email
        @xray_facility = params[:xray_facility]
        @comment = params[:comment]
        mail(to: @xray_facility.email, subject: 'Non-Compliance Uploaded Documents')
    end

    def new_facility_registered_email
        @xray_facility = params[:xray_facility]
        mail(to: SystemConfiguration.get('FIOT_EMAIL') , subject: 'New X-ray Facility Registered')
    end
end