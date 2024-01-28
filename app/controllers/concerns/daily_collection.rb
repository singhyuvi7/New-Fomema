module DailyCollection

    def collection
        @formatted_current_date = @current.strftime('%d/%m/%Y')
        beginning_of_day = @current.beginning_of_day
        end_of_day = @current.end_of_day

        @batch_record_type = 'CA'
        main_bank_code = FinanceSetting.get_value('BANK_OCBC_MAIN')
        cimb_bank_code = FinanceSetting.get_value('BANK_CIMB')
        swipe_bank_code = FinanceSetting.get_value('BANK_OCBC_PT_SWIPE')
        fpx_bank_code = FinanceSetting.get_value('BANK_OCBC_PT_PAYNET')
        boleh_bank_code = FinanceSetting.get_value('BANK_OCBC_PT_BOLEHPAY')
        @cimb_payment_method = PaymentMethod.find_by(code: "CIMB_CLICKS")

        @is_insurance_recognized = SystemConfiguration.find_by(code: 'INSURANCE_RECOGNIZED_COLLECTION')&.value
        @insurance_collected_arr = []

        collections = [
            {
                by_branch: true,
                categories: ['TRANSACTION_REGISTRATION','SPECIAL_RENEWAL_TRANSACTION_REGISTRATION','TRANSACTION_EXTENTION','TRANSACTION_CHANGE_DOCTOR','FOREIGN_WORKER_AMENDMENT','FOREIGN_WORKER_GENDER_AMENDMENT','REPRINT_MEDICAL_FORM','INSURANCE_PURCHASE','AGENCY_REGISTRATION','AGENCY_RENEWAL']
            },{
                by_branch: false,
                categories: ['DOCTOR_REGISTRATION','DOCTOR_CHANGE_ADDRESS','LABORATORY_REGISTRATION','LABORATORY_CHANGE_ADDRESS','XRAY_FACILITY_REGISTRATION','XRAY_FACILITY_CHANGE_ADDRESS','RADIOLOGIST_REGISTRATION','DOCTOR_BIOMETRIC_DEVICE','XRAY_FACILITY_BIOMETRIC_DEVICE'],
                service_providers: ['Doctor','XrayFacility','Laboratory','Radiologist']
            }
        ]

        payment_types = PaymentMethod.where(:category => 'IN').where.not(:payment_code => [nil,''])
        branches = Organization.where(:org_type => 'BRANCH')
        @main_receipt_adjustments = {}
        @cimb_receipt_adjustments = {}
        @swipe_receipt_adjustments = {}
        @fpx_receipt_adjustments = {}
        @boleh_receipt_adjustments = {}
        @pushed_main_bank_drafts = {}
        @pushed_main_ipays = {}
        @pushed_main_swipes = {}
        @pushed_main_fpxs = {}
        @pushed_main_bolehs = {}
        @pushed_main_order_payments = {}
        @pushed_cimb_refunds = {}
        @pushed_cimb_order_payments = {}
        @pushed_swipe_order_payments = {}
        @pushed_fpx_order_payments = {}
        @pushed_boleh_order_payments = {}
        @pushed_swipes = {}
        @pushed_fpxs = {}
        @pushed_bolehs = {}

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

                        @description = "Collection from Branch on #{@formatted_current_date} - #{branch.code} (#{payment_type.name})"

                        if payment_type.code == 'BANKDRAFT'
                            bank_drafts = BankDraft.where('created_at <= ?', end_of_day).where(:payerable_type => ["Employer", "Agency"], :organization_id => branch.id, :bad => false, :holded => false, :sync_date => [nil, ""])

                            bank_draft_dates = bank_drafts.order("created_at ASC").pluck("date(created_at)").uniq

                            bank_draft_dates.each do |bank_draft_date|
                                formatted_date = bank_draft_date.strftime('%d/%m/%Y')
                                @description = "Collection from Branch on #{formatted_date} - #{branch.code} (#{payment_type.name})"
                                @bank_draft_date = formatted_date

                                different_date_bank_drafts = bank_drafts.where("date(created_at) in (?)",bank_draft_date)

                                different_date_bank_drafts.each do |bank_draft|
                                    @bank_draft = bank_draft

                                    generate_bankdraft
                                end
                            end

                        elsif payment_type.code.start_with?('IPAY')
                            # latest_ipay88_request not working
                            order_ids = Order.joins(:latest_ipay88_request)
                            .where(ipay88_requests: {sync_date: [nil, ""]})
                            .where(:category => collection[:categories], :organization_id => branch.id, :status => 'PAID', :payment_method_id => payment_type.id)
                            .where('orders.updated_at <= ?', end_of_day)
                            .where.not(paid_at: nil).pluck('orders.id').uniq

                            orders = Order.where(id: order_ids)

                            ipay_dates = orders.order("paid_at ASC").pluck("date(paid_at)").uniq

                            ipay_dates.each do |ipay_date|
                                formatted_date = ipay_date.strftime('%d/%m/%Y')
                                @description = "Collection from Branch on #{formatted_date} - #{branch.code} (#{payment_type.name})"
                                @ipay_date = formatted_date

                                difference_date_ipays = orders.where("date(paid_at) in (?)",ipay_date)

                                difference_date_ipays.each do |order|
                                    @order = order
                                    @order_items = order.order_items
                                    @ipay = order.latest_ipay88_request
                                    if @ipay.sync_date.blank?
                                        @ipay_response = @ipay.ipay88_responses.where(:status => '1').first
                                        generate_ipay88
                                    end
                                end
                            end
                        elsif payment_type.code.start_with?('SWIPE')
                            order_ids = Order.joins(:latest_swipe_request)
                            .where(swipe_requests: {sync_date: [nil, ""]})
                            .where(:category => collection[:categories], :organization_id => branch.id, :status => 'PAID', :payment_method_id => payment_type.id)
                            .where('orders.updated_at <= ?', end_of_day)
                            .where.not(paid_at: nil).pluck('orders.id').uniq

                            orders = Order.where(id: order_ids)

                            swipe_dates = orders.order("paid_at ASC").pluck("date(paid_at)").uniq

                            swipe_dates.each do |swipe_date|
                                formatted_date = swipe_date.strftime('%d/%m/%Y')
                                @description = "Collection from Branch on #{formatted_date} - #{branch.code} (#{payment_type.name})"
                                @swipe_date = formatted_date

                                difference_date_swipes = orders.where("date(paid_at) in (?)",swipe_date)

                                difference_date_swipes.each do |order|
                                    @order = order
                                    @order_items = order.order_items
                                    @swipe = order.latest_swipe_request
                                    if @swipe.sync_date.blank?
                                        @swipe_response = @swipe.swipe_responses.where(:status => '1').first
                                        generate_swipe
                                    end
                                end
                            end
                        elsif payment_type.code.start_with?('PAYNET')
                            order_ids = Order.joins(:latest_fpx_request)
                            .where(fpx_requests: {sync_date: [nil, ""]})
                            .where(:category => collection[:categories], :organization_id => branch.id, :status => 'PAID', :payment_method_id => payment_type.id)
                            .where('orders.updated_at <= ?', end_of_day)
                            .where.not(paid_at: nil).pluck('orders.id').uniq

                            orders = Order.where(id: order_ids)

                            fpx_dates = orders.order("paid_at ASC").pluck("date(paid_at)").uniq

                            fpx_dates.each do |fpx_date|
                                formatted_date = fpx_date.strftime('%d/%m/%Y')
                                @description = "Collection from Branch on #{formatted_date} - #{branch.code} (#{payment_type.name})"
                                @fpx_date = formatted_date

                                difference_date_fpxs = orders.where("date(paid_at) in (?)",fpx_date)

                                difference_date_fpxs.each do |order|
                                    @order = order
                                    @order_items = order.order_items
                                    @fpx = order.latest_fpx_request
                                    if @fpx.sync_date.blank?
                                        @fpx_response = @fpx.fpx_responses.where(:debit_auth_code => '00').first
                                        generate_fpx
                                    end
                                end
                            end
                        elsif payment_type.code.start_with?('BOLEH')
                            order_ids = Order.joins(:latest_boleh_request)
                            .where(boleh_requests: {sync_date: [nil, ""]})
                            .where(:category => collection[:categories], :organization_id => branch.id, :status => 'PAID', :payment_method_id => payment_type.id)
                            .where('orders.updated_at <= ?', end_of_day)
                            .where.not(paid_at: nil).pluck('orders.id').uniq

                            orders = Order.where(id: order_ids)

                            boleh_dates = orders.order("paid_at ASC").pluck("date(paid_at)").uniq

                            boleh_dates.each do |boleh_date|
                                formatted_date = boleh_date.strftime('%d/%m/%Y')
                                @description = "Collection from Branch on #{formatted_date} - #{branch.code} (#{payment_type.name})"
                                @boleh_date = formatted_date

                                difference_date_bolehs = orders.where("date(paid_at) in (?)", boleh_date)

                                difference_date_bolehs.each do |order|
                                    @order = order
                                    @order_items = order.order_items
                                    @boleh = order.latest_boleh_request
                                    if @boleh.sync_date.blank?
                                        @boleh_response = @boleh.boleh_responses.where(:status => 'approved').first
                                        generate_boleh
                                    end
                                end
                            end
                        else
                            orders = Order.joins(:order_payments)
                            .where(order_payments:{bad: false, holded: false, sync_date: [nil, ""]})
                            .where(:category => collection[:categories], :organization_id => branch.id, :status => 'PAID', :payment_method_id => payment_type.id)
                            .where.not(paid_at: nil)
                            .where('order_payments.updated_at <= ?', end_of_day)

                            order_payment_dates = orders.order("paid_at ASC").pluck("date(paid_at)").uniq

                            order_payment_dates.each do |order_payment_date|
                                formatted_date = order_payment_date.strftime('%d/%m/%Y')
                                @description = "Collection from Branch on #{formatted_date} - #{branch.code} (#{payment_type.name})"
                                @order_payment_date = formatted_date

                                different_date_order_payments = orders.where("date(paid_at) in (?)",order_payment_date)

                                different_date_order_payments.each do |order_payment|
                                    @order = order_payment

                                    generate_order_payment
                                end
                            end
                        end

                    end

                    @receipt_adjustments.each do |date, receipt_adjustments|
                        @bank_draft_ids = @pushed_bank_drafts[date]
                        @order_payment_ids = @pushed_order_payments[date]
                        head_description = "Collection from #{@bank_code} on #{date}"
                        generate_request_content(receipt_adjustments, head_description, @bank_code)
                    end
                end
            else
                @bank_code = FinanceSetting.get_value('BANK_OCBC_OTHER')
                @receipt_adjustments = {}
                @pushed_bank_drafts = {}
                @pushed_order_payments = {}

                payment_types.each do |payment_type|
                    @description = "Collection From MSPD On #{@formatted_current_date} - (#{payment_type.name})"
                    @payment_code = payment_type.payment_code
                    @payment_type = payment_type

                    if payment_type.code == 'BANKDRAFT'
                        bank_drafts = BankDraft.where('created_at <= ?', end_of_day).where(:payerable_type => collection[:service_providers],:bad => false, :holded => false, :sync_date => [nil, ""])

                        bank_draft_dates = bank_drafts.order("created_at ASC").pluck("date(created_at)").uniq

                        bank_draft_dates.each do |bank_draft_date|
                            formatted_date = bank_draft_date.strftime('%d/%m/%Y')
                            @description = "Collection from MSPD on #{formatted_date} - (#{payment_type.name})"
                            @bank_draft_date = formatted_date

                            different_date_bank_drafts = bank_drafts.where("date(created_at) in (?)",bank_draft_date)

                            different_date_bank_drafts.each do |bank_draft|
                                @bank_draft_allocations = bank_draft.bank_draft_allocations
                                .where(:allocatable_type => 'Order')
                                .joins('INNER JOIN orders on bank_draft_allocations.allocatable_id = orders.id')
                                .where("orders.category IN (?)", collection[:categories])

                                @bank_draft = bank_draft

                                generate_bankdraft
                            end
                        end
                    elsif payment_type.code.start_with?('IPAY')
                        # latest_ipay88_request not working
                        order_ids = Order.joins(:latest_ipay88_request)
                        .where(ipay88_requests: {sync_date: [nil, ""]})
                        .where(:category => collection[:categories], :status => 'PAID', :payment_method_id => payment_type.id)
                        .where('orders.updated_at <= ?', end_of_day)
                        .where.not(paid_at: nil).pluck('orders.id').uniq

                        orders = Order.where(id: order_ids)

                        ipay_dates = orders.order("paid_at ASC").pluck("date(paid_at)").uniq

                        ipay_dates.each do |ipay_date|
                            formatted_date = ipay_date.strftime('%d/%m/%Y')
                            @description = "Collection from MSPD on #{formatted_date} - (#{payment_type.name})"
                            @ipay_date = formatted_date

                            difference_date_ipays = orders.where("date(paid_at) in (?)",ipay_date)

                            difference_date_ipays.each do |order|
                                @order = order
                                @order_items = order.order_items
                                @ipay = order.latest_ipay88_request
                                if @ipay.sync_date.blank?
                                    @ipay_response = @ipay.ipay88_responses.where(:status => '1').first
                                    generate_ipay88
                                end
                            end
                        end
                    else
                        orders = Order.joins(:order_payments)
                        .where(order_payments:{bad: false, holded: false, sync_date: [nil, ""]})
                        .where(:category => collection[:categories], :status => 'PAID', :payment_method_id => payment_type.id)
                        .where.not(paid_at: nil)
                        .where('orders.updated_at <= ?', end_of_day)

                        order_payment_dates = orders.order("paid_at ASC").pluck("date(paid_at)").uniq

                        order_payment_dates.each do |order_payment_date|
                            formatted_date = order_payment_date.strftime('%d/%m/%Y')
                            @description = "Collection from MSPD on #{formatted_date} - (#{payment_type.name})"
                            @order_payment_date = formatted_date

                            different_date_order_payments = orders.where("date(paid_at) in (?)",order_payment_date)

                            different_date_order_payments.each do |order_payment|
                                @order = order_payment
                                @order_items = order_payment.order_items

                                generate_order_payment
                            end
                        end
                    end
                end

                @receipt_adjustments.each do |date, receipt_adjustments|
                    @bank_draft_ids = @pushed_bank_drafts[date]
                    @order_payment_ids = @pushed_order_payments[date]
                    head_description = "Collection from #{@bank_code} on #{date}"
                    generate_request_content(receipt_adjustments, head_description, @bank_code)
                end
            end
        end

        # clear bank drafts id and order payment id to avoid failed ids being save as synced rows
        @bank_draft_ids = []
        @order_payment_ids = []

        # send for main bank account
        @main_receipt_adjustments.each do |date, main_receipt_adjustments|
            @bank_draft_ids = @pushed_main_bank_drafts[date]
            @order_payment_ids = @pushed_main_order_payments[date]
            @ipay_ids = @pushed_main_ipays[date]
            @swipe_ids = @pushed_main_swipes[date]
            @fpx_ids = @pushed_main_fpxs[date]
            @boleh_ids = @pushed_main_bolehs[date]
            main_head_description = "Collection from #{main_bank_code} on #{date}"
            generate_request_content(main_receipt_adjustments, main_head_description, main_bank_code)
        end

        # clear ipays id to avoid failed ids being save as synced rows
        @ipay_ids = []

        #send for swipe bank account
        @swipe_receipt_adjustments.each do |date, swipe_receipt_adjustments|
            @order_payment_ids = @pushed_swipe_order_payments[date]
            #@refund_ids = @pushed_swipe_refunds[date]
            @swipe_ids = @pushed_swipes[date]
            swipe_head_description = "Collection from #{swipe_bank_code} on #{date}"
            generate_request_content(swipe_receipt_adjustments, swipe_head_description, swipe_bank_code)
        end

        # clear swipes id to avoid failed ids being save as synced rows
        @swipe_ids = []

        #send for fpx bank account
        @fpx_receipt_adjustments.each do |date, fpx_receipt_adjustments|
            @order_payment_ids = @pushed_fpx_order_payments[date]
            @fpx_ids = @pushed_fpxs[date]
            fpx_head_description = "Collection from #{fpx_bank_code} on #{date}"
            generate_request_content(fpx_receipt_adjustments, fpx_head_description, fpx_bank_code)
        end

        # clear fpxs id to avoid failed ids being save as synced rows
        @fpx_ids = []

        #send for boleh bank account
        @boleh_receipt_adjustments.each do |date, boleh_receipt_adjustments|
            @order_payment_ids = @pushed_boleh_order_payments[date]
            #@refund_ids = @pushed_boleh_refunds[date]
            @boleh_ids = @pushed_bolehs[date]
            boleh_head_description = "Collection from #{boleh_bank_code} on #{date}"
            generate_request_content(boleh_receipt_adjustments, boleh_head_description, boleh_bank_code)
        end

        # clear bolehs id to avoid failed ids being save as synced rows
        @boleh_ids = []

        #send for cimb bank account
        @cimb_receipt_adjustments.each do |date, cimb_receipt_adjustments|
            @order_payment_ids = @pushed_cimb_order_payments[date]
            @refund_ids = @pushed_cimb_refunds[date]
            cimb_head_description = "Collection from #{cimb_bank_code} on #{date}"
            generate_request_content(cimb_receipt_adjustments, cimb_head_description, cimb_bank_code)
        end
    end

