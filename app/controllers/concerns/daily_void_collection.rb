module DailyVoidCollection

    def void_collection
        @formatted_current_date = @current.strftime('%d/%m/%Y')
        beginning_of_day = @current.beginning_of_day
        end_of_day = @current.end_of_day

        @batch_record_type = 'PY'
        main_bank_code = FinanceSetting.get_value('BANK_OCBC_MAIN')
        cimb_bank_code = FinanceSetting.get_value('BANK_CIMB')
        swipe_bank_code = FinanceSetting.get_value('BANK_OCBC_PT_SWIPE')

        collections = [
            {
                by_branch: true,
                categories: ['TRANSACTION_REGISTRATION','SPECIAL_RENEWAL_TRANSACTION_REGISTRATION','TRANSACTION_EXTENTION','TRANSACTION_CHANGE_DOCTOR','FOREIGN_WORKER_AMENDMENT','FOREIGN_WORKER_GENDER_AMENDMENT','REPRINT_MEDICAL_FORM']
            },{
                by_branch: false,
                categories: ['DOCTOR_REGISTRATION','DOCTOR_CHANGE_ADDRESS','LABORATORY_REGISTRATION','LABORATORY_CHANGE_ADDRESS','XRAY_FACILITY_REGISTRATION','XRAY_FACILITY_CHANGE_ADDRESS','RADIOLOGIST_REGISTRATION'],
                service_providers: ['Doctor','XrayFacility','Laboratory','Radiologist']
            }
        ]

        payment_types = PaymentMethod.where(:category => 'IN').where("code not ilike 'IPAY%' and code not ilike 'SWIPE%' and code not ilike 'PAYNET%' and code not ilike 'BOLEH%'")
        branches = Organization.where(:org_type => 'BRANCH')

        @main_receipt_adjustments = {}
        @cimb_receipt_adjustments = {}
        @swipe_receipt_adjustments = {}

        @pushed_main_bank_drafts = {}
        @pushed_main_order_payments = {}
        @pushed_cimb_order_payments = {}
        @pushed_swipe_order_payments = {}

        collections.each do |collection|
            if collection[:by_branch]
                branches.each do |branch|
                    @bank_code = FinanceSetting.get_value("BANK_OCBC_#{branch.code}")
                    @receipt_adjustments = {}
                    @pushed_bank_drafts = {}
                    @pushed_order_payments = {}

                    payment_types.each do |payment_type|
                        @payment_type = payment_type
                        @payment_code = payment_type.payment_code

                        @description = "Void Collection from Branch on #{@formatted_current_date} - #{branch.code} (#{payment_type.name})"

                        if payment_type.code == 'BANKDRAFT'
                            bank_drafts = BankDraft.where('bad_at <= ?', end_of_day).where(:payerable_type => ["Employer", "Agency"], :organization_id => branch.id, :bad => true, :sync_bad_date => [nil,'']).where.not(:sync_date => nil)

                            bank_draft_dates = bank_drafts.order("bad_at ASC").pluck("date(bad_at)").uniq

                            bank_draft_dates.each do |bank_draft_date|
                                formatted_date = bank_draft_date.strftime('%d/%m/%Y')
                                @description = "Void Collection from Branch on #{formatted_date} - #{branch.code} (#{payment_type.name})"
                                @bank_draft_date = formatted_date

                                different_date_bank_drafts = bank_drafts.where("date(bad_at) in (?)",bank_draft_date)

                                different_date_bank_drafts.each do |bank_draft|
                                    @bank_draft = bank_draft

                                    generate_void_bankdraft
                                end
                            end
                        else
                            order_payments = OrderPayment.joins(:order)
                            .where(orders: { category: collection[:categories],organization_id: branch.id, status: 'PAID',payment_method_id: payment_type.id})
                            .where('bad_at <= ?', end_of_day).where(:bad => true, :sync_bad_date => [nil,''])
                            .where.not(:sync_date => nil)

                            order_payment_dates = order_payments.order("bad_at ASC").pluck("date(bad_at)").uniq

                            order_payment_dates.each do |order_payment_date|
                                formatted_date = order_payment_date.strftime('%d/%m/%Y')
                                @description = "Void Collection from Branch on #{formatted_date} - #{branch.code} (#{payment_type.name})"
                                @order_payment_date = formatted_date

                                different_date_order_payments = order_payments.where("date(bad_at) in (?)",order_payment_date)

                                different_date_order_payments.each do |order_payment|
                                    @order_payment = order_payment

                                    generate_void_order_payment
                                end
                            end
                        end
                    end
                    @receipt_adjustments.each do |date, receipt_adjustments|
                        @bank_draft_ids = @pushed_bank_drafts[date]
                        @order_payment_ids = @pushed_order_payments[date]
                        head_description = "Void Collection from #{@bank_code} on #{date}"
                        generate_void_content(receipt_adjustments, head_description, @bank_code)
                    end
                end
            else
                @bank_code = FinanceSetting.get_value('BANK_OCBC_OTHER')
                @receipt_adjustments = {}
                @pushed_bank_drafts = {}
                @pushed_order_payments = {}

                payment_types.each do |payment_type|
                    @payment_code = payment_type.payment_code
                    @payment_type = payment_type

                    if payment_type.code == 'BANKDRAFT'
                        bank_drafts = BankDraft.where('bad_at <= ?', end_of_day).where(:payerable_type => collection[:service_providers], :bad => true, :sync_bad_date => [nil,'']).where.not(:sync_date => nil)

                        bank_draft_dates = bank_drafts.order("bad_at ASC").pluck("date(bad_at)").uniq

                        bank_draft_dates.each do |bank_draft_date|
                            formatted_date = bank_draft_date.strftime('%d/%m/%Y')
                            @description = "Void Collection from MSPD on #{formatted_date} - (#{payment_type.name})"
                            @bank_draft_date = formatted_date

                            different_date_bank_drafts = bank_drafts.where("date(bad_at) in (?)",bank_draft_date)

                            different_date_bank_drafts.each do |bank_draft|
                                @bank_draft_allocations = bank_draft.bank_draft_allocations
                                .where(:allocatable_type => 'Order')
                                .joins('INNER JOIN orders on bank_draft_allocations.allocatable_id = orders.id')
                                .where("orders.category IN (?)", collection[:categories])

                                @bank_draft = bank_draft

                                generate_void_bankdraft
                            end
                        end
                    else
                        order_payments = OrderPayment.joins(:order)
                        .where(orders: { category: collection[:categories], status: 'PAID',payment_method_id: payment_type.id})
                        .where('bad_at <= ?', end_of_day).where(:bad => true, :sync_bad_date => [nil,''])
                        .where.not(:sync_date => nil)

                        order_payment_dates = order_payments.order("bad_at ASC").pluck("date(bad_at)").uniq

                        order_payment_dates.each do |order_payment_date|
                            formatted_date = order_payment_date.strftime('%d/%m/%Y')
                            @description = "Void Collection from MSPD on #{formatted_date} - (#{payment_type.name})"
                            @order_payment_date = formatted_date

                            different_date_order_payments = order_payments.where("date(bad_at) in (?)",order_payment_date)

                            different_date_order_payments.each do |order_payment|
                                @order_payment = order_payment

                                generate_void_order_payment
                            end
                        end
                    end
                end

                @receipt_adjustments.each do |date, receipt_adjustments|
                    @bank_draft_ids = @pushed_bank_drafts[date]
                    @order_payment_ids = @pushed_order_payments[date]
                    head_description = "Void Collection from #{@bank_code} on #{date}"
                    generate_void_content(receipt_adjustments, head_description, @bank_code)
                end
            end
        end

        # @pushed_bank_drafts = {}
        @pushed_bank_drafts = @pushed_main_bank_drafts
        @pushed_order_payments = @pushed_main_order_payments

        @main_receipt_adjustments.each do |date, main_receipt_adjustments|
            @bank_draft_ids = @pushed_main_bank_drafts[date]
            @order_payment_ids = @pushed_main_order_payments[date]
            main_head_description = "Void Collection from #{main_bank_code} on #{date}"
            generate_void_content(main_receipt_adjustments, main_head_description, main_bank_code)
        end

        @pushed_order_payments = @pushed_cimb_order_payments

        @cimb_receipt_adjustments.each do |date, cimb_receipt_adjustments|
            @order_payment_ids = @pushed_cimb_order_payments[date]
            cimb_head_description = "Void Collection from #{cimb_bank_code} on #{date}"
            generate_void_content(cimb_receipt_adjustments, cimb_head_description, cimb_bank_code)
        end

        @pushed_order_payments = @pushed_swipe_order_payments

        @swipe_receipt_adjustments.each do |date, swipe_receipt_adjustments|
            @order_payment_ids = @pushed_swipe_order_payments[date]
            swipe_head_description = "Void Collection from #{swipe_bank_code} on #{date}"
            generate_void_content(swipe_receipt_adjustments, swipe_head_description, swipe_bank_code)
        end
    end

