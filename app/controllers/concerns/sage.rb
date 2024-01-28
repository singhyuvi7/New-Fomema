module Sage
    require 'rest-client'

    # service provider payment and refunds
    def ap_invoice_batches
        @method = 'APInvoiceBatches'
        @url = @ap_invoice_batches_type == 'P' ? ENV['SAGE_CUSTOM_APINVOICEBATCH_URL'] : generate_url('ap',@method)

        response = request_call
        @is_success = true
        error_msg = nil

        # response.code
        if response == false
            @is_success = false
        else
            response_code = response.code
            if !(['200','201',200,201].include? response_code)
                @is_success = false
            else
                # success
                if !response.body.blank?
                    response_details = JSON.parse(response.body)
                    sp_type = nil

                    if @ap_invoice_batches_type == 'P'
                        batch_number = response_details['APInvoiceBatchesResult']['BatchNumber']
                        batchable = @batch

                        number_of_entries = response_details['APInvoiceBatchesResult']['NumberOfEntries']
                        number_of_errors = response_details['APInvoiceBatchesResult']['NumberOfErrors']
                        if number_of_errors > 0 || number_of_entries <= 0
                            @is_success = false
                            error_msg = response_details['APInvoiceBatchesResult']['Message']
                        end
                    else
                        batch_number = response_details['BatchNumber']
                        batchable = @payment_details
                    end

                    if !batch_number.blank?
                        ApInvoiceBatch.create({
                            batch_number: batch_number,
                            batchable: batchable,
                            service_provider_type: @service_provider_type,
                            remark: error_msg
                        })
                    end
                end
            end
        end
    end

    # collection
    def receipt_adjustment_batches
        @method = 'ARReceiptAndAdjustmentBatches'
        @url = generate_url('ar',@method)

        response = request_call
        @is_success = true

        # response.code
        if response == false
            @is_success = false
        else
            response_code = response.code
            if !(response_code == 200 || response_code == 201)
                @is_success = false
            end
        end

        if @is_success == true
            if !@bank_draft_ids.blank?
                BankDraft.where(:id => @bank_draft_ids).update_all(sync_date: DateTime.now)
            end

            if !@order_payment_ids.blank?
                OrderPayment.where(:id => @order_payment_ids).update_all(sync_date: DateTime.now)
            end

            if !@ipay_ids.blank?
                Ipay88Request.where(:id => @ipay_ids).update_all(sync_date: DateTime.now)
            end

            if !@swipe_ids.blank?
                SwipeRequest.where(:id => @swipe_ids).update_all(sync_date: DateTime.now)
            end

            if !@fpx_ids.blank?
                FpxRequest.where(:id => @fpx_ids).update_all(sync_date: DateTime.now)
            end

            if !@boleh_ids.blank?
                BolehRequest.where(:id => @boleh_ids).update_all(sync_date: DateTime.now)
            end

            if !@refund_ids.blank?
                Refund.where(:id => @refund_ids).update_all(sync_date: DateTime.now)
            end

            if !@insurance_collected_arr.blank?
                InsurancePurchase.where(:order_item_id => @insurance_collected_arr).update_all(is_collection: true)
            end
        end
    end

    def gl_journal_batches
        @method = 'GLJournalBatches'
        @url = generate_url('gl',@method)

        response = request_call
        @is_success = true

        # response.code
        if response == false
            @is_success = false
        else
            response_code = response.code
            if !(response_code == 200 || response_code == 201)
                @is_success = false
            end
        end
    end

    def ap_vendors(is_from_refund)

        if is_from_refund

            @method = 'APVendors'
            @url = generate_url('ap',@method)
            insert_response = request_call

            @method = "APVendors('#{@vendor_number}')"
            @url = generate_url('ap',@method)
            encoded_url = URI.encode(@url)
            @url = URI.parse(encoded_url)
            update_response = request_patch

        else
            @method = @vendor_status == 'NEW_APPROVED' ? 'APVendors' : "APVendors('#{@vendor_number}')"
            @url = generate_url('ap',@method)

            if @vendor_status == 'NEW_APPROVED'
                response = request_call
            else
                encoded_url = URI.encode(@url)
                @url = URI.parse(encoded_url)
                response = request_patch
            end

            @is_success = true

            if response == false
                @is_success = false
            else
                response_code = response.code.try(:to_i)
                if !(response_code == 200 || response_code == 201)
                    @is_success = false
                end
            end
        end
    end

    # void collection
    def payment_adjustment_batches
        @method = 'APPaymentAndAdjustmentBatches'
        @url = generate_url('ap',@method)

        response = request_call
        @is_success = true

        # response.code
        if response == false
            @is_success = false
        else
            response_code = response.code
            if !(response_code == 200 || response_code == 201)
                @is_success = false
            end
        end

        if @is_success == true
            if !@bank_draft_ids.blank?
                BankDraft.where(:id => @bank_draft_ids).update_all(sync_bad_date: DateTime.now)
            end

            if !@order_payment_ids.blank?
                OrderPayment.where(:id => @order_payment_ids).update_all(sync_bad_date: DateTime.now)
            end
        end
    end

    ### API END ###

    # sp payment auto
    def submit_payment (sp_fin_batches)
        log_api('SUBMIT_PAYMENT', '', '', '', '')

        @ap_invoice_batches_type = 'P'
        utc_time_format = "T00:00:00.000Z"
        start_date = @batch.start_date.strftime('%d/%m/%Y')
        end_date = @batch.end_date.strftime('%d/%m/%Y')
        service_provider_types = ['Doctor','XrayFacility','Laboratory']
        doctor_invoices = []
        xray_invoices = []
        lab_invoices = []
        posted_doctors = []
        posted_xrays = []
        posted_labs = []

        sp_fin_batches.try(:each) do |sp_fin_batch|

            service_provider = sp_fin_batch.batchable
            service_provider_type = sp_fin_batch.batchable_type
            if service_provider_type == 'ServiceProviderGroup'
                group_string = "#{service_provider.category.constantize.model_name.human} Group"
                gl_code_group_string = "GROUP"
            else
                group_string = "#{service_provider_type.constantize.model_name.human} Non-Group"
                gl_code_group_string = "NON_GROUP"
            end

            description = "#{group_string} - #{service_provider.state&.name} : #{start_date}-#{end_date}".upcase

            vendor_number = service_provider.code
            document_type = 'Invoice'

            sp_fin_batch&.sp_fin_batch_items.try(:each) do |sp_fin_batch_item|

                if sp_fin_batch_item.document_number.blank?
                    sp_fin_batch_item.update_document_number
                end

                # can reuse document number. tbc?
                # if sp_fin_batch.status == 'FAILED'
                #     sp_fin_batch_item.update_document_number
                # end

                transaction = sp_fin_batch_item.transactionz
                certification_date = transaction&.certification_date
                amount = sp_fin_batch_item.amount.try(:to_f)
                itemable_type = sp_fin_batch_item.itemable_type

                invoice = {
                    VendorNumber: service_provider.code,
                    DocumentNumber: sp_fin_batch_item.document_number,
                    DocumentType: document_type,
                    OrderNumber: transaction&.fw_code,
                    InvoiceDescription: description,
                    DocumentDate: "#{certification_date.try(:to_date)}#{utc_time_format}",
                    PostingDate: "#{certification_date.try(:to_date)}#{utc_time_format}",
                    DueDate: "#{certification_date.try(:next_day,30).try(:to_date)}#{utc_time_format}",
                    DocumentTotalIncludingTax: amount,
                    InvoiceDetails: [
                        {
                            DistributionCode: '',
                            DistributionDescription: '',
                            GLAccount: FinanceSetting.get_value("PAYMENT_#{sp_fin_batch_item.itemable_type.upcase}_#{service_provider.state&.code}_#{transaction&.fw_gender}_#{gl_code_group_string}"),
                            DistributedAmount: amount,
                            Comment: ''
                        }
                    ],
                    InvoiceOptionalFields: [
                        {
                            OptionalField: "WORKERNAME",
                            Value: transaction&.fw_name
                        },{
                            OptionalField: "WORKERGENDER",
                            Value: transaction&.fw_gender
                        },{
                            OptionalField: "DOCTORCODE",
                            Value: sp_fin_batch_item.itemable.code
                        },{
                            OptionalField: "DOCTORNAME",
                            Value: itemable_type == 'XrayFacility' ? sp_fin_batch_item.itemable.license_holder_name : sp_fin_batch_item.itemable.name
                        },{
                            OptionalField: "WORKERCODE",
                            Value: transaction&.fw_code
                        },{
                            OptionalField: "CLINICNAME",
                            Value: itemable_type == 'Doctor' ? sp_fin_batch_item.itemable.clinic_name : sp_fin_batch_item.itemable.name
                        },{
                            OptionalField: "CERTDATE",
                            Value: transaction&.certification_date.strftime("%Y%m%d")
                        },{
                            OptionalField: "TRANSID",
                            Value: transaction&.code
                        }
                    ]
                }

                case itemable_type
                when 'Doctor'
                    doctor_invoices << invoice
                    posted_doctors << sp_fin_batch.id
                when 'XrayFacility'
                    xray_invoices << invoice
                    posted_xrays << sp_fin_batch.id
                when 'Laboratory'
                    lab_invoices << invoice
                    posted_labs << sp_fin_batch.id
                end
            end
        end

        service_provider_types.each do |service_provider_type|
            invoices = []
            posted_ids = []
            case service_provider_type
            when 'Doctor'
                invoices = doctor_invoices
                posted_ids = posted_doctors
            when 'XrayFacility'
                invoices = xray_invoices
                posted_ids = posted_xrays
            when 'Laboratory'
                invoices = lab_invoices
                posted_ids = posted_labs
            end

            if !invoices.blank?
                @service_provider_type = service_provider_type
                invoices = invoices.each_slice(5000)
                invoices.each.with_index(1) do |invoice,index|
                    head_description = "#{service_provider_type.constantize.model_name.human} : #{start_date}-#{end_date} (#{index})".upcase

                    @request_content = {
                        Description: head_description,
                        Invoices: invoice
                    }

                    ap_invoice_batches
                    break if !@is_success
                end

                if @is_success
                    SpFinBatch.where(id: posted_ids).update_all(status: 'PENDING')
                else
                    SpFinBatch.where(id: posted_ids).update_all(status: 'PROCESS_FAILED')
                end
            end

        end
    end

    # refund
    def submit_refund (refund)
        @payment_details = refund
        @ap_invoice_batches_type = 'R'
        submit_vendor(refund.customerable,true)

        utc_time_format = "T00:00:00.000Z"
        customer = refund.customerable
        description = "Refund - #{Refund::CATEGORIES[refund.category]}".upcase

        # if refund.document_number.blank?
        #     refund.update_document_number
        # end

        vendor_number = customer.code
        document_type = 'Invoice'
        document_number = refund.code
        invoice_description = "#{customer.name} - Refund to #{refund.customerable_type}".upcase
        document_date = refund.approval_at.present? ? refund.approval_at : refund.created_at
        posting_date = document_date
        due_date = document_date
        amount = refund.amount.try(:to_f)

        @request_content = {
            Description: description,
            Invoices: [{
                VendorNumber: vendor_number,
                DocumentNumber: document_number,
                DocumentType: document_type,
                OrderNumber: '',
                InvoiceDescription: invoice_description,
                DocumentDate: "#{document_date.try(:to_date)}#{utc_time_format}",
                PostingDate: "#{posting_date.try(:to_date)}#{utc_time_format}",
                DueDate: "#{due_date.try(:next_day,30).try(:to_date)}#{utc_time_format}",
                DocumentTotalIncludingTax: amount,
                InvoiceDetails: [
                    {
                        DistributionCode: '',
                        DistributionDescription: '',
                        GLAccount: FinanceSetting.get_value("REFUND_#{refund.organization&.code}"),
                        DistributedAmount: amount,
                        Comment: ''
                    }
                ]
            }]
        }

        ap_invoice_batches

        if @is_success
            refund.status = 'PENDING_PAYMENT'
            refund.save!
        end
    end

    ## batch refund
    def submit_refund_batch(refund_batch_id)
        refund_batch = RefundBatch.find(refund_batch_id)
        @payment_details = refund_batch
        start_date = refund_batch.start_date.strftime('%d/%m/%Y')
        end_date = refund_batch.end_date.strftime('%d/%m/%Y')

        @refunds = refund_batch.refunds
        @ap_invoice_batches_type = 'R'
        utc_time_format = "T00:00:00.000Z"
        document_type = 'Invoice'

        invoices = []
        description = "Refund : #{start_date}-#{end_date}".upcase

        @refunds.each do |refund|
            submit_vendor(refund.customerable,true)
            customer = refund.customerable

            vendor_number = customer.code
            document_number = refund.code

            invoice_description = "Refund - #{Refund::CATEGORIES[refund.category]}".upcase

            document_date = refund.approval_at.present? ? refund.approval_at : refund.created_at
            posting_date = document_date
            due_date = document_date
            amount = refund.amount.try(:to_f)

            invoice = {
                VendorNumber: vendor_number,
                DocumentNumber: document_number,
                DocumentType: document_type,
                OrderNumber: '',
                InvoiceDescription: invoice_description,
                DocumentDate: "#{document_date.try(:to_date)}#{utc_time_format}",
                PostingDate: "#{posting_date.try(:to_date)}#{utc_time_format}",
                DueDate: "#{due_date.try(:next_day,30).try(:to_date)}#{utc_time_format}",
                DocumentTotalIncludingTax: amount,
                InvoiceDetails: [
                    {
                        DistributionCode: '',
                        DistributionDescription: '',
                        GLAccount: FinanceSetting.get_value("REFUND_#{refund.organization&.code}"),
                        DistributedAmount: amount,
                        Comment: ''
                    }
                ]
            }

            invoices << invoice
        end

        @request_content = {
            Description: description,
            Invoices: invoices
        }

        ap_invoice_batches

        if @is_success
            refund_batch.refunds.update({
                status: 'PENDING_PAYMENT'
            })
        else
            refund_batch.refunds.update({
                status: 'PROCESS_FAILED'
            })
        end
    end

    def submit_vendor (vendor,is_from_refund=false)
        model = vendor.class.name

        @vendor_number = vendor.code
        vendor_name = vendor.name
        group_code = FinanceSetting.get_value("GROUP_#{model.upcase}")
        business_registration_number = vendor.business_registration_number
        legal_name = vendor.try(:company_name)
        address_1 = vendor.address1
        address_2 = vendor.address2
        address_3 = vendor.address3
        address_4 = vendor.address4
        city = vendor.town.try(:name)
        state = vendor.state.try(:name)
        zip_postal_code = vendor.postcode
        country = vendor.country.try(:name)
        contact_name = ''
        phone_number = vendor.phone
        fax_number = vendor.try(:fax)
        email = vendor.email
        website = ''
        contact_phone = phone_number
        contact_fax = fax_number
        contact_email = email
        bank_code = ''
        bank_account_number = vendor.bank_account_number
        email_payment = ''
        payee_name = vendor.name
        new_ic_number = ''
        old_ic_number = ''
        receiving_fiid = vendor.bank.try(:routing)
        police_army_passport = ''
        bnm_code = ''
        payment_code = 'GIRO'
        bank_payment_id = vendor.try(:bank_payment_id)

        business_registration_number_opt_field = business_registration_number

        if model == 'Employer'
            legal_name = ''
            email_payment = vendor.email
            contact_name = vendor.name
            new_ic_number = vendor.ic_passport_number
            bank_code = FinanceSetting.get_value('BANK_OCBC_MAIN')

            case vendor.employer_type_id
            when 1
                new_ic_number = bank_payment_id
            when 2
                business_registration_number_opt_field = bank_payment_id
            end
        elsif model == 'Agency'
            legal_name = ''
            email_payment = vendor.email
            contact_name = vendor.name
            bank_code = FinanceSetting.get_value('BANK_OCBC_MAIN')
            business_registration_number_opt_field = bank_payment_id
        elsif model == 'ServiceProviderGroup'
            bank_code = FinanceSetting.get_value("BANK_OCBC_#{vendor.category.try(:upcase)}")
            group_code = FinanceSetting.get_value("GROUP_#{vendor.category.try(:upcase)}")
            payee_name = vendor.bank_account_holder_name
            email_payment = vendor.email_payment
            legal_name = vendor_name
            business_registration_number_opt_field = bank_payment_id
            payment_code = vendor.try(:payment_method).try(:payment_code) || 'CO'
        else
            bank_code = FinanceSetting.get_value("BANK_OCBC_#{model.try(:upcase)}")
            company_name = vendor.company_name
            email_payment = vendor.email_payment
            payment_code = vendor.try(:payment_method).try(:payment_code) || 'CO'
            payment_method_code = vendor.try(:payment_method).try(:code)

            case model
            when 'Doctor'
                contact_name = vendor.name
                legal_name = vendor.clinic_name
                payee_name = company_name.present? ? company_name : vendor_name
                new_ic_number = vendor.icno

                case payment_method_code
                when 'OUT_GIROROC'
                    new_ic_number = ''
                    business_registration_number_opt_field = bank_payment_id
                when 'OUT_GIRONEWIC'
                    new_ic_number = bank_payment_id
                    business_registration_number_opt_field = ''
                when 'OUT_GIROPASSPORT'
                    new_ic_number = ''
                    business_registration_number_opt_field = ''
                    police_army_passport = bank_payment_id
                end

            when 'XrayFacility'
                vendor_name = vendor.license_holder_name
                contact_name = vendor.license_holder_name
                legal_name = vendor.name
                payee_name = company_name.present? ? company_name : vendor_name
                new_ic_number = vendor.icno

                case payment_method_code
                when 'OUT_GIROROC'
                    new_ic_number = ''
                    business_registration_number_opt_field = bank_payment_id
                when 'OUT_GIRONEWIC'
                    new_ic_number = bank_payment_id
                    business_registration_number_opt_field = ''
                when 'OUT_GIROPASSPORT'
                    new_ic_number = ''
                    business_registration_number_opt_field = ''
                    police_army_passport = bank_payment_id
                end
            when 'Laboratory'
                contact_name = vendor.pic_name
                contact_phone = vendor.pic_phone
                legal_name = vendor_name
                payee_name = company_name.present? ? company_name : vendor_name
                business_registration_number_opt_field = bank_payment_id
            end
        end

        vendorOptionalFieldValues = [{
                OptionalField: 'C01',
                Value: bank_account_number
            }, {
                OptionalField: 'C02',
                Value: email_payment
            },
            {
                OptionalField: 'C03',
                Value: payee_name
            }, {
                OptionalField: 'G01',
                Value: new_ic_number
            }, {
                OptionalField: 'G02',
                Value: old_ic_number
            },
            {
                OptionalField: 'G03',
                Value: business_registration_number_opt_field
            }, {
                OptionalField: 'G04',
                Value: receiving_fiid
            },
            {
                OptionalField: 'G05',
                Value: police_army_passport
            }, {
                OptionalField: 'G07',
                Value: bnm_code
            }
        ]

        if payment_code == 'CO'
            vendorOptionalFieldValues += [{
                OptionalField: 'C04',
                Value: vendor.country.try(:old_code) || 'MY'
            }, {
                OptionalField: 'C05',
                Value: 'YES'
            },
            {
                OptionalField: 'O01',
                Value: 'M'
            }]
        end

        @request_content = {
            VendorNumber: @vendor_number,
            VendorName: vendor_name,
            GroupCode: group_code,
            BusinessRegistrationNumber: business_registration_number,
            LegalName: legal_name,
            AddressLine1: address_1,
            AddressLine2: address_2,
            AddressLine3: address_3,
            AddressLine4: address_4,
            City: city,
            StateProvince: state,
            ZipPostalCode: zip_postal_code,
            Country: country,
            ContactName: contact_name,
            PhoneNumber: phone_number,
            FaxNumber: fax_number,
            Email: email,
            WebSite: website,
            ContactsPhone: contact_phone,
            ContactsFax: contact_fax,
            ContactsEmail: contact_email,
            BankCode: bank_code,
            PaymentCode: payment_code,
            VendorOptionalFieldValues: vendorOptionalFieldValues
        }

        ap_vendors(is_from_refund)
    end

    def submit_special_refund_collection(refund)

        if !refund.sync_date.blank? || refund.payment_method_id.blank?
            @is_success = true
        else
            @payment_method = refund&.payment_method
            @batch_record_type = 'CA'
            @utc_time_format = "T00:00:00.000Z"

            @unutilised_draft = refund
            @unutilised_draft_date = refund.approval_at.strftime('%d/%m/%Y')

            if @payment_method.code == 'CIMB_CLICKS'
                bank_code_id = 'BANK_CIMB'
                @reference_desc = "CIMB CLICKS ISSUED DATE: #{@unutilised_draft.payment_date.try(:strftime,'%d/%m/%Y')}"
            else
                bank_code_id = 'BANK_OCBC_MAIN'
                @reference_desc = "#{@payment_method.name}".upcase
            end

            @bank_code = FinanceSetting.get_value(bank_code_id)

            generate_unutilised_draft
        end
    end

    ## insurance payment
    def submit_insurance_payment(batch_id)
        code_list = {
            "HOWDEN_CODE" => {
                "vendor_code" => SystemConfiguration.find_by(code: 'HOWDEN_CODE')&.value,
                "gl_code" => FinanceSetting.get_value("INSURANCE_PAYMENT_HOWDEN_PT")
            },
            "FGSB_CODE" => {
                "vendor_code" => SystemConfiguration.find_by(code: 'FGSB_CODE')&.value,
                "gl_code" => FinanceSetting.get_value("INSURANCE_PAYMENT_HOWDEN_PT")
            },
            "TFSB_CODE" => {
                "vendor_code" => SystemConfiguration.find_by(code: 'TFSB_CODE')&.value,
                "gl_code" => FinanceSetting.get_value("INSURANCE_PAYMENT_HOWDEN_PT")
            },
        }

        insurance_payment_batch = InsurancePaymentBatch.find(batch_id)
        @payment_details = insurance_payment_batch

        start_date = insurance_payment_batch.start_date.strftime('%d/%m/%Y')
        end_date = insurance_payment_batch.end_date.strftime('%d/%m/%Y')

        ip_invoices = insurance_payment_batch.ip_invoices
        @ap_invoice_batches_type = 'I'
        utc_time_format = "T00:00:00.000Z"
        document_type = 'Invoice'

        invoices = []
        description = "Insurance : #{start_date}-#{end_date}".upcase

        ip_invoices.order('payment_to ,payment_date ASC').each do |ip_invoice|

            if ip_invoice.document_number.blank?
                ip_invoice.update_document_number
            end

            invoice_description = "Insurance: #{ip_invoice.payment_date.strftime('%d/%m/%Y')}".upcase

            document_date = ip_invoice.payment_date
            posting_date = document_date
            due_date = document_date
            amount = ip_invoice.total_amount.try(:to_f)

            order = Order.find_by(code: ip_invoice.document_number[1..])

            invoice = {
                VendorNumber: code_list[ip_invoice.payment_to]['vendor_code'],
                DocumentNumber: ip_invoice.document_number,
                DocumentType: document_type,
                OrderNumber: '',
                InvoiceDescription: invoice_description,
                DocumentDate: "#{document_date.try(:to_date)}#{utc_time_format}",
                PostingDate: "#{posting_date.try(:to_date)}#{utc_time_format}",
                DueDate: "#{due_date.try(:next_day,30).try(:to_date)}#{utc_time_format}",
                DocumentTotalIncludingTax: amount,
                InvoiceDetails: [
                    {
                        DistributionCode: '',
                        DistributionDescription: '',
                        # GLAccount: code_list[ip_invoice.payment_to]['gl_code'],
                        GLAccount: FinanceSetting.get_value("COLLECTION_#{order.organization&.code}"),  # nios insurance enhancement - based on branch collection
                        DistributedAmount: amount,
                        Comment: ''
                    }
                ]
            }

            invoices << invoice
        end

        @request_content = {
            Description: description,
            Invoices: invoices
        }

        ap_invoice_batches

        if @is_success
            ip_invoices.update({
                status: 'SUCCESS'
            })
        else
            ip_invoices.update({
                status: 'PROCESS_FAILED'
            })
        end
    end

