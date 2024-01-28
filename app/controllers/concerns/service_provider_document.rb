module ServiceProviderDocument
    def registration_invoice
        if @doctor.present?
            @order = @doctor.orders.where(category: "DOCTOR_REGISTRATION").last
            @redirect_to = internal_doctor_path(@doctor)
        end

        if @xray_facility.present?
            @order = @xray_facility.orders.where(category: "XRAY_FACILITY_REGISTRATION").last
            @redirect_to = internal_xray_facility_path(@xray_facility)
        end

        if @laboratory.present?
            @order = @laboratory.orders.where(category: "LABORATORY_REGISTRATION").last
            @redirect_to = internal_laboratory_path(@laboratory)
        end

        if @radiologist.present?
            @order = @radiologist.orders.where(category: "RADIOLOGIST_REGISTRATION").last
            @redirect_to = internal_radiologist_path(@radiologist)
        end

        @title = "Invoice"
        # debug mode on / off

        if @order.present? 
            @debug = false

            # enable debug by passing ?debug param in url
            if params.has_key?(:debug)
                @debug = true
                # render json: @order and return
                render "pdf_templates/orders/service_provider_invoice.html.erb", layout: 'pdf'
            else
                render pdf: "service_provider_invoice",
                template: "pdf_templates/orders/service_provider_invoice.html.erb",
                layout: "pdf.html",
                margin: {
                    top: 1,
                    left: 1,
                    right: 3,
                    bottom: 0,
                },
                page_size: nil,
                page_height: "29.7cm",
                page_width: "21cm",
                dpi: "300"
            end
        else
            flash[:error] = "No Paid Registration Detected"
            redirect_to @redirect_to
        end
    end

    def pairing_letter
        laboratory = @doctor.laboratory
        xray_facility = @doctor.xray_facility

        if laboratory.present? and xray_facility.present?
            template = Sablon.template "#{Rails.root.to_s}/app/views/doc_templates/pairing_letter.docx"

            signee_name = TemplateVariable.where(:code => 'PAIRING_SIGNEE_NAME').pluck(:value).first
            signee_position_1 = TemplateVariable.where(:code => 'PAIRING_SIGNEE_POSITION_LINE_1').pluck(:value).first
            signee_position_2 = TemplateVariable.where(:code => 'PAIRING_SIGNEE_POSITION_LINE_2').pluck(:value).first

            context = {
                current_date: Time.now.strftime("%d/%m/%Y"),
                current_time: Time.now.strftime("%F %H:%M:%S"),
                metadata: { generator: "FOMEMA" },
                title: "Pairing Notification Letter",
                doctor: @doctor,
                laboratory: laboratory,
                xray_facility: xray_facility,
                signee_name: signee_name,
                signee_position_1: signee_position_1,
                signee_position_2: signee_position_2
            }

            properties = {
                start_page_number: 1
            }

            data = template.render_to_string context, properties
            send_data data, filename: "pairing-notification-letter.docx"
        else
            flash[:error] = "Unable to detect pairing"
            redirect_to internal_doctor_path(@doctor)
        end
    end

    def approval_letter
        # deprecated?
        template = Sablon.template "#{Rails.root.to_s}/app/views/doc_templates/approval_letter.docx"

        context = {
            current_date: Time.now.strftime("%F"),
            current_time: Time.now.strftime("%F %H:%M:%S"),
            metadata: { generator: "FOMEMA" },
            title: "Approval Letter",
            doctor: @doctor,
            laboratory: @laboratory,
            xray_facility: @xray_facility,
        }

        properties = {
            start_page_number: 1
        }

        data = template.render_to_string context, properties
        send_data data, filename: "approval-letter.docx"
    end

    def temporary_allocation_letter
        error = false
        service_provider = params[:service_provider]

        if service_provider === Laboratory.to_s
            template_document = "temporary_allocation_lab.docx"
            allocated_sp = @doctor.laboratory
        else
            template_document = "temporary_allocation_xray.docx"
            allocated_sp = @doctor.xray_facility
        end

        if allocated_sp.present?
            allocate = Allocate.where(:doctor_id => @doctor.id, :new_allocatable_type => service_provider).last
            isAllocate = allocate.present? ? (allocate.new_allocatable_id == allocated_sp.id ? true : false) : false

            if isAllocate
                template = Sablon.template "#{Rails.root.to_s}/app/views/doc_templates/#{template_document}"

                signee_name = TemplateVariable.where(:code => 'ALLOCATION_SIGNEE_NAME').pluck(:value).first
                signee_position_1 = TemplateVariable.where(:code => 'ALLOCATION_SIGNEE_POSITION_LINE_1').pluck(:value).first
                signee_position_2 = TemplateVariable.where(:code => 'ALLOCATION_SIGNEE_POSITION_LINE_2').pluck(:value).first

                context = {
                    current_date: Time.now.strftime("%d/%m/%Y"),
                    current_time: Time.now.strftime("%F %H:%M:%S"),
                    metadata: { generator: "FOMEMA" },
                    title: "Allocation Letter",
                    doctor: @doctor,
                    allocated_sp: allocated_sp,
                    signee_name: signee_name,
                    signee_position_1: signee_position_1,
                    signee_position_2: signee_position_2
                }

                properties = {
                    start_page_number: 1
                }

                data = template.render_to_string context, properties
                send_data data, filename: "temporary-allocation-letter.docx"
            else
                error = true
            end
        else
            error = true
        end

        if error
            flash[:error] = "No allocation detected"
            redirect_to internal_doctor_path(@doctor)
        end
    end

    def allocation_letter
        service_provider = params[:service_provider]

        if service_provider === Laboratory.to_s
            template_document = "allocation_lab.docx"
            allocated_sp = @doctor.laboratory
        else
            template_document = "allocation_xray.docx"
            allocated_sp = @doctor.xray_facility
        end

        if allocated_sp.present?
            template = Sablon.template "#{Rails.root.to_s}/app/views/doc_templates/#{template_document}"

            signee_name = TemplateVariable.where(:code => 'ALLOCATION_SIGNEE_NAME').pluck(:value).first
            signee_position_1 = TemplateVariable.where(:code => 'ALLOCATION_SIGNEE_POSITION_LINE_1').pluck(:value).first
            signee_position_2 = TemplateVariable.where(:code => 'ALLOCATION_SIGNEE_POSITION_LINE_2').pluck(:value).first
            
            context = {
                current_date: Time.now.strftime("%d/%m/%Y"),
                current_time: Time.now.strftime("%F %H:%M:%S"),
                metadata: { generator: "FOMEMA" },
                title: "Allocation Letter",
                doctor: @doctor,
                allocated_sp: allocated_sp,
                signee_name: signee_name,
                signee_position_1: signee_position_1,
                signee_position_2: signee_position_2
            }

            properties = {
                start_page_number: 1
            }

            data = template.render_to_string context, properties
            send_data data, filename: "allocation-letter.docx"
        else
            flash[:error] = "No allocation detected"
            redirect_to internal_doctor_path(@doctor)
        end
    end

    def reallocation_back_letter
        error = false
        service_provider = params[:service_provider]

        if service_provider === Laboratory.to_s
            template_document = "reallocation_back_lab.docx"
            allocated_sp = @doctor.laboratory
        else
            template_document = "reallocation_back_xray.docx"
            allocated_sp = @doctor.xray_facility
        end

        if allocated_sp.present?
            allocate = Allocate.where(:doctor_id => @doctor.id, :old_allocatable_type => service_provider, :old_allocatable_id => allocated_sp.id).first
            isAllocate = allocate.present? ? true : false

            if isAllocate
                template = Sablon.template "#{Rails.root.to_s}/app/views/doc_templates/#{template_document}"

                signee_name = TemplateVariable.where(:code => 'ALLOCATION_SIGNEE_NAME').pluck(:value).first
                signee_position_1 = TemplateVariable.where(:code => 'ALLOCATION_SIGNEE_POSITION_LINE_1').pluck(:value).first
                signee_position_2 = TemplateVariable.where(:code => 'ALLOCATION_SIGNEE_POSITION_LINE_2').pluck(:value).first

                context = {
                    current_date: Time.now.strftime("%d/%m/%Y"),
                    current_time: Time.now.strftime("%F %H:%M:%S"),
                    metadata: { generator: "FOMEMA" },
                    title: "Allocation Letter",
                    doctor: @doctor,
                    allocated_sp: allocated_sp,
                    signee_name: signee_name,
                    signee_position_1: signee_position_1,
                    signee_position_2: signee_position_2
                }

                properties = {
                    start_page_number: 1
                }

                data = template.render_to_string context, properties
                send_data data, filename: "reallocation-back-letter.docx"
            else
                error = true
            end
        else
            error = true
        end

        if error
            flash[:error] = "No allocation detected"
            redirect_to internal_doctor_path(@doctor)
        end
    end

    def change_address_approval

        service_provider = {}

        signee_name = TemplateVariable.where(:code => 'APPROVAL_SIGNEE_NAME').pluck(:value).first
        signee_position_1 = TemplateVariable.where(:code => 'APPROVAL_SIGNEE_POSITION_LINE_1').pluck(:value).first
        signee_position_2 = TemplateVariable.where(:code => 'APPROVAL_SIGNEE_POSITION_LINE_2').pluck(:value).first

        if @xray_facility.present?
            service_provider = @xray_facility
            template_document = "change_address_approval_xray.docx"
            order = service_provider.orders.where(:category => "XRAY_FACILITY_CHANGE_ADDRESS").last
            @redirect_to = internal_xray_facility_path(@xray_facility)
        end

        if @laboratory.present?
            service_provider = @laboratory
            template_document = "change_address_approval_lab.docx"
            order = service_provider.orders.where(:category => "LABORATORY_CHANGE_ADDRESS").last
            @redirect_to = internal_laboratory_path(@laboratory)
        end

        if @doctor.present?
            service_provider = @doctor
            template_document = "change_address_approval_doctor.docx"
            order = service_provider.orders.where(:category => "DOCTOR_CHANGE_ADDRESS").last
            @redirect_to = internal_doctor_path(@doctor)
        end

        if @radiologist.present?
            service_provider = @radiologist
            template_document = "change_address_approval_radiologist.docx"
            order = {}
            @redirect_to = internal_radiologist_path(@radiologist)

            signee_name = TemplateVariable.where(:code => 'APPROVAL_RADIOLOGIST_SIGNEE_NAME').pluck(:value).first
            signee_position_1 = TemplateVariable.where(:code => 'APPROVAL_RADIOLOGIST_SIGNEE_POSITION_LINE_1').pluck(:value).first
            signee_position_2 = TemplateVariable.where(:code => 'RADIOLOGIST_SIGNEE_POSITION_LINE_2').pluck(:value).first
        end

        if order.present? || @radiologist.present?
            ref_id = service_provider.id < 10000 ? (sprintf '%04d', service_provider.id) : (sprintf '%05d', service_provider.id)

            template = Sablon.template "#{Rails.root.to_s}/app/views/doc_templates/#{template_document}"

            context = {
                service_provider: service_provider,
                town: service_provider.town,
                state: service_provider.state,
                ref_date: Date.today.strftime("#{Date.today.day.ordinalize} %B %Y"),
                order_code: order.present? ? order.code : '',
                order_date: order.present? ? order.created_at.strftime("#{order.created_at.strftime("%d").to_i.ordinalize} %B %Y") : '',
                year_month: Date.today.strftime("%Y-%m"),
                signee_name: signee_name,
                signee_position_1: signee_position_1,
                signee_position_2: signee_position_2,
                ref_id: ref_id
            }

            properties = {
                start_page_number: 1 
            }

            data = template.render_to_string context, properties
            send_data data, filename: "change-address-approval-letter.docx"
        else
            flash[:error] = "No changes on address detected"
            redirect_to @redirect_to
        end
    end

    def registration_letter
        service_provider = {}

        signee_name = TemplateVariable.where(:code => 'REGISTRATION_SIGNEE_NAME').pluck(:value).first
        signee_position_1 = TemplateVariable.where(:code => 'REGISTRATION_SIGNEE_POSITION_LINE_1').pluck(:value).first
        signee_position_2 = TemplateVariable.where(:code => 'REGISTRATION_SIGNEE_POSITION_LINE_2').pluck(:value).first

        if @xray_facility.present?
            service_provider = @xray_facility
            template_document = "service-provider-approval-letter-new-xray-template.docx"
            order = service_provider.orders.where(:category => "XRAY_FACILITY_REGISTRATION").last
            @redirect_to = internal_xray_facility_path(@xray_facility)
        end

        if @laboratory.present?
            service_provider = @laboratory
            template_document = "service-provider-approval-letter-new-laboratory-template.docx"
            order = service_provider.orders.where(:category => "LABORATORY_REGISTRATION").last
            @redirect_to = internal_laboratory_path(@laboratory)
        end

        if @doctor.present?
            service_provider = @doctor
            template_document = "service-provider-approval-letter-new-doctor-template.docx"
            order = service_provider.orders.where(:category => "DOCTOR_REGISTRATION").last
            @redirect_to = internal_doctor_path(@doctor)
        end

        if @radiologist.present?
            service_provider = @radiologist
            template_document = "service-provider-approval-letter-new-radiologist-template.docx"
            order = service_provider.orders.where(:category => "RADIOLOGIST_REGISTRATION").last
            @redirect_to = internal_radiologist_path(@radiologist)

            signee_name = TemplateVariable.where(:code => 'REGISTRATION_RADIOLOGIST_SIGNEE_NAME').pluck(:value).first
            signee_position_1 = TemplateVariable.where(:code => 'REGISTRATION_RADIOLOGIST_SIGNEE_POSITION_LINE_1').pluck(:value).first
            signee_position_2 = TemplateVariable.where(:code => 'REGISTRATION_RADIOLOGIST_SIGNEE_POSITION_LINE_2').pluck(:value).first
        end

        if order.nil?
            flash[:error] = "No Paid Registration Detected"
            redirect_to @redirect_to and return
        end

        ref_id = service_provider.id < 10000 ? (sprintf '%04d', service_provider.id) : (sprintf '%05d', service_provider.id)

        template = Sablon.template "#{Rails.root.to_s}/app/views/doc_templates/#{template_document}"

        context = {
            letter_ref_no: '123',
            letter_date: Time.now.strftime("#{Date.today.day.ordinalize} %B %Y"),
            service_provider: service_provider,
            order_code: order.code,
            order_date: order.date.strftime("#{order.created_at.strftime("%d").to_i.ordinalize} %B %Y"),
            order_amount: sprintf("%.2f", order.amount),
            year_month: Date.today.strftime("%Y-%m"),
            signee_name: signee_name,
            signee_position_1: signee_position_1,
            signee_position_2: signee_position_2,
            ref_id: ref_id

        }

        properties = {
            start_page_number: 1
        }

        data = template.render_to_string context, properties
        send_data data, filename: "new-registration-letter.docx"
    end
end