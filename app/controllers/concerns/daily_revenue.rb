module DailyRevenue

    def revenue
        beginning_of_day = @current.beginning_of_day
        end_of_day = @current.end_of_day

        @gl_code = ''

        genders = ['M','F']
        revenues = [
            {
                type: 'worker_registration',
                categories: ['TRANSACTION_REGISTRATION','SPECIAL_RENEWAL_TRANSACTION_REGISTRATION'],
                fee_categories: ['TRANSACTION_MALE','TRANSACTION_FEMALE'],
                by_branch: true,
                source_type: "SOURCE_TYPE_REG",
                sub_categories: ['FOREIGN_WORKER_GENDER_AMENDMENT'],
                sub_fee_categories: ['FOREIGN_WORKER_GENDER_AMENDMENT']
            },{
                type: 'worker_certification',
                by_branch: true,
                source_type: "SOURCE_TYPE_CERT"
            },{
                type: 'transaction_expired_without_examination',
                by_branch: true,
                source_type: "SOURCE_TYPE_EXPIRED"
            },{
                type: 'transaction_transmission_expired',
                by_branch: true,
                source_type: "SOURCE_TYPE_EXPIRED"
            },{
                type: 'worker_cancellation',
                categories: ['TRANSACTION_CANCELLATION'],
                by_branch: true,
                source_type: "SOURCE_TYPE_WC"
            },{
                type: 'special_renewal_rejected',
                categories: ['TRANSACTION_SPECIAL_RENEWAL_REJECT'],
                by_branch: true,
                source_type: "SOURCE_TYPE_SFSREG"
            },{
                type: 'reprint_medical_form',
                categories: ['REPRINT_MEDICAL_FORM'],
                by_branch: true,
                source_type: "SOURCE_TYPE_RM"
            },{
                type: 'change_doctor',
                categories: ['TRANSACTION_CHANGE_DOCTOR'],
                by_branch: true,
                source_type: "SOURCE_TYPE_CD",
                approval: true
            },{
                type: 'transaction_extent',
                categories: ['TRANSACTION_EXTENTION'],
                by_branch: true,
                source_type: "SOURCE_TYPE_TE"
            },{
                type: 'worker_amendment',
                categories: ['FOREIGN_WORKER_AMENDMENT'],
                by_branch: true,
                source_type: "SOURCE_TYPE_WA",
                approval: true
            }
        ]

        ## reclassification - only for draft and other payment(gender_change)
        reclassification_revenues = [
            {
                type: 'gender_amendment',
                categories: ['FOREIGN_WORKER_GENDER_AMENDMENT'],
                source_type: "SOURCE_TYPE_CG",
                gl_type: "REVENUE_CG",
                description: "Gender Change"
            }
        ]

        head_description = "Revenue #{@current.strftime('%d/%m/%Y')}"
        @journal_headers = []

        revenues.each do |revenue|
            @revenue = revenue
            @revenue_type = revenue[:type]
            @source_type = FinanceSetting.get_value(revenue[:source_type])
            # with branch
            if revenue[:by_branch]

                branches = Organization.where(:org_type => 'BRANCH')

                orders = Order.where(paid_at: beginning_of_day..end_of_day)
                .where(:category => revenue[:categories],:status => 'PAID')

                orders_without_date = Order.where(:category => revenue[:categories],:status => 'PAID')

                branches.each do |branch|
                    @rejected_orders = []

                    @description = 'Other Income'

                    if revenue[:type] == 'worker_certification'
                        @description = "Certification from Branch (#{branch.code})"

                        genders.each do |gender|
                            ## without changing gender
                            transactions = Transaction.joins(:order_item)
                            .where(certification_date: beginning_of_day..end_of_day)
                            .where(:fw_gender => gender,:organization_id => branch.id)
                            .pluck('order_items.amount')

                            ## changed gender
                            transactions_changed_gender = Transaction.joins(:order_item)
                            .where(certification_date: beginning_of_day..end_of_day)
                            .where(:fw_gender => gender,:organization_id => branch.id)
                            .where.not(order_items:{gender: gender})
                            .select('transactions.id, transactions.foreign_worker_id')

                            ## check orders (+)
                            changed_gender_orders = OrderItem.joins(:order)
                            .where(orders: {category: 'FOREIGN_WORKER_GENDER_AMENDMENT', status: 'PAID'})
                            .where(:order_itemable_id => transactions_changed_gender.pluck('transactions.foreign_worker_id'), :order_itemable_type => 'ForeignWorker', :refunded_at => nil).pluck('order_items.amount')

                            ## check refunds (-)
                            changed_gender_refunds = RefundItem.joins(:refund)
                            .where(refunds: {category: 'FOREIGN_WORKER_GENDER_AMENDMENT'})
                            .where(:refund_itemable_id => transactions_changed_gender.pluck('transactions.foreign_worker_id'), :refund_itemable_type => 'ForeignWorker').pluck('refund_items.amount')

                            @certification_amount = transactions.sum + changed_gender_orders.sum - changed_gender_refunds.sum

                            @debit_gl_code = "REVENUE_REG_#{branch.code}_#{gender}"
                            @gl_code = "REVENUE_CERT_#{branch.code}_#{gender}"

                            generate_journal_header
                        end
                    elsif revenue[:type] == 'transaction_expired_without_examination'
                        @description = "Transaction Expired (w/o Examination) from Branch (#{branch.code})"

                        genders.each do |gender|
                            ## without changing gender
                            transactions = Transaction.joins(:order_item)
                            .where(expired_at: beginning_of_day..end_of_day)
                            .where(medical_examination_date: nil)
                            .where(certification_date: nil)
                            .where.not(status: ['REJECTED', 'CANCELLED'])
                            .where('transaction_date >= ?', '2020-12-01 00:00:00')
                            .where(:fw_gender => gender,:organization_id => branch.id)
                            .pluck('order_items.amount')

                            ## changed gender
                            transactions_changed_gender = Transaction.joins(:order_item)
                            .where(expired_at: beginning_of_day..end_of_day)
                            .where(medical_examination_date: nil)
                            .where(certification_date: nil)
                            .where.not(status: ['REJECTED', 'CANCELLED'])
                            .where('transaction_date >= ?', '2020-12-01 00:00:00')
                            .where(:fw_gender => gender,:organization_id => branch.id)
                            .where.not(order_items:{gender: gender})
                            .select('transactions.id, transactions.foreign_worker_id')

                            ## check orders (+)
                            changed_gender_orders = OrderItem.joins(:order)
                            .where(orders: {category: 'FOREIGN_WORKER_GENDER_AMENDMENT', status: 'PAID'})
                            .where(:order_itemable_id => transactions_changed_gender.pluck('transactions.foreign_worker_id'), :order_itemable_type => 'ForeignWorker', :refunded_at => nil).pluck('order_items.amount')

                            ## check refunds (-)
                            changed_gender_refunds = RefundItem.joins(:refund)
                            .where(refunds: {category: 'FOREIGN_WORKER_GENDER_AMENDMENT'})
                            .where(:refund_itemable_id => transactions_changed_gender.pluck('transactions.foreign_worker_id'), :refund_itemable_type => 'ForeignWorker').pluck('refund_items.amount')

                            @transaction_expired_without_examination_amount = transactions.sum + changed_gender_orders.sum - changed_gender_refunds.sum

                            @debit_gl_code = "REVENUE_REG_#{branch.code}_#{gender}"
                            @gl_code = "REVENUE_EXPIRED_#{branch.code}_#{gender}"

                            generate_journal_header
                        end
                    elsif revenue[:type] == 'transaction_transmission_expired'
                        @description = "Transaction Expired (with Examination) from Branch (#{branch.code})"

                        genders.each do |gender|
                            ## without changing gender
                            transactions = Transaction.joins(:order_item)
                            .where.not(medical_examination_date: nil)
                            .where(certification_date: nil)
                            .where.not(status: ['REJECTED', 'CANCELLED'])
                            .where('transaction_date >= ?', '2020-12-01 00:00:00')
                            .where(transmission_expired_at: beginning_of_day..end_of_day)
                            .where(:fw_gender => gender,:organization_id => branch.id)
                            .pluck('order_items.amount')

                            ## changed gender
                            transactions_changed_gender = Transaction.joins(:order_item)
                            .where.not(medical_examination_date: nil)
                            .where(certification_date: nil)
                            .where.not(status: ['REJECTED', 'CANCELLED'])
                            .where('transaction_date >= ?', '2020-12-01 00:00:00')
                            .where(transmission_expired_at: beginning_of_day..end_of_day)
                            .where(:fw_gender => gender,:organization_id => branch.id)
                            .where.not(order_items:{gender: gender})
                            .select('transactions.id, transactions.foreign_worker_id')

                            ## check orders (+)
                            changed_gender_orders = OrderItem.joins(:order)
                            .where(orders: {category: 'FOREIGN_WORKER_GENDER_AMENDMENT', status: 'PAID'})
                            .where(:order_itemable_id => transactions_changed_gender.pluck('transactions.foreign_worker_id'), :order_itemable_type => 'ForeignWorker', :refunded_at => nil).pluck('order_items.amount')

                            ## check refunds (-)
                            changed_gender_refunds = RefundItem.joins(:refund)
                            .where(refunds: {category: 'FOREIGN_WORKER_GENDER_AMENDMENT'})
                            .where(:refund_itemable_id => transactions_changed_gender.pluck('transactions.foreign_worker_id'), :refund_itemable_type => 'ForeignWorker').pluck('refund_items.amount')

                            @transaction_transmission_expired_amount = transactions.sum + changed_gender_orders.sum - changed_gender_refunds.sum

                            @debit_gl_code = "REVENUE_REG_#{branch.code}_#{gender}"
                            @gl_code = "REVENUE_EXPIRED_#{branch.code}_#{gender}"

                            generate_journal_header
                        end
                    else
                        @debit_gl_code = "COLLECTION_#{branch.code}"

                        # all that get from orders
                        case revenue[:type]
                        when 'worker_registration'
                            @description = "Registration from Branch (#{branch.code})"
                        when 'worker_cancellation'
                            @description = "Other Income - Worker Cancellation from Branch (#{branch.code})"

                            @gl_code = "REVENUE_WC_#{branch.code}"
                        when 'special_renewal_rejected'
                            @description = "Other Income - Special Renewal Rejected from Branch (#{branch.code})"

                            @gl_code = "REVENUE_SFSREG_#{branch.code}"
                        when 'reprint_medical_form'
                            @description = "Other Income - Reprint Medical Form from Branch (#{branch.code})"

                            @gl_code = "REVENUE_RM_#{branch.code}"
                        when 'change_doctor'
                            @description = "Other Income - Doctor Allocation from Branch (#{branch.code})"

                            @gl_code = "REVENUE_CD_#{branch.code}"
                        when 'transaction_extent'
                            @description = "Other Income - Transaction Extend from Branch (#{branch.code})"

                            @gl_code = "REVENUE_TE_#{branch.code}"
                        when 'worker_amendment'
                            @description = "Other Income - Worker Amendment from Branch (#{branch.code})"

                            @gl_code = "REVENUE_WA_#{branch.code}"
                        end
                    end

                    if revenue[:type] == 'worker_registration'

                        sub_orders = Order.where(paid_at: beginning_of_day..end_of_day)
                        .where('orders.organization_id = ?',branch.id)
                        .where(:category => revenue[:sub_categories],:status => 'PAID')

                        # order_items.gender is the latest gender change
                        female_to_male = sub_orders.joins(:order_items)
                        .joins( "INNER JOIN fees ON order_items.fee_id = fees.id" )
                        .where(order_items:{gender: 'M'})
                        .where('fees.code in (?)',revenue[:sub_fee_categories])

                        male_to_female = sub_orders.joins(:order_items)
                        .joins( "INNER JOIN fees ON order_items.fee_id = fees.id" )
                        .where(order_items:{gender: 'F'})
                        .where('fees.code in (?)',revenue[:sub_fee_categories])

                        female_to_male_count = female_to_male.count
                        male_to_female_count = male_to_female.count

                        # gender change approval rejected (-)
                        rejected_sub_orders = Order.where('orders.organization_id = ?',branch.id)
                        .where(:category => revenue[:sub_categories],:status => 'PAID')

                        rejected_female_to_male = rejected_sub_orders.joins(:order_items)
                        .joins( "INNER JOIN fees ON order_items.fee_id = fees.id" )
                        .where(order_items:{gender: 'M'})
                        .where('fees.code in (?)',revenue[:sub_fee_categories])
                        .where(order_items:{refunded_at: beginning_of_day..end_of_day})

                        rejected_male_to_female = rejected_sub_orders.joins(:order_items)
                        .joins( "INNER JOIN fees ON order_items.fee_id = fees.id" )
                        .where(order_items:{gender: 'F'})
                        .where('fees.code in (?)',revenue[:sub_fee_categories])
                        .where(order_items:{refunded_at: beginning_of_day..end_of_day})

                        rejected_female_to_male_count = rejected_female_to_male.count
                        rejected_male_to_female_count = rejected_male_to_female.count

                        female_rate = Fee.find_by(code: "TRANSACTION_FEMALE").amount || 0
                        male_rate = Fee.find_by(code: "TRANSACTION_MALE").amount || 0

                        genders.each do |gender|
                            @rate_difference = 0
                            @gl_code = "REVENUE_REG_#{branch.code}_#{gender}"

                            @orders = orders.joins(:order_items)
                            .joins( "INNER JOIN fees ON order_items.fee_id = fees.id" )
                            .where('orders.organization_id = ?',branch.id)
                            .where(order_items:{gender: gender})
                            .where('fees.code in (?)', revenue[:fee_categories])
                            .select('order_items.id,order_items.amount')

                            cancelled_transactions = Transaction.joins(:transaction_cancels)
                            .where(transaction_cancels:{cancelled_at: beginning_of_day..end_of_day})
                            .where(:fw_gender => gender,:organization_id => branch.id).pluck(:order_item_id)

                            rejected_transactions = Transaction.where(special_renewal_rejected_at: beginning_of_day..end_of_day).where(:fw_gender => gender,:organization_id => branch.id).pluck(:order_item_id)

                            @orders_cancellation = OrderItem.where(:id => cancelled_transactions)
                            @orders_rejected = OrderItem.where(:id => rejected_transactions)

                            # nett count = gender change order paid - gender change order refunded (with approval rejected)
                            if gender == 'M'
                                # female to male : -female, +male
                                @add_rate_difference = male_rate*(female_to_male_count - rejected_female_to_male_count)
                                @minus_rate_difference = male_rate*(male_to_female_count - rejected_male_to_female_count)
                            elsif gender == 'F'
                                # male to female : +female, -male
                                @add_rate_difference = female_rate*(male_to_female_count - rejected_male_to_female_count)
                                @minus_rate_difference = female_rate*(female_to_male_count - rejected_female_to_male_count)
                            end

                            generate_journal_header
                        end
                    else
                        @orders = orders.joins(:order_items).merge(OrderItem.exclude_convenient_fee).where(:organization_id => branch.id)

                        if revenue[:approval] == true
                            @rejected_orders = orders_without_date.joins(:order_items)
                            .merge(OrderItem.exclude_convenient_fee)
                            .where(:organization_id => branch.id)
                            .where('order_items.refunded_at BETWEEN ? AND ?', beginning_of_day, end_of_day).select('order_items.id,order_items.amount')
                        end

                        if !['worker_certification', 'transaction_expired_without_examination', 'transaction_transmission_expired'].include? (revenue[:type])
                            generate_journal_header
                        end
                    end
                end
            else
                # without branch
                @description = 'Other Income'

                case revenue[:type]
                when 'sp_registration','sp_change_address'
                    @description = "Payment from Branch - HQ Collection from MSPD"
                end

                orders = Order.where(paid_at: beginning_of_day..end_of_day)
                    .where(:category => revenue[:categories],:status => 'PAID')

                if revenue[:type] == 'sp_registration'
                    revenue[:service_providers].try(:each) do |service_provider|
                        @orders = orders.where(:customerable_type => service_provider)
                        @gl_code = "REVENUE_REG_#{service_provider.upcase}"
                        @description = "Other Income - #{service_provider} Registration From MSPD"

                        generate_journal_header
                    end
                else
                    @orders = orders
                    @gl_code = "REVENUE_CHANGE_CLINIC_ADDRESS"
                    @description = "Other Income - Change Clinic Address From MSPD"

                    generate_journal_header
                end
            end
        end

        bank_draft_payment_method_id = PaymentMethod.find_by_code('BANKDRAFT')&.id
        reclassification_revenues.each do |revenue|
            @revenue = revenue
            @revenue_type = revenue[:type]
            @source_type = FinanceSetting.get_value(revenue[:source_type])

            if revenue[:type] == 'gender_amendment'

                order_by_bank_drafts = Order.select('orders.amount, orders.category,minus_org.code as minus_org_code, minus_org.name as minus_org_name, add_org.code as add_to_org_code, add_org.name as add_to_org_name')
                .joins(:creator, :bank_draft_allocations, :order_items)
                .joins('JOIN bank_drafts ON bank_draft_allocations.bank_draft_id = bank_drafts.id')
                .joins('JOIN organizations minus_org ON bank_drafts.organization_id = minus_org.id')
                .joins('JOIN organizations add_org ON orders.organization_id = add_org.id')
                .where(paid_at: beginning_of_day..end_of_day, category: revenue[:categories], status: 'PAID')
                .where("users.userable_type = 'Organization' and bank_drafts.organization_id  != orders.organization_id")

                order_by_other_payment = Order.select('orders.amount, orders.category,minus_org.code as minus_org_code, minus_org.name as minus_org_name, add_org.code as add_to_org_code, add_org.name as add_to_org_name')
                .joins(:creator, :order_items)
                .joins('JOIN organizations minus_org ON users.userable_id = minus_org.id')
                .joins('JOIN organizations add_org ON orders.organization_id = add_org.id')
                .where(paid_at: beginning_of_day..end_of_day, category: revenue[:categories], status: 'PAID')
                .where("users.userable_type = 'Organization' and users.userable_id != orders.organization_id and orders.payment_method_id != #{bank_draft_payment_method_id}")

                orders = Order.from("(#{order_by_bank_drafts.to_sql} UNION ALL #{order_by_other_payment.to_sql}) AS orders")
                @orders = orders.select('sum(orders.amount) amount, category, minus_org_code, minus_org_name, add_to_org_code,add_to_org_name').group('category, minus_org_code, minus_org_name, add_to_org_code,add_to_org_name')

                generate_reclassification_journal_header
            end

        end

        if !@journal_headers.blank?
            @request_content = {
                Description: head_description.upcase,
                JournalHeaders: @journal_headers
            }

            gl_journal_batches
        end
    end

