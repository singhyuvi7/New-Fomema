module BankInfoCheck

    # def can_proceed?(employer, transactions=nil)
    #     @incomplete = false

    #     @employer = employer
    #     if @employer.nil?
    #         transactions.to_unsafe_h.each do |transaction_id, doctor_id|
    #             @employer = Transaction.find(transaction_id).employer
    #             check_bank_info

    #             if @incomplete == true
    #                 break
    #             end
    #         end
    #     else
    #         check_bank_info
    #     end
    # end

    def can_proceed?(customerable_type, customerable, transactions=nil)
        @incomplete = false

        if customerable.nil?
            # For change clinic with multiple transactions (employer can be different)
            transactions.to_unsafe_h.each do |transaction_id, doctor_id|
                @agency = Transaction.find(transaction_id).try(:agency)
                @employer = Transaction.find(transaction_id).employer
                
                check_bank_info
                
                if @incomplete == true
                    break
                end
            end
        else
            # For single transaction
            transaction_id = transactions

            case customerable_type
            when 'Agency'
                @agency = customerable
            when 'Employer'
                @employer = customerable
            end

            @agency = (!transaction_id.nil?) ? Transaction.find(transaction_id).try(:agency) : @agency
            @employer = (!transaction_id.nil?) ? Transaction.find(transaction_id).try(:employer) : @employer
            
            check_bank_info
        end
    end

    def can_proceed_special_renewal?(employer, fw_ids)
        @employer = employer
        have_special = false
        
        fw_ids.try(:each) do |fw_id|
            foreign_worker = ForeignWorker.find(fw_id)
            if foreign_worker.special_renewal?
                have_special = true
                break
            end
        end

        if have_special
            check_bank_info
        end
    end

    def check_bank_info
        case
        when !@agency.nil?
            customer = 'agency'
            incomplete_bank_info = @agency.bank_id.blank? || @agency.bank_account_number.blank?
        when @agency.nil? && !@employer.nil?
            customer = 'employer'
            incomplete_bank_info = @employer.bank_id.blank? || @employer.bank_account_number.blank?
        end

        if incomplete_bank_info
            @incomplete = true

            msg = "Bank details incomplete. Please update #{customer} bank details before proceeding."

            if ['Employer', 'Agency'].include?(current_user.userable_type)
                msg += "<button type='button' class='btn btn-secondary' data-toggle='tooltip' data-placement='left' title='To update bank details, please click on the user icon at the top right corner and click on Profile under the user icon.'><i class='fa fa-info-circle'></i></button>"
            end

            flash[:error] = msg
            redirect_to (request.env["HTTP_REFERER"] || internal_root_path) and return
        end
    end
end