private
    def generate_unutilised_draft
        @refund_ids = [@unutilised_draft.id]

        if @unutilised_draft.document_number.blank?
            @unutilised_draft.update_document_number
        end

        branch_code = @unutilised_draft.organization&.code
        description = "#{@unutilised_draft&.customerable&.name} - Refund To Employer"
        convenient_fee = Fee.find_by_code(@payment_method&.code)&.amount || 0
        misc_receipts = [{
            DistributionCode: '',
            AccountNumber: FinanceSetting.get_value("COLLECTION_#{branch_code}"),
            DistributionAmount: @unutilised_draft.amount.try(:to_f),
            GLReference: @reference_desc
        }]

        if convenient_fee > 0
            if @payment_method.code.start_with?('BOLEH')
                account_number = FinanceSetting.get_value("COLLECTION_#{branch_code}_CF_BOLEHPAY")
            else
                account_number = FinanceSetting.get_value("COLLECTION_#{branch_code}_CF")
            end

            misc_receipts << {
                DistributionCode: '',
                AccountNumber: account_number,
                DistributionAmount: convenient_fee.try(:to_f),
                GLReference: @reference_desc
            }
        end

        if @payment_method.code.start_with?('PAYNET', 'BOLEH')
            check_receipt_number = @unutilised_draft&.reference[-12..-1] || @unutilised_draft&.reference
            payer = @unutilised_draft&.reference
        else
            check_receipt_number = @unutilised_draft&.reference
            payer = ''
        end

        receipt_adjustment = {
            CheckReceiptNumber: check_receipt_number,
            CustomerNumber: '',
            Payer: payer,
            ReceiptDateAdjustmentDate: "#{@unutilised_draft.approval_at.try(:to_date)}#{@utc_time_format}",
            PostingDate: "#{@unutilised_draft.approval_at.try(:to_date)}#{@utc_time_format}",
            EntryDescription: description.upcase,
            EntryReference: @reference_desc,
            BankReceiptAmount: [@unutilised_draft.amount,convenient_fee].sum.try(:to_f),
            PaymentCode: @payment_method&.payment_code,
            MatchingDocumentNumber: @unutilised_draft.document_number,
            ReceiptTransactionType: 'MiscellaneousReceipt',
            MiscellaneousReceipts: misc_receipts
        }

        head_description = "Collection from #{@bank_code} on #{@unutilised_draft_date} - Manual Refund"

        @request_content = {
            BatchRecordType: @batch_record_type,
            Description: head_description.upcase,
            BankCode: @bank_code,
            ReceiptsAdjustments: [receipt_adjustment]
        }

        receipt_adjustment_batches
    end

    def generate_url(app_module,resource)
        modules = {
            'gl' => 'GL',
            'ap' => 'AP',
            'ar' => 'AR'
        }
        url = "#{ENV['SAGE_PROTOCOL']}://#{ENV['SAGE_HOST']}/#{ENV['SAGE_APPLICATION']}/#{ENV['SAGE_VERSION']}/-/#{ENV['SAGE_COMPANY']}/"
        url += "#{modules[app_module]}/#{resource}"
        return url
    end

    def request_call
        username = ENV['SAGE_USERNAME'] || 'APIUSER'
        password = ENV['SAGE_PASSWORD'] || 'APIUSER'
        protocol = ENV['SAGE_PROTOCOL']
        sage_company = ENV['SAGE_COMPANY']
        if @ap_invoice_batches_type == 'P'
            @url = "http://47.254.229.24/APIToSage/Service1.svc/APInvoiceBatches?CompId=#{sage_company}"
        end

        log_api("ENTER_REQUEST_CALL (#{@method})", '', @url, '', '')

        begin
            response = RestClient::Request.execute(:method => :post, :url => @url,:user => username, :password => password, :payload => @request_content.to_json, :open_timeout => (ENV['SAGE_TIMEOUT'].to_i || 3600), :read_timeout => (ENV['SAGE_TIMEOUT'].to_i || 3600), :headers => {"Content-Type" => "application/json"})
        rescue RestClient::Exceptions::ReadTimeout => e
            response = false
            log_api("#{@method}", @request_content, @url, e, e.inspect)
        rescue RestClient::ExceptionWithResponse => e
            response = false
            log_api("#{@method}", @request_content, @url, e&.response, e.inspect)
        rescue => e
            response = false
            log_api("#{@method}", @request_content, @url, e, e.inspect)
        else
            log_api("#{@method}", @request_content, @url, response.body, response.to_json)
        end

        return response
    end

    def request_patch
        username = ENV['SAGE_USERNAME'] || 'APIUSER'
        password = ENV['SAGE_PASSWORD'] || 'APIUSER'
        protocol = ENV['SAGE_PROTOCOL']

        if protocol == 'http'
            header = {'Content-Type': 'application/json'}

            begin
                request = Net::HTTP::Patch.new(@url.request_uri, header)
                request.basic_auth username, password

                response = Net::HTTP.start(@url.host, @url.port) {|http|
                    request.body = @request_content.to_json
                    response = http.request(request)
                }

            log_api(@method, @request_content, @url, response.body, response.to_json)
            rescue Net::ReadTimeout => e
                response = false
                log_api(@method, @request_content, @url, e.inspect ,e)
            rescue StandardError => e
                response = false
                log_api(@method, @request_content, @url, e.inspect ,e)
            end
        else
            https = Net::HTTP.new(@url.host, @url.port);
            https.use_ssl = true
            https.verify_mode = OpenSSL::SSL::VERIFY_NONE

            request = Net::HTTP::Patch.new(@url)
            request["Content-Type"] = "application/json"
            request.basic_auth(username, password)

            form_data = [['jsondata', request_content.to_json]]
            request.set_form form_data, 'multipart/form-data'
            response = https.request(request)
        end

        return response
    end

    def log_api(method, params, url, response, full_response)
        log_data = {
            :name => self.class.name,
            :api_type => 'REST_API',
            :request_type => 'OUTGOING',
            :url => url,
            :method => method,
            :params => params,
            :response => response,
            :full_response => full_response,
        }

        api_log = ApiLog.create(log_data)
    end
end
