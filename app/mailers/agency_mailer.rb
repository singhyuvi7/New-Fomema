# bundle exec sidekiq -q default -q mailers

class AgencyMailer < ApplicationMailer
    def sign_up_email
        @token = params[:token]
        @url = params[:url]
        mail(to: params[:recipient], subject: "FOMEMA Agency sign up confirmation")
    end

    def resend_sign_up_email
        @token = params[:token]
        @url = params[:url]
        mail(to: params[:recipient], subject: "Resend - FOMEMA Agency sign up confirmation")
    end

    def pending_approval_email
        @agency = params[:agency]
        @agency_register_approval_reply_days = params[:agency_register_approval_reply_days]
        mail(to: params[:recipient], subject: "FOMEMA Agency registration pending for approval")
    end

    def approved_email
        @activation_link = params[:activation_link]
        @agency = params[:agency]
        @name = params[:name]
        attachments['Agreement.pdf'] = File.read('public/files/Agency_Agreement.pdf') 
        mail(to: params[:recipient], subject: "FOMEMA Agency registration approved")
    end

    def rejected_email
        @agency = params[:agency]
        @url = params[:url]
        @reason = params[:reason]
        @name = params[:name]
        mail(to: params[:recipient], subject: "FOMEMA Agency registration rejected")
    end

    def incomplete_email
        @agency = params[:agency]
        @url = params[:url]
        @reason = params[:reason]
        @name = params[:name]
        mail(to: params[:recipient], subject: "FOMEMA Agency registration incomplete")
    end

    def reset_email # Not being used anymore
        @activation_link = params[:activation_link]
        @agency = params[:agency]
        @name = params[:name]
        mail(to: params[:recipient], subject: "FOMEMA Agency reset email approved")
    end

    def renewal_reminder_email
        @agency = params[:agency]
        @renewal_order_link = params[:renewal_order_link]
        @renewal_fee = params[:renewal_fee]
        attachments['Agreement.pdf'] = File.read('public/files/Agency_Agreement.pdf')
        mail(to: @agency.email, subject: "Annual Payment Renewal Reminder")
    end

    def license_expiry_reminder_email
        @agency = params[:agency]
        mail(to: @agency.email, subject: "Licence Expiry Reminder")
    end

    def agency_certificate_email
        @agency = params[:agency]
        agency_address = [@agency.address1, @agency.address2, @agency.address3, @agency.address4, "#{ @agency.postcode } #{ @agency&.town&.name }", @agency&.state&.name].select(&:present?)
     
        @data = {
            agency_address: agency_address,
            expired_at:@agency.expired_at.strftime("%d/%m/%Y"),
        }

        body_html = render_to_string( partial: "/pdf_templates/agency_certificate.html.erb" )

        pdf = WickedPdf.new.pdf_from_string(
            body_html,
            margin: {
                top: "1.5cm",
                left: "1.5cm",
                right: "1.5cm",
                bottom: "1.5cm"
            },
            page_size: nil,
            page_height: "29.7cm",
            page_width: "21cm",
            dpi: "300",
            #footer: {font_size: 8, right: "Page " "[page] of [topage]" }
        )

        attachments["e-certificate.pdf"] = pdf
        mail(to: @agency.email, subject: "Certificate of Appointment as FOMEMA Registered Agency")
    end
end