private
    def generate_request_content(receipt_adjustments, head_description, bank_code)
        if !receipt_adjustments.blank?
            @request_content = {
                BatchRecordType: @batch_record_type,
                Description: head_description.upcase,
                BankCode: bank_code,
                ReceiptsAdjustments: receipt_adjustments
            }

            receipt_adjustment_batches
        end
    end

    def generate_bankdraft
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
                elsif ['DOCTOR_BIOMETRIC_DEVICE','XRAY_FACILITY_BIOMETRIC_DEVICE'].include?(allocatable.category)
                    biometric_device_account_number = FinanceSetting.get_value("REVENUE_BIOMETRIC_DEVICE")
                    biometric_admin_account_number = FinanceSetting.get_value("REVENUE_BIOMETRIC_ADMIN")

                end

                if ['DOCTOR_BIOMETRIC_DEVICE','XRAY_FACILITY_BIOMETRIC_DEVICE'].include?(allocatable.category)
                    biometric_device_fee = allocatable.order_items.get_biometric_device_fee.sum(&:amount) || 0
                    biometric_admin_fee = allocatable.order_items.get_biometric_admin_fee.sum(&:amount) || 0

                    misc_receipts << {
                        DistributionCode: '',
                        AccountNumber: biometric_device_account_number,
                        DistributionAmount: biometric_device_fee.try(:to_f),
                        GLReference: reference_desc
                    }
                    misc_receipts << {
                        DistributionCode: '',
                        AccountNumber: biometric_admin_account_number,
                        DistributionAmount: biometric_admin_fee.try(:to_f),
                        GLReference: reference_desc
                    }
                else
                    misc_receipt = {
                        DistributionCode: '',
                        AccountNumber: account_number,
                        DistributionAmount: bank_draft_allocation.amount.try(:to_f),
                        GLReference: reference_desc
                    }

                    misc_receipts << misc_receipt
                end
            end
        end

        receipt_adjustment = {
            CheckReceiptNumber: "#{branch_code}-#{@bank_draft.number}",
            CustomerNumber: '',
            Payer: '',
            ReceiptDateAdjustmentDate: "#{@bank_draft.created_at.try(:to_date)}#{@utc_time_format}",
            PostingDate: "#{@bank_draft.created_at.try(:to_date)}#{@utc_time_format}",
            EntryDescription: @description.upcase,
            EntryReference: reference_desc,
            BankReceiptAmount: @bank_draft.amount.try(:to_f),
            PaymentCode: @payment_code,
            MatchingDocumentNumber: @bank_draft.document_number,
            ReceiptTransactionType: 'MiscellaneousReceipt',
            MiscellaneousReceipts: misc_receipts
        }

        if @payment_type.is_main
            @pushed_main_bank_drafts[@bank_draft_date].blank? ? @pushed_main_bank_drafts[@bank_draft_date] = [@bank_draft.id] : @pushed_main_bank_drafts[@bank_draft_date] << @bank_draft.id

            @main_receipt_adjustments[@bank_draft_date].blank? ? @main_receipt_adjustments[@bank_draft_date] = [receipt_adjustment] : @main_receipt_adjustments[@bank_draft_date] << receipt_adjustment
        else
            @pushed_bank_drafts[@bank_draft_date].blank? ? @pushed_bank_drafts[@bank_draft_date] = [@bank_draft.id] : @pushed_bank_drafts[@bank_draft_date] << @bank_draft.id

            @receipt_adjustments[@bank_draft_date].blank? ? @receipt_adjustments[@bank_draft_date] = [receipt_adjustment] : @receipt_adjustments[@bank_draft_date] << receipt_adjustment
        end
    end

    def generate_ipay88

        if @ipay.document_number.blank?
            @ipay.update_document_number
        end

        if @is_insurance_recognized == '1'
            bank_receipt_amount = @ipay.amount.try(:to_f)
        else
            ## need to change to ipay amount minus insurance amount
            if ((ENV['IPAY88_PRODUCTION'] || '1') == '1')
                bank_receipt_amount = (@ipay.amount - @order_items.get_insurance_fee.sum(&:amount)).try(:to_f)
            else
                bank_receipt_amount = @order_items.exclude_insurance_fee.sum(&:amount)  # for UAT
            end
        end

        reference_desc = @payment_type.name.upcase

        # split convenient fee from main payment
        amount_without_sub_fee = @order_items.exclude_insurance_fee.exclude_convenient_fee.sum(&:amount) || 0
        convenient_fee = @order_items.get_convenient_fee.sum(&:amount) || 0

        misc_receipts = []

        if amount_without_sub_fee > 0
            if @order_items.get_agency_registration_fee.sum(&:amount) > 0
                account_number = FinanceSetting.get_value("COLLECTION_#{@ipay.order.organization&.code}_AGENCY_REGIS")
            elsif @order_items.get_agency_renewal_fee.sum(&:amount) > 0
                account_number = FinanceSetting.get_value("COLLECTION_#{@ipay.order.organization&.code}_AGENCY_RENEW")
            else
                account_number = FinanceSetting.get_value("COLLECTION_#{@ipay.order.organization&.code}")
            end

            misc_receipts << {
                DistributionCode: '',
                AccountNumber: account_number,
                DistributionAmount: amount_without_sub_fee.try(:to_f),
                GLReference: reference_desc
            }
        end

        if convenient_fee > 0
            misc_receipts << {
                DistributionCode: '',
                AccountNumber: FinanceSetting.get_value("COLLECTION_#{@ipay.order.organization&.code}_CF"),
                DistributionAmount: convenient_fee.try(:to_f),
                GLReference: reference_desc
            }
        end

        if @is_insurance_recognized == '1'
            insurance_fee = @order_items.get_insurance_fee.sum(&:amount) || 0
            if insurance_fee > 0
                misc_receipts << {
                    DistributionCode: '',
                    AccountNumber: FinanceSetting.get_value("COLLECTION_#{@ipay.order.organization&.code}_INS"),
                    DistributionAmount: insurance_fee.try(:to_f),
                    GLReference: reference_desc
                }
                @insurance_collected_arr += @order_items.get_insurance_fee.pluck(:id)
            end
        end

        receipt_adjustment = {
            CheckReceiptNumber: "#{@ipay_response&.transaction_id.sub! 'T',''}",  #20201231 requested by finance to remove T
            CustomerNumber: '',
            Payer: @order.code,
            ReceiptDateAdjustmentDate: "#{@order.paid_at.try(:to_date)}#{@utc_time_format}",
            PostingDate: "#{@order.paid_at.try(:to_date)}#{@utc_time_format}",
            EntryDescription: @description.upcase,
            EntryReference: reference_desc,
            BankReceiptAmount: bank_receipt_amount.try(:to_f),
            PaymentCode: @order&.payment_method&.payment_code,
            MatchingDocumentNumber: @ipay.document_number,
            ReceiptTransactionType: 'MiscellaneousReceipt',
            MiscellaneousReceipts: misc_receipts
        }

        @pushed_main_ipays[@ipay_date].blank? ? @pushed_main_ipays[@ipay_date] = [@ipay.id] : @pushed_main_ipays[@ipay_date] << @ipay.id

        if bank_receipt_amount > 0
            if @payment_type.is_main
                @main_receipt_adjustments[@ipay_date].blank? ? @main_receipt_adjustments[@ipay_date] = [receipt_adjustment] : @main_receipt_adjustments[@ipay_date] << receipt_adjustment
            else
                @receipt_adjustments[@ipay_date].blank? ? @receipt_adjustments[@ipay_date] = [receipt_adjustment] : @receipt_adjustments[@ipay_date] << receipt_adjustment
            end
        end
    end

    def generate_swipe
        if @swipe.document_number.blank?
            @swipe.update_document_number
        end

        if @is_insurance_recognized == '1'
            bank_receipt_amount = @swipe.amount.try(:to_f)
        else
            ## need to change to swipe amount minus insurance amount
            if ((ENV['SWIPE_PRODUCTION'] || '1') == '1')
                bank_receipt_amount = (@swipe.amount - @order_items.get_insurance_fee.sum(&:amount)).try(:to_f)
            else
                bank_receipt_amount = @order_items.exclude_insurance_fee.sum(&:amount)  # for UAT
            end
        end

        reference_desc = @payment_type.name.upcase

        # split convenient fee from main payment
        amount_without_sub_fee = @order_items.exclude_insurance_fee.exclude_convenient_fee.sum(&:amount) || 0
        convenient_fee = @order_items.get_convenient_fee.sum(&:amount) || 0

        misc_receipts = []

        if amount_without_sub_fee > 0
            if @order_items.get_agency_registration_fee.sum(&:amount) > 0
                account_number = FinanceSetting.get_value("COLLECTION_#{@swipe.order.organization&.code}_AGENCY_REGIS")
            elsif @order_items.get_agency_renewal_fee.sum(&:amount) > 0
                account_number = FinanceSetting.get_value("COLLECTION_#{@swipe.order.organization&.code}_AGENCY_RENEW")
            else
                account_number = FinanceSetting.get_value("COLLECTION_#{@swipe.order.organization&.code}")
            end

            misc_receipts << {
                DistributionCode: '',
                AccountNumber: account_number,
                DistributionAmount: amount_without_sub_fee.try(:to_f),
                GLReference: reference_desc
            }
        end

        if convenient_fee > 0
            misc_receipts << {
                DistributionCode: '',
                AccountNumber: FinanceSetting.get_value("COLLECTION_#{@swipe.order.organization&.code}_CF"),
                DistributionAmount: convenient_fee.try(:to_f),
                GLReference: reference_desc
            }
        end

        if @is_insurance_recognized == '1'
            insurance_fee = @order_items.get_insurance_fee.sum(&:amount) || 0
            if insurance_fee > 0
                misc_receipts << {
                    DistributionCode: '',
                    AccountNumber: FinanceSetting.get_value("COLLECTION_#{@swipe.order.organization&.code}_INS"),
                    DistributionAmount: insurance_fee.try(:to_f),
                    GLReference: reference_desc
                }
                @insurance_collected_arr += @order_items.get_insurance_fee.pluck(:id)
            end
        end

        receipt_adjustment = {
            CheckReceiptNumber: @swipe_response&.transaction_id,
            CustomerNumber: '',
            Payer: @order.code,
            ReceiptDateAdjustmentDate: "#{@order.paid_at.try(:to_date)}#{@utc_time_format}",
            PostingDate: "#{@order.paid_at.try(:to_date)}#{@utc_time_format}",
            EntryDescription: @description.upcase,
            EntryReference: reference_desc,
            BankReceiptAmount: bank_receipt_amount.try(:to_f),
            PaymentCode: @order&.payment_method&.payment_code,
            MatchingDocumentNumber: @swipe.document_number,
            ReceiptTransactionType: 'MiscellaneousReceipt',
            MiscellaneousReceipts: misc_receipts
        }

        if @payment_type.is_main
            @pushed_main_swipes[@swipe_date].blank? ? @pushed_main_swipes[@swipe_date] = [@swipe.id] : @pushed_main_swipes[@swipe_date] << @swipe.id

            if bank_receipt_amount > 0
                @main_receipt_adjustments[@swipe_date].blank? ? @main_receipt_adjustments[@swipe_date] = [receipt_adjustment] : @main_receipt_adjustments[@swipe_date] << receipt_adjustment
            end
        else
            @pushed_swipes[@swipe_date].blank? ? @pushed_swipes[@swipe_date] = [@swipe.id] : @pushed_swipes[@swipe_date] << @swipe.id

            if bank_receipt_amount > 0
                @swipe_receipt_adjustments[@swipe_date].blank? ? @swipe_receipt_adjustments[@swipe_date] = [receipt_adjustment] : @swipe_receipt_adjustments[@swipe_date] << receipt_adjustment
            end
        end
    end

    def generate_fpx
        if @fpx.document_number.blank?
            @fpx.update_document_number
        end

        # always recognize insurance for FPX
        if @is_insurance_recognized == '1'
            bank_receipt_amount = @fpx.txn_amount.try(:to_f)
        else
            ## need to change to fpx amount minus insurance amount
            # bank_receipt_amount = (@fpx.txn_amount - @order_items.get_insurance_fee.sum(&:amount)).try(:to_f)

            ## change to push exact amount collected regardless is insurance or not (requested by finance)
            bank_receipt_amount = @fpx.txn_amount.try(:to_f)
        end

        reference_desc = @payment_type.name.upcase

        # split convenient fee from main payment
        # amount_without_sub_fee = @order_items.exclude_insurance_fee.exclude_convenient_fee.sum(&:amount) || 0
        amount_without_sub_fee = @order_items.exclude_convenient_fee.sum(&:amount) || 0
        convenient_fee = @order_items.get_convenient_fee.sum(&:amount) || 0

        misc_receipts = []

        if amount_without_sub_fee > 0
            if @order_items.get_agency_registration_fee.sum(&:amount) > 0
                account_number = FinanceSetting.get_value("COLLECTION_#{@fpx.order.organization&.code}_AGENCY_REGIS")
            elsif @order_items.get_agency_renewal_fee.sum(&:amount) > 0
                account_number = FinanceSetting.get_value("COLLECTION_#{@fpx.order.organization&.code}_AGENCY_RENEW")
            else
                account_number = FinanceSetting.get_value("COLLECTION_#{@fpx.order.organization&.code}")
            end

            misc_receipts << {
                DistributionCode: '',
                AccountNumber: account_number,
                DistributionAmount: amount_without_sub_fee.try(:to_f),
                GLReference: reference_desc
            }
        end

        if convenient_fee > 0
            misc_receipts << {
                DistributionCode: '',
                AccountNumber: FinanceSetting.get_value("COLLECTION_#{@fpx.order.organization&.code}_CF"),
                DistributionAmount: convenient_fee.try(:to_f),
                GLReference: reference_desc
            }
        end

        # if @is_insurance_recognized == '1'
        #     insurance_fee = @order_items.get_insurance_fee.sum(&:amount) || 0
        #     if insurance_fee > 0
        #         misc_receipts << {
        #             DistributionCode: '',
        #             AccountNumber: FinanceSetting.get_value("COLLECTION_#{@fpx.order.organization&.code}_INS"),
        #             DistributionAmount: insurance_fee.try(:to_f),
        #             GLReference: reference_desc
        #         }
        #         @insurance_collected_arr += @order_items.get_insurance_fee.pluck(:id)
        #     end
        # end

        receipt_adjustment = {
            CheckReceiptNumber: @fpx_response&.fpx_txn_id[-12..-1] || @fpx_response&.fpx_txn_id,
            CustomerNumber: '',
            Payer: @order.code,
            ReceiptDateAdjustmentDate: "#{@order.paid_at.try(:to_date)}#{@utc_time_format}",
            PostingDate: "#{@order.paid_at.try(:to_date)}#{@utc_time_format}",
            EntryDescription: @description.upcase,
            EntryReference: reference_desc,
            BankReceiptAmount: bank_receipt_amount.try(:to_f),
            PaymentCode: @order&.payment_method&.payment_code,
            MatchingDocumentNumber: @fpx.document_number,
            ReceiptTransactionType: 'MiscellaneousReceipt',
            MiscellaneousReceipts: misc_receipts
        }

        if @payment_type.is_main
            @pushed_main_fpxs[@fpx_date].blank? ? @pushed_main_fpxs[@fpx_date] = [@fpx.id] : @pushed_main_fpxs[@fpx_date] << @fpx.id

            if bank_receipt_amount > 0
                @main_receipt_adjustments[@fpx_date].blank? ? @main_receipt_adjustments[@fpx_date] = [receipt_adjustment] : @main_receipt_adjustments[@fpx_date] << receipt_adjustment
            end
        else
            @pushed_fpxs[@fpx_date].blank? ? @pushed_fpxs[@fpx_date] = [@fpx.id] : @pushed_fpxs[@fpx_date] << @fpx.id

            if bank_receipt_amount > 0
                @fpx_receipt_adjustments[@fpx_date].blank? ? @fpx_receipt_adjustments[@fpx_date] = [receipt_adjustment] : @fpx_receipt_adjustments[@fpx_date] << receipt_adjustment
            end
        end
    end

    def generate_boleh
        if @boleh.document_number.blank?
            @boleh.update_document_number
        end

        # always recognize insurance for BolehPay
        if @is_insurance_recognized == '1'
            bank_receipt_amount = @boleh.amount.try(:to_f)
        else
            bank_receipt_amount = @boleh.amount.try(:to_f)
        end

        reference_desc = @payment_type.name.upcase

        # split convenient fee from main payment
        # amount_without_sub_fee = @order_items.exclude_insurance_fee.exclude_convenient_fee.sum(&:amount) || 0
        amount_without_sub_fee = @order_items.exclude_convenient_fee.sum(&:amount) || 0
        convenient_fee = @order_items.get_convenient_fee.sum(&:amount) || 0

        misc_receipts = []

        if amount_without_sub_fee > 0
            if @order_items.get_agency_registration_fee.sum(&:amount) > 0
                account_number = FinanceSetting.get_value("COLLECTION_#{@boleh.order.organization&.code}_AGENCY_REGIS")
            elsif @order_items.get_agency_renewal_fee.sum(&:amount) > 0
                account_number = FinanceSetting.get_value("COLLECTION_#{@boleh.order.organization&.code}_AGENCY_RENEW")
            else
                account_number = FinanceSetting.get_value("COLLECTION_#{@boleh.order.organization&.code}")
            end

            misc_receipts << {
                DistributionCode: '',
                AccountNumber: account_number,
                DistributionAmount: amount_without_sub_fee.try(:to_f),
                GLReference: reference_desc
            }
        end

        if convenient_fee > 0
            if @boleh.order.category == "FOREIGN_WORKER_GENDER_AMENDMENT"
                # Since the order's branch for FOREIGN_WORKER_GENDER_AMENDMENT = Transaction registered branch, default to PT
                # as the order is created in portal. Do not use @boleh.order.organization&.code.
                account_number = FinanceSetting.get_value("COLLECTION_PT_CF_BOLEHPAY")
            else
                account_number = FinanceSetting.get_value("COLLECTION_#{@boleh.order.organization&.code}_CF_BOLEHPAY")
            end

            misc_receipts << {
                DistributionCode: '',
                AccountNumber: account_number,
                DistributionAmount: convenient_fee.try(:to_f),
                GLReference: reference_desc
            }
        end

        # if @is_insurance_recognized == '1'
        #     insurance_fee = @order_items.get_insurance_fee.sum(&:amount) || 0
        #     if insurance_fee > 0
        #         misc_receipts << {
        #             DistributionCode: '',
        #             AccountNumber: FinanceSetting.get_value("COLLECTION_#{@boleh.order.organization&.code}_INS"),
        #             DistributionAmount: insurance_fee.try(:to_f),
        #             GLReference: reference_desc
        #         }
        #         @insurance_collected_arr += @order_items.get_insurance_fee.pluck(:id)
        #     end
        # end

        receipt_adjustment = {
            CheckReceiptNumber: @boleh_response&.transaction_id,
            CustomerNumber: '',
            Payer: @order.code,
            ReceiptDateAdjustmentDate: "#{@order.paid_at.try(:to_date)}#{@utc_time_format}",
            PostingDate: "#{@order.paid_at.try(:to_date)}#{@utc_time_format}",
            EntryDescription: @description.upcase,
            EntryReference: reference_desc,
            BankReceiptAmount: bank_receipt_amount.try(:to_f),
            PaymentCode: @order&.payment_method&.payment_code,
            MatchingDocumentNumber: @boleh.document_number,
            ReceiptTransactionType: 'MiscellaneousReceipt',
            MiscellaneousReceipts: misc_receipts
        }

        if @payment_type.is_main
            @pushed_main_bolehs[@boleh_date].blank? ? @pushed_main_bolehs[@boleh_date] = [@boleh.id] : @pushed_main_bolehs[@boleh_date] << @boleh.id

            if bank_receipt_amount > 0
                @main_receipt_adjustments[@boleh_date].blank? ? @main_receipt_adjustments[@boleh_date] = [receipt_adjustment] : @main_receipt_adjustments[@boleh_date] << receipt_adjustment
            end
        else
            @pushed_bolehs[@boleh_date].blank? ? @pushed_bolehs[@boleh_date] = [@boleh.id] : @pushed_bolehs[@boleh_date] << @boleh.id

            if bank_receipt_amount > 0
                @boleh_receipt_adjustments[@boleh_date].blank? ? @boleh_receipt_adjustments[@boleh_date] = [receipt_adjustment] : @boleh_receipt_adjustments[@boleh_date] << receipt_adjustment
            end
        end
    end

    def generate_order_payment
        misc_receipts = []
        order_payment = @order.latest_order_payment
        account_number = ''
        branch_code = ''

        if order_payment.document_number.blank?
            order_payment.update_document_number
        end

        if ['Employer', 'Agency'].include? @order.customerable_type
            account_number = FinanceSetting.get_value("COLLECTION_#{@order.organization&.code}")
            branch_code = @order.organization&.code
        else
            if ['DOCTOR_REGISTRATION','LABORATORY_REGISTRATION','XRAY_FACILITY_REGISTRATION','RADIOLOGIST_REGISTRATION'].include?(@order.category)
                account_number = FinanceSetting.get_value("REVENUE_REG_#{@order.customerable_type.upcase}")
            elsif ['DOCTOR_CHANGE_ADDRESS','LABORATORY_CHANGE_ADDRESS','XRAY_FACILITY_CHANGE_ADDRESS'].include?(@order.category)
                account_number = FinanceSetting.get_value("REVENUE_CHANGE_CLINIC_ADDRESS")
            elsif ['DOCTOR_BIOMETRIC_DEVICE','XRAY_FACILITY_BIOMETRIC_DEVICE'].include?(@order.category)
                biometric_device_account_number = FinanceSetting.get_value("REVENUE_BIOMETRIC_DEVICE")
                biometric_admin_account_number = FinanceSetting.get_value("REVENUE_BIOMETRIC_ADMIN")
            end
            branch_code = 'HQ'
        end

        if @payment_type.code == 'CIMB_CLICKS'
            reference_desc = "CIMB CLICKS ISSUED DATE: #{order_payment&.issue_date.try(:strftime,'%d/%m/%Y')}"
            receipt_number = order_payment.reference
        elsif @payment_type.code == 'OCBC_DUITNOW_QR'
            reference_desc = "#{@order.payment_method.name}".upcase
            receipt_number = "#{branch_code}-#{order_payment.reference}"
        else
            reference_desc = "#{@order.payment_method.name}".upcase
            receipt_number = order_payment.reference
        end

        if ['DOCTOR_BIOMETRIC_DEVICE','XRAY_FACILITY_BIOMETRIC_DEVICE'].include?(@order.category)
            biometric_device_fee = @order_items.get_biometric_device_fee.sum(&:amount) || 0
            biometric_admin_fee = @order_items.get_biometric_admin_fee.sum(&:amount) || 0

            misc_receipts << {
                DistributionCode: '',
                AccountNumber: biometric_device_account_number,
                DistributionAmount: biometric_device_fee.try(:to_f),
                GLReference: reference_desc
            }
            misc_receipts << {
                DistributionCode: '',
                AccountNumber: biometric_admin_account_number,
                DistributionAmount: biometric_admin_fee.try(:to_f),
                GLReference: reference_desc
            }
        else
            misc_receipts << {
                DistributionCode: '',
                AccountNumber: account_number,
                DistributionAmount: order_payment.amount.try(:to_f),
                GLReference: reference_desc
            }
        end

        receipt_adjustment = {
            CheckReceiptNumber: receipt_number,
            CustomerNumber: '',
            Payer: '',
            ReceiptDateAdjustmentDate: "#{@order.paid_at.try(:to_date)}#{@utc_time_format}",
            PostingDate: "#{@order.paid_at.try(:to_date)}#{@utc_time_format}",
            EntryDescription: @description.upcase,
            EntryReference: reference_desc,
            BankReceiptAmount: order_payment.amount.try(:to_f),
            PaymentCode: @payment_code,
            MatchingDocumentNumber: order_payment.document_number,
            ReceiptTransactionType: 'MiscellaneousReceipt',
            MiscellaneousReceipts: misc_receipts
            # MiscellaneousReceipts: [{
            #     DistributionCode: '',
            #     AccountNumber: account_number,
            #     DistributionAmount: order_payment.amount.try(:to_f),
            #     GLReference: reference_desc
            # }]
        }

        if @payment_type.is_main
            @pushed_main_order_payments[@order_payment_date].blank? ? @pushed_main_order_payments[@order_payment_date] = [order_payment.id] : @pushed_main_order_payments[@order_payment_date] << order_payment.id

            @main_receipt_adjustments[@order_payment_date].blank? ? @main_receipt_adjustments[@order_payment_date] = [receipt_adjustment] : @main_receipt_adjustments[@order_payment_date] << receipt_adjustment
        elsif @payment_type.code == 'CIMB_CLICKS'
            @pushed_cimb_order_payments[@order_payment_date].blank? ? @pushed_cimb_order_payments[@order_payment_date] = [order_payment.id] : @pushed_cimb_order_payments[@order_payment_date] << order_payment.id

            @cimb_receipt_adjustments[@order_payment_date].blank? ? @cimb_receipt_adjustments[@order_payment_date] = [receipt_adjustment] : @cimb_receipt_adjustments[@order_payment_date] << receipt_adjustment
        elsif @payment_type.code.include?('SWIPE')
            @pushed_swipe_order_payments[@order_payment_date].blank? ? @pushed_swipe_order_payments[@order_payment_date] = [order_payment.id] : @pushed_swipe_order_payments[@order_payment_date] << order_payment.id

            @swipe_receipt_adjustments[@order_payment_date].blank? ? @swipe_receipt_adjustments[@order_payment_date] = [receipt_adjustment] : @swipe_receipt_adjustments[@order_payment_date] << receipt_adjustment
        elsif @payment_type.code.include?('PAYNET')
            @pushed_fpx_order_payments[@order_payment_date].blank? ? @pushed_fpx_order_payments[@order_payment_date] = [order_payment.id] : @pushed_fpx_order_payments[@order_payment_date] << order_payment.id

            @fpx_receipt_adjustments[@order_payment_date].blank? ? @fpx_receipt_adjustments[@order_payment_date] = [receipt_adjustment] : @fpx_receipt_adjustments[@order_payment_date] << receipt_adjustment
        elsif @payment_type.code.include?('BOLEH')
            @pushed_boleh_order_payments[@order_payment_date].blank? ? @pushed_boleh_order_payments[@order_payment_date] = [order_payment.id] : @pushed_boleh_order_payments[@order_payment_date] << order_payment.id

            @boleh_receipt_adjustments[@order_payment_date].blank? ? @boleh_receipt_adjustments[@order_payment_date] = [receipt_adjustment] : @boleh_receipt_adjustments[@order_payment_date] << receipt_adjustment
        else
            @pushed_order_payments[@order_payment_date].blank? ? @pushed_order_payments[@order_payment_date] = [order_payment.id] : @pushed_order_payments[@order_payment_date] << order_payment.id

            @receipt_adjustments[@order_payment_date].blank? ? @receipt_adjustments[@order_payment_date] = [receipt_adjustment] : @receipt_adjustments[@order_payment_date] << receipt_adjustment
        end
    end

end
