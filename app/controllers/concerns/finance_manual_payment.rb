module FinanceManualPayment

    def view_transactions
        has_any_parameter   = [:worker_code, :code].map {|param_name| params[param_name].present? }.include?(true)

        if has_any_parameter
            transactions = Transaction.includes(:foreign_worker,:doctor, :laboratory, :xray_facility,:sp_transactions_payments, employer: [:employer_type])
            .search_transaction_date_start("1998-03-14")
            .search_code(params[:code])
            .search_fw_code(params[:worker_code])
        else
            transactions = Transaction.none
        end
        @transactions   = transactions.page(params[:page]).per(get_per)

        render 'internal/service_provider_payments/manual_payment/index'
    end

    def update_payment
        # check certified or non certified
        isCertified = checkCertified(@transaction)
        redirect_to = internal_manual_payment_view_transactions_path(:worker_code => @transaction.foreign_worker.code)

        # need to check if its individual or group
        sp_type = sp_transactions_payment_params[:service_providable_type]
        if sp_type == XrayFacility.to_s
            service_provider = @transaction.xray_facility
            redirect_path = internal_manual_payment_edit_payment_xray_path
        elsif sp_type == Doctor.to_s
            service_provider = @transaction.doctor
            redirect_path = internal_manual_payment_edit_payment_doctor_path
        else
            service_provider =  @transaction.laboratory
            redirect_path = internal_manual_payment_edit_payment_lab_path
        end

        group_id = getGroup(sp_type,service_provider,@transaction.certification_date)
        if group_id.present? 
            updated_params = sp_transactions_payment_params.merge({
                service_provider_group_id: group_id
            })
        else
            updated_params = sp_transactions_payment_params
        end
        @sp_transactions_payment = SpTransactionsPayment.new(updated_params)

        respond_to do |format|
            if @sp_transactions_payment.save
                format.html { redirect_to redirect_to, notice: 'Payment was successfully updated.' }
                format.json { render :show, status: :created, location: @transaction }
            else
                format.html { redirect_back(fallback_location: redirect_path) }
                format.json { render json: @sp_transactions_payment.errors, status: :unprocessable_entity }
            end
        end
    end

    def edit_payment_xray
        sp_type = XrayFacility.to_s
        xray_payment = @transaction.sp_transactions_payments.where(:service_providable_type => sp_type).first

        @service_provider = @transaction.xray_facility
        transaction_detail = @transaction.transaction_detail

        if xray_payment
            @payment = xray_payment
        else
            @payment = SpTransactionsPayment.new
            @payment.service_providable_type = sp_type

            group_id = getGroup(sp_type,@service_provider,@transaction.certification_date)
            if group_id.present? 
                # get group default rate
                group = ServiceProviderGroup.find(group_id)
                @payment.amount = @transaction&.fw_gender == 'M' ? transaction_detail.try(:xray_sp_group_male_rate) : transaction_detail.try(:xray_sp_group_female_rate)
            else
                @payment.amount = @transaction&.fw_gender == 'M' ? transaction_detail.try(:xray_male_rate) : transaction_detail.try(:xray_female_rate)
            end
        end
        
        render 'internal/service_provider_payments/manual_payment/edit'
    end


    def edit_payment_lab
        isCertified = checkCertified(@transaction)

        lab_payment = @transaction.sp_transactions_payments.where(:service_providable_type => Laboratory.to_s).first

        if lab_payment
            @payment = lab_payment
        else
            @payment = SpTransactionsPayment.new
            @payment.service_providable_type = Laboratory.to_s
        end

        @service_provider = @transaction.laboratory
        
        
        render "internal/service_provider_payments/manual_payment/edit"
    end

    def edit_payment_doctor
        isCertified = checkCertified(@transaction)
        sp_type = Doctor.to_s

        doctor_payment = @transaction.sp_transactions_payments.where(:service_providable_type => sp_type).first
        @service_provider = @transaction.doctor
        transaction_detail = @transaction.transaction_detail
        
        if doctor_payment
            @payment = doctor_payment
        else
            @payment = SpTransactionsPayment.new
            @payment.service_providable_type = sp_type

            group_id = getGroup(sp_type,@service_provider,@transaction.certification_date)
            if group_id.present? 
                # get group default rate
                group = ServiceProviderGroup.find(group_id)
                @payment.amount = @transaction&.fw_gender == 'M' ? transaction_detail.try(:doc_sp_group_male_rate) : transaction_detail.try(:doc_sp_group_female_rate)
            else
                @payment.amount = @transaction&.fw_gender == 'M' ? transaction_detail.try(:doc_male_rate) : transaction_detail.try(:doc_female_rate)
            end
        end
        
        render "internal/service_provider_payments/manual_payment/edit"
    end

    def view_payment_xray
        isCertified = checkCertified(@transaction)

        xray_payment = @transaction.sp_transactions_payments.where(:service_providable_type => XrayFacility.to_s).first

        if xray_payment
            @payment = xray_payment
        else
            redirect_to internal_manual_payment_edit_payment_xray_path and return
        end

        @service_provider = @transaction.xray_facility

        render "internal/service_provider_payments/manual_payment/show"
    end

    def view_payment_lab
        isCertified = checkCertified(@transaction)

        lab_payment = @transaction.sp_transactions_payments.where(:service_providable_type => Laboratory.to_s).first

        if lab_payment
            @payment = lab_payment
        else
            redirect_to internal_manual_payment_edit_payment_lab_path and return
        end

        @service_provider = @transaction.laboratory
        
        render "internal/service_provider_payments/manual_payment/show"
    end

    def view_payment_doctor
        isCertified = checkCertified(@transaction)

        doctor_payment = @transaction.sp_transactions_payments.where(:service_providable_type => Doctor.to_s).first

        if doctor_payment
            @payment = doctor_payment
        else
            redirect_to internal_manual_payment_edit_payment_doctor_path and return
        end

        @service_provider = @transaction.doctor
        
        render "internal/service_provider_payments/manual_payment/show"
    end

    def export_manual_payment

        @transactions = Transaction.none

        if params[:worker_code]
            @transactions = Transaction.includes(:foreign_worker,:doctor, :laboratory, :xray_facility,:sp_transactions_payments, employer: [:employer_type])
            .joins(:foreign_worker).where("foreign_workers.code = ?", params[:worker_code])
        end

        filename = "#{params[:worker_code]}_Transactions.csv"
        respond_to do |format|
          format.csv { send_data SpTransactionsPayment.to_csv(@transactions), filename: filename }
        end
    end

private
    def sp_transactions_payment_params
        params.require(:sp_transactions_payment).permit(:transaction_id, :service_providable_id, :service_providable_type, :amount, :pay_at, :service_provider_group_id)
    end

    def getGroup(service_provider_type,service_provider,certified_date)
        group_id = ''
        sp_group_history = SpGroupHistory.where(["service_providable_type = ? AND service_providable_id = ? AND exit_date <= ?",service_provider_type, service_provider.id,certified_date]).first

        # sort
        if sp_group_history and sp_group_history.exit_date
            # there have exit group before
            group_id = sp_group_history.service_provider_group_id
        else
            # note: if join date is after certified date, its individual

            if service_provider.service_provider_group_id.present?
                sp_group_history = SpGroupHistory.where(["service_providable_type = ? AND service_providable_id = ? AND join_date <= ? AND service_provider_group_id = ?",service_provider_type, service_provider.id,certified_date,service_provider.service_provider_group_id]).first
                # join date is before certified date
                if sp_group_history
                    # group
                    group_id = service_provider.service_provider_group_id
                end
            end
        end

        return group_id
    end

    def checkCertified(transaction)
        isCertified = transaction.certification_date.present?
        return isCertified
    end
end