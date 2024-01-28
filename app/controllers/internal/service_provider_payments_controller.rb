class Internal::ServiceProviderPaymentsController < InternalController
    include FinanceManualPayment
    include PaymentListing
    include Sage

    before_action -> { can_access?("VIEW_SERVICE_PROVIDER_PAYMENT") }, only: [:index,:show]
    before_action -> { can_access?("CREATE_SERVICE_PROVIDER_PAYMENT") }, only: [:new,:create]
    before_action -> { can_access?("BULK_UPDATE_SERVICE_PROVIDER_PAYMENT") }, only: [:bulk_update,:bulk_update_template]
    before_action -> { can_access?("REPROCESS_SERVICE_PROVIDER_PAYMENT") }, only: [:reprocess]
    before_action -> { can_access?("VIEW_MANUAL_PAYMENT") }, only: [:view_transactions,:view_payment_xray,:view_payment_lab,:view_payment_doctor,:export_manual_payment]
    before_action -> { can_access?("EDIT_MANUAL_PAYMENT") }, only: [:update_payment,:edit_payment_xray,:edit_payment_lab,:edit_payment_doctor]
    before_action -> { can_access?("VIEW_PAYMENT_LISTING") }, only: [:view_payment_listing,:export_payment_listing]

    before_action :set_batch, only: [:show, :bulk_update, :export, :reprocess, :process_payment]
    before_action :set_transaction, only: [:edit_payment_xray, :edit_payment_lab, :update_payment, :view_payment_xray, :view_payment_lab, :view_payment_doctor, :edit_payment_doctor]
    before_action :check_service_provider, only: [:reprocess, :process_payment]

    def index
        @batches = FinBatch.select('DISTINCT(sp_fin_batches.service_provider_type), fin_batches.*, fin_batches.code::bigint as int_code')
        .joins("LEFT JOIN sp_fin_batches ON fin_batches.id = sp_fin_batches.fin_batch_id")
        .search_code(params[:code])
        .search_status(params[:status])
        .search_date_range(params[:batch_date_start],params[:batch_date_end])
        .search_service_provider(params[:service_provider])
        .order('int_code desc')
        .page(params[:page])
        .per(get_per)
    end

    def new
        @fin_batch = FinBatch.new   
        @service_provider = {}
    end

    def create
        default_status = "NOT_PROCESS"

        fin_batch = params[:fin_batch]
        start_date = fin_batch[:start_date]
        end_date = fin_batch[:end_date]
        end_date = (end_date.to_date.beginning_of_day + 1.days).strftime('%Y-%m-%d %H:%M:%S')
        service_provider_type = params[:service_provider]
        group_type = 'ServiceProviderGroup'

        # check if exist, get fin_batch instead of creating new data
        @fin_batch = FinBatch.where(:code => fin_batch[:code]).first

        if @fin_batch.blank? 
            @fin_batch = FinBatch.new(fin_batch_params)
            @fin_batch.status = default_status
            @fin_batch.save
        end

        # doctor - individual
        if service_provider_type == 'Doctor'

            manager = ActiveRecord::Base.connection.transaction_manager
            manager.begin_transaction
            begin
                transactions = Transaction.select("transactions.doctor_id as batchable_id,doctors.company_name as name, doctors.clinic_name, doctors.bank_account_number, doctors.bank_id, sum(case when transactions.fw_gender = 'M' then doc_male_rate else 0 end + case when transactions.fw_gender = 'F' then doc_female_rate else 0 end) as total, string_agg(transactions.id::varchar, ', ') as transaction_ids")
                .joins(:transaction_detail)
                .joins(:doctor)
                .where(transaction_details: {doc_service_provider_group_id: nil})
                .where("transactions.certification_date >= ? AND transactions.certification_date < ?", start_date, end_date)
                .with_default_transaction_date
                .where("transactions.physical_exam_not_done IS NOT ?",true)
                .where("transactions.id not in (select transaction_id from sp_transactions_payments where service_providable_type = '#{service_provider_type}')")
                .group('transactions.doctor_id,doctors.company_name, doctors.clinic_name, doctors.bank_account_number, doctors.bank_id')

                transactions.each do |transaction|
                    sp_fin_batch = SpFinBatch.create({
                        fin_batch_id: @fin_batch.id,
                        batchable_type: service_provider_type,
                        batchable_id: transaction.batchable_id,
                        total_amount: transaction.total,
                        status: default_status,
                        company_name: transaction.name,
                        clinic_name: transaction.clinic_name,
                        service_provider_type: service_provider_type
                    })

                    ActiveRecord::Base.connection.execute("INSERT INTO sp_fin_batch_items (
                        sp_fin_batch_id,transaction_id,
                        amount,
                        created_at,updated_at,
                        itemable_type,itemable_id,
                        company_name,clinic_name
                    )
                    SELECT #{sp_fin_batch.id}, tr.id, 
                    case when tr.fw_gender = 'M' then trd.doc_male_rate when tr.fw_gender = 'F' then trd.doc_female_rate else 0 end,
                    NOW(), NOW(),
                    '#{service_provider_type}', tr.doctor_id, sp.company_name, sp.clinic_name
                    FROM transactions tr
                    JOIN transaction_details trd on tr.id = trd.transaction_id
                    JOIN doctors sp on tr.doctor_id = sp.id
                    WHERE tr.id IN (#{transaction.transaction_ids}) and tr.transaction_date >= '1998-03-14'")
                end

                # doctor - group
                group_transactions = Transaction.select("transaction_details.doc_service_provider_group_id as batchable_id,service_provider_groups.name as name, service_provider_groups.bank_account_number, service_provider_groups.bank_id, sum(case when transactions.fw_gender = 'M' then doc_sp_group_male_rate else 0 end + case when transactions.fw_gender = 'F' then doc_sp_group_female_rate else 0 end) as total, string_agg(transactions.id::varchar, ', ') as transaction_ids")
                .joins(:transaction_detail)
                .joins( "JOIN service_provider_groups ON transaction_details.doc_service_provider_group_id::bigint = service_provider_groups.id" )
                .where.not(transaction_details: {doc_service_provider_group_id: nil})
                .where("transactions.certification_date >= ? AND transactions.certification_date < ?", start_date, end_date)
                .with_default_transaction_date
                .where("transactions.physical_exam_not_done IS NOT ?",true)
                .where("transactions.id not in (select transaction_id from sp_transactions_payments where service_providable_type = '#{service_provider_type}')")
                .group('transaction_details.doc_service_provider_group_id,service_provider_groups.name, service_provider_groups.bank_account_number, service_provider_groups.bank_id')

                group_transactions.each do |transaction|
                    sp_fin_batch = SpFinBatch.create({
                        fin_batch_id: @fin_batch.id,
                        batchable_type: group_type,
                        batchable_id: transaction.batchable_id,
                        total_amount: transaction.total,
                        status: default_status,
                        company_name: transaction.name,
                        service_provider_type: service_provider_type
                    })

                    ActiveRecord::Base.connection.execute("INSERT INTO sp_fin_batch_items (
                        sp_fin_batch_id,transaction_id,
                        amount,
                        created_at,updated_at,
                        itemable_type,itemable_id,
                        company_name,clinic_name
                    )
                    SELECT #{sp_fin_batch.id}, tr.id, 
                    case when tr.fw_gender = 'M' then trd.doc_sp_group_male_rate when tr.fw_gender = 'F' then trd.doc_sp_group_female_rate else 0 end,
                    NOW(), NOW(),
                    '#{service_provider_type}', tr.doctor_id, sp.company_name, sp.clinic_name
                    FROM transactions tr
                    JOIN transaction_details trd on tr.id = trd.transaction_id
                    JOIN doctors sp on tr.doctor_id = sp.id
                    WHERE tr.id IN (#{transaction.transaction_ids}) and tr.transaction_date >= '1998-03-14'")
                end

                manager.commit_transaction
            rescue
                manager.rollback_transaction
            end

        elsif service_provider_type == 'XrayFacility'

            manager = ActiveRecord::Base.connection.transaction_manager
            manager.begin_transaction
            begin
                transactions = Transaction.select("transactions.xray_facility_id as batchable_id,xray_facilities.company_name as name, xray_facilities.name as clinic_name, xray_facilities.bank_account_number, xray_facilities.bank_id, sum(case when transactions.fw_gender = 'M' then xray_male_rate else 0 end + case when transactions.fw_gender = 'F' then xray_female_rate else 0 end) as total, string_agg(transactions.id::varchar, ', ') as transaction_ids")
                .joins(:transaction_detail)
                .joins(:xray_facility)
                .joins(:xray_examination)
                .with_default_transaction_date
                .where(transaction_details: {xray_service_provider_group_id: nil})
                .where("transactions.certification_date >= ? AND transactions.certification_date < ?", start_date, end_date)
                .where("xray_examinations.xray_examination_not_done = ?",'NO')
                .where("transactions.id not in (select transaction_id from sp_transactions_payments where service_providable_type = '#{service_provider_type}')")
                .where("xray_facilities.code != 'X123456789'")
                .group('transactions.xray_facility_id,xray_facilities.company_name, xray_facilities.name, xray_facilities.bank_account_number, xray_facilities.bank_id')

                transactions.each do |transaction|
                    sp_fin_batch = SpFinBatch.create({
                        fin_batch_id: @fin_batch.id,
                        batchable_type: service_provider_type,
                        batchable_id: transaction.batchable_id,
                        total_amount: transaction.total,
                        status: default_status,
                        company_name: transaction.name,
                        clinic_name: transaction.clinic_name,
                        service_provider_type: service_provider_type
                    })

                    ActiveRecord::Base.connection.execute("INSERT INTO sp_fin_batch_items (
                        sp_fin_batch_id,transaction_id,
                        amount,
                        created_at,updated_at,
                        itemable_type,itemable_id,
                        company_name,clinic_name
                    )
                    SELECT #{sp_fin_batch.id}, tr.id, 
                    case when tr.fw_gender = 'M' then trd.xray_male_rate when tr.fw_gender = 'F' then trd.xray_female_rate else 0 end,
                    NOW(), NOW(),
                    '#{service_provider_type}', tr.xray_facility_id, sp.company_name, sp.name
                    FROM transactions tr
                    JOIN transaction_details trd on tr.id = trd.transaction_id
                    JOIN xray_facilities sp on tr.xray_facility_id = sp.id
                    WHERE tr.id IN (#{transaction.transaction_ids}) and tr.transaction_date >= '1998-03-14'")
                end

                # xray - group
                group_transactions = Transaction.select("transaction_details.xray_service_provider_group_id as batchable_id,service_provider_groups.name as name, service_provider_groups.bank_account_number, service_provider_groups.bank_id, sum(case when transactions.fw_gender = 'M' then xray_sp_group_male_rate else 0 end + case when transactions.fw_gender = 'F' then xray_sp_group_female_rate else 0 end) as total, string_agg(transactions.id::varchar, ', ') as transaction_ids")
                .joins(:transaction_detail)
                .joins( "JOIN service_provider_groups ON transaction_details.xray_service_provider_group_id::bigint = service_provider_groups.id" )
                .joins(:xray_examination)
                .with_default_transaction_date
                .where.not(transaction_details: {xray_service_provider_group_id: nil})
                .where("transactions.certification_date >= ? AND transactions.certification_date < ?", start_date, end_date)
                .where("xray_examinations.xray_examination_not_done = ?",'NO')
                .where("transactions.id not in (select transaction_id from sp_transactions_payments where service_providable_type = '#{service_provider_type}')")
                .group('transaction_details.xray_service_provider_group_id,service_provider_groups.name, service_provider_groups.bank_account_number, service_provider_groups.bank_id')

                group_transactions.each do |transaction|
                    sp_fin_batch = SpFinBatch.create({
                        fin_batch_id: @fin_batch.id,
                        batchable_type: group_type,
                        batchable_id: transaction.batchable_id,
                        total_amount: transaction.total,
                        status: default_status,
                        company_name: transaction.name,
                        service_provider_type: service_provider_type
                    })

                    ActiveRecord::Base.connection.execute("INSERT INTO sp_fin_batch_items (
                        sp_fin_batch_id,transaction_id,
                        amount,
                        created_at,updated_at,
                        itemable_type,itemable_id,
                        company_name,clinic_name
                    )
                    SELECT #{sp_fin_batch.id}, tr.id, 
                    case when tr.fw_gender = 'M' then trd.xray_sp_group_male_rate when tr.fw_gender = 'F' then trd.xray_sp_group_female_rate else 0 end,
                    NOW(), NOW(),
                    '#{service_provider_type}', tr.xray_facility_id, sp.company_name, sp.name
                    FROM transactions tr
                    JOIN transaction_details trd on tr.id = trd.transaction_id
                    JOIN xray_facilities sp on tr.xray_facility_id = sp.id
                    WHERE tr.id IN (#{transaction.transaction_ids}) and tr.transaction_date >= '1998-03-14'")
                end
                manager.commit_transaction
            rescue
                manager.rollback_transaction
            end
            
        elsif service_provider_type == 'Laboratory'
            manager = ActiveRecord::Base.connection.transaction_manager
            manager.begin_transaction
            begin
                transactions = Transaction.select("transactions.laboratory_id as batchable_id,laboratories.company_name as name, laboratories.name as clinic_name, laboratories.bank_account_number, laboratories.bank_id, sum(case when transactions.fw_gender = 'M' then lab_male_rate else 0 end + case when transactions.fw_gender = 'F' then lab_female_rate else 0 end) as total, string_agg(transactions.id::varchar, ', ') as transaction_ids")
                .joins(:transaction_detail)
                .joins(:laboratory)
                .joins(:laboratory_examination)
                .with_default_transaction_date
                .where(transaction_details: {lab_service_provider_group_id: nil})
                .where("transactions.certification_date >= ? AND transactions.certification_date < ?", start_date, end_date)
                .where("laboratory_examinations.laboratory_test_not_done = ?",'NO')
                .where("transactions.id not in (select transaction_id from sp_transactions_payments where service_providable_type = '#{service_provider_type}')")
                .group('transactions.laboratory_id,laboratories.company_name, laboratories.name, laboratories.bank_account_number, laboratories.bank_id')
                
                transactions.each do |transaction|
                    sp_fin_batch = SpFinBatch.create({
                        fin_batch_id: @fin_batch.id,
                        batchable_type: service_provider_type,
                        batchable_id: transaction.batchable_id,
                        total_amount: transaction.total,
                        status: default_status,
                        company_name: transaction.name,
                        clinic_name: transaction.clinic_name,
                        service_provider_type: service_provider_type
                    })
                
                    ActiveRecord::Base.connection.execute("INSERT INTO sp_fin_batch_items (
                        sp_fin_batch_id,transaction_id,
                        amount,
                        created_at,updated_at,
                        itemable_type,itemable_id,
                        company_name,clinic_name
                    )
                    SELECT #{sp_fin_batch.id}, tr.id, 
                    case when tr.fw_gender = 'M' then trd.lab_male_rate when tr.fw_gender = 'F' then trd.lab_female_rate else 0 end,
                    NOW(), NOW(),
                    '#{service_provider_type}', tr.laboratory_id, sp.company_name, sp.name
                    FROM transactions tr
                    JOIN transaction_details trd on tr.id = trd.transaction_id
                    JOIN laboratories sp on tr.laboratory_id = sp.id
                    WHERE tr.id IN (#{transaction.transaction_ids})")
                end

                # lab - group
                group_transactions = Transaction.select("transaction_details.lab_service_provider_group_id as batchable_id,service_provider_groups.name as name, service_provider_groups.bank_account_number, service_provider_groups.bank_id, sum(case when transactions.fw_gender = 'M' then lab_sp_group_male_rate else 0 end + case when transactions.fw_gender = 'F' then lab_sp_group_female_rate else 0 end) as total, string_agg(transactions.id::varchar, ', ') as transaction_ids")
                .joins(:transaction_detail)
                .joins( "JOIN service_provider_groups ON transaction_details.lab_service_provider_group_id::bigint = service_provider_groups.id" )
                .joins(:laboratory_examination)
                .with_default_transaction_date
                .where.not(transaction_details: {lab_service_provider_group_id: nil})
                .where("transactions.certification_date >= ? AND transactions.certification_date < ?", start_date, end_date)
                .where("laboratory_examinations.laboratory_test_not_done = ?",'NO')
                .where("transactions.id not in (select transaction_id from sp_transactions_payments where service_providable_type = '#{service_provider_type}')")
                .group('transaction_details.lab_service_provider_group_id,service_provider_groups.name, service_provider_groups.bank_account_number, service_provider_groups.bank_id')

                group_transactions.each do |transaction|
                    sp_fin_batch = SpFinBatch.create({
                        fin_batch_id: @fin_batch.id,
                        batchable_type: group_type,
                        batchable_id: transaction.batchable_id,
                        total_amount: transaction.total,
                        status: default_status,
                        company_name: transaction.name,
                        service_provider_type: service_provider_type
                    })

                    ActiveRecord::Base.connection.execute("INSERT INTO sp_fin_batch_items (
                        sp_fin_batch_id,transaction_id,
                        amount,
                        created_at,updated_at,
                        itemable_type,itemable_id,
                        company_name,clinic_name
                    )
                    SELECT #{sp_fin_batch.id}, tr.id, 
                    case when tr.fw_gender = 'M' then trd.lab_sp_group_male_rate when tr.fw_gender = 'F' then trd.lab_sp_group_female_rate else 0 end,
                    NOW(), NOW(),
                    '#{service_provider_type}', tr.laboratory_id, sp.company_name, sp.name
                    FROM transactions tr
                    JOIN transaction_details trd on tr.id = trd.transaction_id
                    JOIN laboratories sp on tr.laboratory_id = sp.id
                    WHERE tr.id IN (#{transaction.transaction_ids})")
                end

                manager.commit_transaction
            rescue
                manager.rollback_transaction
            end
        end

        respond_to do |format|
            format.html { redirect_to internal_payments_batch_show_path(:id => @fin_batch.id,:service_provider => service_provider_type), notice: 'Batch Has Been Generated'}
            format.json { render :show, status: :ok, location: @fin_batch }
        end
        # render json: group_transactions and return
    end

    def show
        status = params[:status]

        if params[:service_provider].present?
            @error = ApInvoiceBatch.where(:batchable_id => @batch.id,:batchable_type => 'FinBatch',:service_provider_type => params[:service_provider]).last

            @group_batches = @batch.sp_fin_batches.is_group.search_group_service_provider(params[:service_provider])
            @individual_batches = @batch.sp_fin_batches.search_individual_service_provider(params[:service_provider])
            @total_amount = @batch.sp_fin_batches.is_group.search_group_service_provider(params[:service_provider]).search_status(status).sum(:total_amount)+@batch.sp_fin_batches.search_individual_service_provider(params[:service_provider]).search_status(status).sum(:total_amount)
        else
            @group_batches = @batch.sp_fin_batches.is_group.order('id')
            @individual_batches = @batch.sp_fin_batches.is_individual.order('id')
            @total_amount = @batch.sp_fin_batches.search_status(status).sum(:total_amount)
        end

        @group_batches = @group_batches.search_status(status)
        @individual_batches =  @individual_batches.search_status(status)
    end

    def get_batches
        # do checking limit loop till setting at env
        service_provider_group = ServiceProviderGroup.to_s
        service_provider = params[:service_provider]
        @batches = []

        batches = params[:batches]
        count = 0
        item = nil
        
        loop do 
            item = batches[count.to_s]
            @batches << item if !item.blank?

            count += 1
            break if item == nil
        end 

        batch_codes = @batches.collect { |x| x['batch_code'] }

        individual_fin_batch_codes = FinBatch.joins(:sp_fin_batches)
        .where(:code => batch_codes)
        .where(sp_fin_batches: {batchable_type: service_provider})
        .group('fin_batches.code')
        .pluck('fin_batches.code')

        fin_batch_codes = FinBatch.joins(:sp_fin_batches)
        .where(:code => batch_codes)
        .where(sp_fin_batches: {service_provider_type: service_provider})
        .group('fin_batches.code')
        .pluck('fin_batches.code')

        batch_codes = batch_codes.reject {|code| fin_batch_codes.include? code}

        new_batches = @batches.select { |batch| batch_codes.include? batch['batch_code'] }

        render json: new_batches
    end

    def bulk_update  
        file = params[:file]
        path = params[:service_provider].present? ? internal_payments_batch_show_path(@batch,:service_provider => params[:service_provider]) : internal_payments_batch_show_path(@batch)

        if file.respond_to?(:path)
            CSV.foreach(file.path, headers: true, :header_converters => lambda { |h| h.try(:downcase).try(:gsub,' ', '_') }) do |row|
                # need to add checking if row break
                
                sp_batch = row.to_hash
                batch_code = sp_batch['batch_code']
                batch_id = FinBatch.where(:code => batch_code).pluck(:id).first

                if batch_code == @batch.code
                    sp_type = sp_batch['service_type']
                    payment_type = sp_batch['payment_by']
                    sp_code = sp_batch['sp_code']
                    group_code = sp_batch['group_code']
                    status = sp_batch['status']&.upcase

                    if payment_type == 'Group'
                        if group_code.present? and sp_code == '-' 
                            group_id = ServiceProviderGroup.where(:code => group_code).pluck(:id).first
                            row_update = SpFinBatch.where(:fin_batch_id => batch_id,:batchable_type => ServiceProviderGroup.to_s,:batchable_id => group_id).first
                        end
                    else
                        model_name = sp_type.constantize
                        service_provider_id = model_name.where(:code => sp_code).pluck(:id).first
                        row_update = SpFinBatch.where(:fin_batch_id => batch_id,:batchable_type => sp_type,:batchable_id => service_provider_id).first
                    end

                    if row_update
                        row_update.update(:status => status)
                    end
                end
            end

            respond_to do |format|
                format.html { redirect_to path, notice: 'Batch Has Been Updated' }
                format.json { render :show, status: :ok, location: @batch }
            end
        else
            error_msg = "Bad file_data: #{file.class.name}: #{file.inspect}"
            logger.error error_msg
            respond_to do |format|
                format.html { redirect_to path, error:error_msg }
                format.json { render json: error_msg, status: :unprocessable_entity }
            end
        end

    end

    def bulk_update_template
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = 'attachment; filename=bulk_update_template.csv'
        render :template => "/internal/service_provider_payments/bulk_update_template.csv.erb"
    end

    def export
        batches = FinBatch.where(:id => params[:id])
        filename = 'Batch_'+@batch.code+'('+@batch.start_date.strftime("%Y%m%d")+'-'+@batch.end_date.strftime("%Y%m%d")+').csv'
        respond_to do |format|
          format.html { redirect_to internal_payments_batch_show_path(@batch) }
          format.csv { send_data batches.to_csv(params[:service_provider]), filename: filename }
        end
    end

    def reprocess

        sp_fin_batches = @batch.sp_fin_batches.where(:status => ['FAILED','PROCESS_FAILED'], :service_provider_type => params[:service_provider])

        if sp_fin_batches.blank?
            notice = 'NO FAIL PAYMENT IN THIS BATCH'
        else
            sp_fin_batches.update({
                status: 'PROCESSING'
            }) 

            sp_fin_batches_ids = sp_fin_batches.pluck(:id)
            ServiceProviderPaymentWorker.perform_async(@batch.id,sp_fin_batches_ids)

            notice = 'RE-PROCESSING FAILED PAYMENT(S)'   
        end

        redirect_back fallback_location: internal_payments_batch_show_path, notice: notice
    end

    def process_payment
        sp_fin_batches = @batch&.sp_fin_batches.where(:status => ['NOT_PROCESS','PROCESS_FAILED'],:service_provider_type => params[:service_provider])

        if sp_fin_batches.blank?
            notice = "NO PAYMENT TO BE PROCESS IN THIS BATCH"
        else
            sp_fin_batches.update({
                status: 'PROCESSING'
            })    

            sp_fin_batches_ids = sp_fin_batches.pluck(:id)
            ServiceProviderPaymentWorker.perform_async(@batch.id,sp_fin_batches_ids)

            notice = "PROCESSING PAYMENT(S)"
        end

        redirect_back fallback_location: internal_payments_batch_show_path, notice: notice
    end
    
private
    def set_transaction
        @transaction = Transaction.find(params[:id]) 
        # or redirect_to internal_transactions_url, flash: {notice: "Transaction not found"}
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_batch
        @batch = FinBatch.find(params[:id])
    end

    def get_new_transaction(transaction)
        return transaction.as_json.merge({
            amount: 0,
            transaction_group: ''
        })
    end

    def fin_batch_params
        params.require(:fin_batch).permit(:code, :service_provider,:start_date, :end_date)
    end

    def check_service_provider
        if params[:service_provider].blank?
            flash[:error] = "Please filter a service provider before process a payment."
            redirect_to (request.env["HTTP_REFERER"] || internal_root_path) and return
        end
    end
end