private
    def generate_void_content(receipt_adjustments, head_description, bank_code)
        if !receipt_adjustments.blank?
            @request_content = {
                BatchSelector: @batch_record_type,
                Description: head_description.upcase,
                BankCode: bank_code,
                PaymentsAdjustments: receipt_adjustments
            }

            payment_adjustment_batches
        end
    end

    def generate_void_bankdraft
        misc_receipts = []
        reference_desc = "Bank Draft Issued Date/Bank: #{@bank_draft.issue_date.strftime('%d/%m/%Y')} / #{@bank_draft.bank.code}".upcase
        branch_code = ''

        if @bank_draft.document_number.blank?
            @bank_draft.update_document_number
        end

        if ['Employer', 'Agency'].include? @bank_draft.payerable_type
            account_number = FinanceSetting.get_value("COLLECTION_#{@bank_draft.organization&.code}")
            branch_code = @bank_draft.organization&.code
            misc_receipt = {
                    DistributionCode: '',
                    AccountNumber: account_number,
                    DistributionAmount: @bank_draft.amount.try(:to_f),
                    GLReference: reference_desc
                }

            misc_receipts << misc_receipt
        else
            @bank_draft_allocations.each do |bank_draft_allocation|
                allocatable = bank_draft_allocation.allocatable
                account_number = ''
                branch_code = 'HQ'

                if ['DOCTOR_REGISTRATION','LABORATORY_REGISTRATION','XRAY_FACILITY_REGISTRATION','RADIOLOGIST_REGISTRATION'].include?(allocatable.category)
                    account_number = FinanceSetting.get_value("REVENUE_REG_#{@bank_draft.payerable_type.upcase}")
                elsif ['DOCTOR_CHANGE_ADDRESS','LABORATORY_CHANGE_ADDRESS','XRAY_FACILITY_CHANGE_ADDRESS'].include?(allocatable.category)
                    account_number = FinanceSetting.get_value("REVENUE_CHANGE_CLINIC_ADDRESS")
                end

                misc_receipt = {
                    DistributionCode: '',
                    AccountNumber: account_number,
                    DistributionAmount: bank_draft_allocation.amount.try(:to_f),
                    GLReference: reference_desc
                }

                misc_receipts << misc_receipt
            end
        end

        receipt_adjustment = {
            CheckNumber: '',
            VendorNumber: '',
            VendorPayeeName: "#{@bank_draft.payerable.try(:code)} #{branch_code}-#{@bank_draft.number}",
            PaymentDateAdjustmentDate: "#{@bank_draft.bad_at.try(:to_date)}#{@utc_time_format}",
            PostingDate: "#{@bank_draft.bad_at.try(:to_date)}#{@utc_time_format}",
            EntryDescription: @description.upcase,
            EntryReference: reference_desc,
            PaymentCode: @payment_code,
            MatchingDocumentNumber: @bank_draft.document_number,
            PaymentTransactionType: 'MiscellaneousPayment',
            MiscellaneousPayments: misc_receipts
        }

        if @payment_type.is_main
            @pushed_main_bank_drafts[@bank_draft_date].blank? ? @pushed_main_bank_drafts[@bank_draft_date] = [@bank_draft.id] : @pushed_main_bank_drafts[@bank_draft_date] << @bank_draft.id

            @main_receipt_adjustments[@bank_draft_date].blank? ? @main_receipt_adjustments[@bank_draft_date] = [receipt_adjustment] : @main_receipt_adjustments[@bank_draft_date] << receipt_adjustment
        else
            @pushed_bank_drafts[@bank_draft_date].blank? ? @pushed_bank_drafts[@bank_draft_date] = [@bank_draft.id] : @pushed_bank_drafts[@bank_draft_date] << @bank_draft.id

            @receipt_adjustments[@bank_draft_date].blank? ? @receipt_adjustments[@bank_draft_date] = [receipt_adjustment] : @receipt_adjustments[@bank_draft_date] << receipt_adjustment
        end
    end

    def generate_void_order_payment

        @order = @order_payment.order
        # @order_payment.update_document_number
        account_number = ''
        branch_code = ''

        if ['Employer', 'Agency'].include? @order.customerable_type
            account_number = FinanceSetting.get_value("COLLECTION_#{@order.organization&.code}")
            branch_code = @order.organization&.code
        else
            if ['DOCTOR_REGISTRATION','LABORATORY_REGISTRATION','XRAY_FACILITY_REGISTRATION','RADIOLOGIST_REGISTRATION'].include?(@order.category)
                account_number = FinanceSetting.get_value("REVENUE_REG_#{@order.customerable_type.upcase}")
            elsif ['DOCTOR_CHANGE_ADDRESS','LABORATORY_CHANGE_ADDRESS','XRAY_FACILITY_CHANGE_ADDRESS'].include?(@order.category)
                account_number = FinanceSetting.get_value("REVENUE_CHANGE_CLINIC_ADDRESS")
            end
            branch_code = 'HQ'
        end

        if @payment_type.code == 'CIMB_CLICKS'
            reference_desc = "CIMB CLICKS ISSUED DATE: #{@order_payment&.issue_date.try(:strftime,'%d/%m/%Y')}"
            receipt_number = @order_payment.reference
        elsif @payment_type.code == 'OCBC_DUITNOW_QR'
            reference_desc = "#{@order.payment_method.name}".upcase
            receipt_number = "#{branch_code}-#{@order_payment.reference}"
        else
            reference_desc = "#{@order.payment_method.name}".upcase
            receipt_number = @order_payment.reference
        end

        receipt_adjustment = {
            CheckNumber: '',
            VendorNumber: '',
            VendorPayeeName: "#{@order.customerable.try(:code)} #{receipt_number}",
            PaymentDateAdjustmentDate: "#{@order_payment.bad_at.try(:to_date)}#{@utc_time_format}",
            PostingDate: "#{@order_payment.bad_at.try(:to_date)}#{@utc_time_format}",
            EntryDescription: @description.upcase,
            EntryReference: reference_desc,
            PaymentCode: @payment_code,
            MatchingDocumentNumber: @order_payment.document_number,
            PaymentTransactionType: 'MiscellaneousPayment',
            MiscellaneousPayments: [{
                DistributionCode: '',
                AccountNumber: account_number,
                DistributionAmount: @order_payment.amount.try(:to_f),
                GLReference: reference_desc
            }]
        }

        if @payment_type.is_main
            @pushed_main_order_payments[@order_payment_date].blank? ? @pushed_main_order_payments[@order_payment_date] = [@order_payment.id] : @pushed_main_order_payments[@order_payment_date] << @order_payment.id

            @main_receipt_adjustments[@order_payment_date].blank? ? @main_receipt_adjustments[@order_payment_date] = [receipt_adjustment] : @main_receipt_adjustments[@order_payment_date] << receipt_adjustment
        elsif @payment_type.code == 'CIMB_CLICKS'
            @pushed_cimb_order_payments[@order_payment_date].blank? ? @pushed_cimb_order_payments[@order_payment_date] = [@order_payment.id] : @pushed_cimb_order_payments[@order_payment_date] << @order_payment.id

            @cimb_receipt_adjustments[@order_payment_date].blank? ? @cimb_receipt_adjustments[@order_payment_date] = [receipt_adjustment] : @cimb_receipt_adjustments[@order_payment_date] << receipt_adjustment
        elsif @payment_type.code.include?('SWIPE')
            @pushed_swipe_order_payments[@order_payment_date].blank? ? @pushed_swipe_order_payments[@order_payment_date] = [@order_payment.id] : @pushed_swipe_order_payments[@order_payment_date] << @order_payment.id

            @swipe_receipt_adjustments[@order_payment_date].blank? ? @swipe_receipt_adjustments[@order_payment_date] = [receipt_adjustment] : @swipe_receipt_adjustments[@order_payment_date] << receipt_adjustment
        else
            @pushed_order_payments[@order_payment_date].blank? ? @pushed_order_payments[@order_payment_date] = [@order_payment.id] : @pushed_order_payments[@order_payment_date] << @order_payment.id

            @receipt_adjustments[@order_payment_date].blank? ? @receipt_adjustments[@order_payment_date] = [receipt_adjustment] : @receipt_adjustments[@order_payment_date] << receipt_adjustment
        end
    end
end
