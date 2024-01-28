class External::ArlEmailsController < ExternalController
    #before_action :access_only_for_xray_or_radiologist
    #before_action :check_for_parameters, only: [:view]
    
    def index
    end

    def bulk_action    
        case params[:bulk_action]
        when 'senderarl'
            send_email
        end
        redirect_to external_arl_emails_url
    end

    def send_email        
        @xray_facility = current_user.userable
        number=SecureRandom.random_number(1000)
        
        XrayMailer.with({        
        recipient: 'arl@fomema.com.my',
        xray_code: @xray_facility.code,
        xray_email: @xray_facility.email,
        current_year: Date.today.year,
        xray_clinic_name: @xray_facility.name,
        xray_doctor_name: @xray_facility.license_holder_name,
        no_req: number,
        }).arl_email.deliver_later
        flash[:notice] = "Your request is successfully send and is in the process of preparation.Your request number is <b>#{number}</b> for your future reference."
    end
    
end 