private
    def generate_reclassification_journal_header
        ## due to finance system is opposite in terms of debit and credit, our side have to be opposite to cater their system

        @orders.each do |order|

            journal_date = "#{@current}#{@utc_time_format}"
            journal_details_types = ['debit','credit']
            journal_details = []

            sum = order&.amount.try(:to_f) || 0

            add_to_gl_code = "COLLECTION_#{order.add_to_org_code}"
            minus_from_gl_code = "COLLECTION_#{order.minus_org_code}"

            description = "Reclassification Revenue - #{@revenue[:description]} (#{order.minus_org_code} - #{order.add_to_org_code})"

            if sum > 0
                journal_details_types.each do |journal_details_type|
                    if journal_details_type == 'debit'
                        # positive
                        amount = -sum
                        account_number = FinanceSetting.get_value(add_to_gl_code)
                    else
                        # negative
                        amount = sum
                        account_number = FinanceSetting.get_value(minus_from_gl_code)
                    end

                    journal_detail = {
                        JournalDate: journal_date,
                        Description: description.upcase,
                        Reference: "",
                        AccountNumber: account_number,
                        Amount: amount.to_f,
                        SourceCurrency: "MYR",
                        Comment: ""
                    }

                    journal_details << journal_detail
                end

                journal_header = {
                    Description: description.upcase,
                    DocumentDate: journal_date,
                    PostingDate: journal_date,
                    SourceLedger: 'GL',
                    SourceType: @source_type,
                    JournalDetails: journal_details
                }

                @journal_headers << journal_header
            end
        end
    end

    def generate_journal_header

        journal_date = "#{@current}#{@utc_time_format}"
        journal_details_types = ['debit','credit']
        journal_details = []

        if @revenue_type == 'worker_registration'
            sum = @orders.sum(&:amount)-@orders_cancellation.sum(&:amount)-@orders_rejected.sum(&:amount)

            sum += @add_rate_difference.to_f
            sum -= @minus_rate_difference.to_f
        elsif @revenue_type == 'worker_certification'
            sum = @certification_amount.to_f
        elsif @revenue_type == 'transaction_expired_without_examination'
            sum = @transaction_expired_without_examination_amount.to_f
        elsif @revenue_type == 'transaction_transmission_expired'
            sum = @transaction_transmission_expired_amount.to_f
        else
            sum = @orders.sum('order_items.amount')
        end

        if @revenue[:approval] == true
            if !@rejected_orders.blank?
                sum -= @rejected_orders.sum('order_items.amount')
            end
        end

        if sum != 0
            journal_details_types.each do |journal_details_type|

                if journal_details_type == 'debit'
                    # positive
                    amount = sum
                    account_number = FinanceSetting.get_value(@debit_gl_code)
                else
                    # negative
                    amount = -sum
                    account_number = FinanceSetting.get_value(@gl_code)
                end

                journal_detail = {
                    JournalDate: journal_date,
                    Description: @description.upcase,
                    Reference: "",
                    AccountNumber: account_number,
                    Amount: amount.to_f,
                    SourceCurrency: "MYR",
                    Comment: ""
                }

                journal_details << journal_detail
            end

            journal_header = {
                Description: @description.upcase,
                DocumentDate: journal_date,
                PostingDate: journal_date,
                SourceLedger: 'GL',
                SourceType: @source_type,
                JournalDetails: journal_details
            }

            @journal_headers << journal_header
        end
    end
end
