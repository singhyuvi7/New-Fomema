module DailyRevenueBatch

    def revenue_batch
        beginning_of_day = @start_date.beginning_of_day
        end_of_day = @end_date.end_of_day

        @gl_code = ''

        genders = ['M','F']
        revenues = [
            {
                type: 'transaction_expired_without_examination',
                by_branch: true,
                source_type: "SOURCE_TYPE_EXPIRED"
            },{
                type: 'transaction_transmission_expired',
                by_branch: true,
                source_type: "SOURCE_TYPE_EXPIRED"
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

                branches.each do |branch|
                    @rejected_orders = []

                    @description = 'Other Income'

                    if revenue[:type] == 'transaction_expired_without_examination'
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
                            .where(orders: {category: 'FOREIGN_WORKER_GENDER_AMENDMENT'})
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
                            .where(orders: {category: 'FOREIGN_WORKER_GENDER_AMENDMENT'})
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
                    end
                end
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
