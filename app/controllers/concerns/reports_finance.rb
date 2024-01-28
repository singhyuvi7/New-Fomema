module ReportsFinance
    extend ActiveSupport::Concern

    included do
        before_action :set_company_name, only: %i[portal_transactions summary_draft_collection
                                                  summary_misc_income summary_worker_certification detail_worker_certification
                                                  summary_worker_registration detail_worker_registration summary_worker_insurance details_worker_insurance
                                                  summary_transaction_expired_without_examination detail_transaction_expired_without_examination
                                                  summary_transaction_transmission_expired detail_transaction_transmission_expired]
        before_action :set_branches, only: %i[details_worker_insurance]
    end

    def sp_payment_mode_statistic
        date = params[:date]

        ## cash_order/cheque - cashier order
        ## old giro/new giro - online
        @sp_title = {
            'doctor': 'Doctor',
            'xray': 'X-Ray',
            'lab': 'Laboratory'
        }

        @current_datetime = Time.now.strftime("%d-%b-%Y %H:%M:%S")

        doctors = Doctor
        doctors = query_payment_mode_statistic(doctors)

        xrays = XrayFacility
        xrays = query_payment_mode_statistic(xrays)

        labs = Laboratory
        labs = query_payment_mode_statistic(labs)

        doctors = doctors[0] if !doctors.blank?
        xrays = xrays[0] if !xrays.blank?
        labs = labs[0] if !labs.blank?

        @statistics = [doctors, xrays, labs].map { |statistic| payment_mode_statistic_mapping(statistic) }
        @statistics = [[:doctor,@statistics[0]],[:xray,@statistics[1]],[:lab,@statistics[2]]].to_h

        respond_to do |format|
            format.html { render "internal/reports/finance/sp_payment_mode_statistic/index.html" }
            format.xlsx { render xlsx: "index" , filename: "sp_payment_mode_statistic(#{@current_datetime}).xlsx", template: 'internal/reports/finance/sp_payment_mode_statistic/index' }
        end

    end

    def summary_draft_collection
        @current = Time.now if @current.blank?
        @date = @current.strftime('%d/%m/%Y')
        @time = @current.strftime('%H:%M:%S %p')

        @branches = Organization.where(:org_type => 'BRANCH').select('id,code,name').order('name ASC')
        @start_date = params[:start_date]
        @end_date = params[:end_date]
        @branch_id = params[:branch]
        @headers = ['Date', 'Net Amount', 'GST', 'Processing Fee', 'Draft Amount']
        @bank_drafts = []
        @bank_drafts, @grand_total = Report::SummaryDraftCollectionService.new(@start_date, @end_date, @branch_id).result if @start_date.present? && @end_date.present?

        respond_to do |format|
            format.html { render "internal/reports/finance/summary_draft_collection/index.html" }
            format.pdf {
                return redirect_to(summary_draft_collection_internal_finance_reports_path, notice: 'required valid date input') unless @start_date.present? && @end_date.present?

                render pdf: "summary_draft_collection",
                template: 'internal/reports/finance/summary_draft_collection/_pdf_template.html.haml',
                layout: "pdf.html",
                margin: {
                    top: 50,
                    left: 12,
                    right: 12,
                    bottom: 10,
                },
                page_size: nil,
                page_height: "29.7cm",
                page_width: "21cm",
                dpi: "300",
                header: {
                    html: {
                        template: '/internal/reports/finance/summary_draft_collection/pdf_template_header'
                    }
                }
            }
            format.xlsx do
                render xlsx: 'index', filename: "summary_draft_collection-#{@start_date}to#{@end_date}.xlsx",
                template: 'internal/reports/finance/summary_draft_collection/index'
            end
        end
    end

    def summary_worker_certification
        @current = Time.now if @current.blank?
        @date = @current.strftime('%d/%m/%Y')
        @time = @current.strftime('%H:%M:%S %p')

        @branches = Organization.where(:org_type => 'BRANCH').select('id,code,name').order('name ASC')
        @start_date = params[:start_date]
        @end_date = params[:end_date]
        @branch_id = params[:branch]
        @headers = ['Date', 'Gender', 'Count']
        @certifications, @grand_total = Report::SummaryWorkerCertificationService.new(@start_date, @end_date, @branch_id).result if @start_date.present? && @end_date.present?

        respond_to do |format|
            format.html { render "internal/reports/finance/summary_worker_certification/index.html" }
            format.pdf {
                return redirect_to(summary_worker_certification_internal_finance_reports_path, notice: 'required valid date input') unless @start_date.present? && @end_date.present?

                render pdf: "summary_worker_certification",
                       template: 'internal/reports/finance/summary_worker_certification/_pdf_template.html.haml',
                       layout: "pdf.html",
                       margin: {
                           top: 50,
                           left: 12,
                           right: 12,
                           bottom: 10,
                       },
                       page_size: nil,
                       page_height: "29.7cm",
                       page_width: "21cm",
                       dpi: "300",
                       header: {
                           html: {
                               template: '/internal/reports/finance/summary_worker_certification/pdf_template_header'
                           }
                       }
            }
            format.xlsx do
                render xlsx: 'index', filename: "summary_worker_certification-#{@start_date}to#{@end_date}.xlsx",
                       template: 'internal/reports/finance/summary_worker_certification/index'
            end
        end
    end

    def detail_worker_certification
        @certification_date = params[:certification_date]
        return redirect_to(summary_worker_certification_internal_finance_reports_path, notice: 'required valid date input') unless @certification_date.present?

        @current = Time.now if @current.blank?
        @date = @current.strftime('%d/%m/%Y')
        @time = @current.strftime('%H:%M:%S %p')

        @certification_date = params[:certification_date]

        @branches = Organization.where(:org_type => ['BRANCH', 'HEADQUARTER']).select('id, code, name').order('name ASC')
        @branch = Organization.find(params[:organization_id])

        @organization_id = params[:organization_id]
        @headers = ['Date', 'Worker Code', 'Worker Name', 'Amount']

        @transactions = Transaction.joins(:order_item).joins("left join v_orders_order_items vooi on transactions.fw_gender != order_items.gender
and vooi.order_itemable_id = transactions.foreign_worker_id and vooi.order_itemable_type = 'ForeignWorker'
and vooi.fee_code = 'FOREIGN_WORKER_GENDER_AMENDMENT'
left join v_refunds_refund_items vrri on vrri.refund_itemable_id = transactions.foreign_worker_id and vrri.refund_itemable_type = 'ForeignWorker' and vrri.category = 'FOREIGN_WORKER_GENDER_AMENDMENT'")
        .select("transactions.*, coalesce(order_items.amount, 0) + coalesce(vooi.order_item_amount, 0) - coalesce(vrri.refund_item_amount, 0) as final_amount")
        .search_organization(params[:organization_id])

        if !params[:certification_date].blank?
            @transactions = @transactions.where("transactions.certification_date between ? and ?", params[:certification_date].to_date.beginning_of_day, params[:certification_date].to_date.end_of_day)
        end
        if !params[:gender].blank?
            @transactions = @transactions.where(fw_gender: params[:gender])
        end

        respond_to do |format|
            format.html {
                # @transactions = @transactions.page(params[:page])
                # .per(get_per)

                render "internal/reports/finance/detail_worker_certification/index"
            }
            format.pdf {
                render pdf: "detail_worker_certification-#{Time.now.strftime('%Y%m%d-%H%I%S')}",
                       template: 'internal/reports/finance/detail_worker_certification/pdf_template.html.erb',
                       layout: "pdf.html",
                       margin: {
                           top: 50,
                           left: 12,
                           right: 12,
                           bottom: 10,
                       },
                       page_size: nil,
                       page_height: "21cm",
                       page_width: "29.7cm",
                       dpi: "300",
                       header: {
                           html: {
                               template: '/internal/reports/finance/detail_worker_certification/pdf_template_header'
                           }
                       }
            }
            format.xlsx {
                render xlsx: 'index', filename: "detail_worker_certification-#{Time.now.strftime('%Y%m%d-%H%I%S')}.xlsx", template: 'internal/reports/finance/detail_worker_certification/index'
            }
        end
    end

    def summary_worker_registration
        set_date_time
        set_finance_filtering_variables

        @migration_date = '2020-10-28'.to_date
        if @start_date.present? && @end_date.present?
            if !((@start_date.to_date <= @migration_date && @end_date.to_date <= @migration_date) || (@start_date.to_date > @migration_date && @end_date.to_date > @migration_date))
                return redirect_to(summary_worker_registration_internal_finance_reports_path, error: 'Daterange cannot be in between of before and after migration')
            end
        end

        @headers = %w[Date Type Gender Count]
        @data, @stats = Report::SummaryWorkerRegistrationService.new(@start_date, @end_date, @branch_id,@migration_date).result if @start_date.present? && @end_date.present?

        respond_to do |format|
            format.html { render_finance_html }
            format.pdf do
                return redirect_to(summary_worker_registration_internal_finance_reports_path, notice: 'required valid date input') unless @start_date.present? && @end_date.present?

                render_finance_pdf
            end
            format.xlsx do
                render xlsx: 'index', filename: "summary_worker_registration-#{@start_date}to#{@end_date}.xlsx",
                       template: 'internal/reports/finance/summary_worker_registration/index'
            end
        end
    end

    def detail_worker_registration
        @paid_at = params[:paid_at]
        return redirect_to(summary_worker_registration_internal_finance_reports_path, notice: 'required valid date input') unless @paid_at.present?

        @current = Time.now if @current.blank?
        @date = @current.strftime('%d/%m/%Y')
        @time = @current.strftime('%H:%M:%S %p')

        @registration_date = params[:paid_at]

        @branches = Organization.where(:org_type => 'BRANCH').select('id, code, name').order('name ASC')
        @branch = Organization.find(params[:organization_id])

        @organization_id = params[:organization_id]
        @headers = ['Date', 'Worker Code', 'Worker Name', 'Amount']

        @order_items = OrderItem.joins(:order).joins(:fee)
        .joins("left join v_refunds_refund_items vrri on orders.category = 'TRANSACTION_CANCELLATION' and order_items.order_itemable_type = vrri.refund_itemable_type and order_items.order_itemable_id = vrri.refund_itemable_id and vrri.category = 'TRANSACTION_CANCELLATION'
        left join transactions t on order_items.order_itemable_id = t.id and order_items.order_itemable_type = 'Transaction'
        left join foreign_workers fw on order_items.order_itemable_id = fw.id and order_items.order_itemable_type = 'ForeignWorker'")
        .select("order_items.*, orders.category order_category, fees.code fee_code, orders.paid_at, coalesce(t.fw_code, fw.code) as fw_code, coalesce(t.fw_name, fw.name) fw_name, coalesce(vrri.refund_item_amount * -1, order_items.amount) final_amount")
        .where("orders.category in ('TRANSACTION_REGISTRATION', 'SPECIAL_RENEWAL_TRANSACTION_REGISTRATION', 'TRANSACTION_CANCELLATION', 'FOREIGN_WORKER_GENDER_AMENDMENT')
        and fees.code in ('FOC', 'FOREIGN_WORKER_GENDER_AMENDMENT', 'CANCEL_TRANSACTION', 'TRANSACTION_MALE', 'TRANSACTION_FEMALE')")
        .search_organization(params[:organization_id])

        if !params[:paid_at].blank?
            if !params[:category].blank? && params[:category] == 'TRANSACTION_REJECTION'
                @order_items = @order_items.where("order_items.refunded_at between ? and ?", params[:paid_at].to_date.beginning_of_day, params[:paid_at].to_date.end_of_day)
            else
                @order_items = @order_items.where("orders.paid_at between ? and ?", params[:paid_at].to_date.beginning_of_day, params[:paid_at].to_date.end_of_day)
            end
        end
        if !params[:gender].blank?
            @order_items = @order_items.where(gender: params[:gender])
        end
        if !params[:category].blank?
            case params[:category]
            when "TRANSACTION_REGISTRATION"
                @order_items = @order_items.where("orders.category" => ['TRANSACTION_REGISTRATION', 'SPECIAL_RENEWAL_TRANSACTION_REGISTRATION', 'FOREIGN_WORKER_GENDER_AMENDMENT'])
            when "GENDER_CHANGE"
                @order_items = @order_items.where("orders.category" => 'FOREIGN_WORKER_GENDER_AMENDMENT')
            when 'TRANSACTION_REJECTION'
                @order_items = @order_items.where("orders.category" => 'SPECIAL_RENEWAL_TRANSACTION_REGISTRATION')
            else
                @order_items = @order_items.where("orders.category" => params[:category])
            end
        end

        respond_to do |format|
            format.html {
                # @transactions = @transactions.page(params[:page])
                # .per(get_per)

                render "internal/reports/finance/detail_worker_registration/index"
            }
            format.pdf {
                render pdf: "detail_worker_registration-#{Time.now.strftime('%Y%m%d-%H%I%S')}",
                       template: 'internal/reports/finance/detail_worker_registration/pdf_template.html.erb',
                       layout: "pdf.html",
                       margin: {
                           top: 50,
                           left: 12,
                           right: 12,
                           bottom: 10,
                       },
                       page_size: nil,
                       page_height: "21cm",
                       page_width: "29.7cm",
                       dpi: "300",
                       header: {
                           html: {
                               template: '/internal/reports/finance/detail_worker_registration/pdf_template_header'
                           }
                       }
            }
            format.xlsx {
                render xlsx: 'index', filename: "detail_worker_registration-#{Time.now.strftime('%Y%m%d-%H%I%S')}.xlsx", template: 'internal/reports/finance/detail_worker_registration/index'
            }
        end
    end

    def summary_misc_income
        set_date_time
        set_finance_filtering_variables

        @migration_date = '2020-10-28'.to_date
        if @start_date.present? && @end_date.present?
            if !((@start_date.to_date <= @migration_date && @end_date.to_date <= @migration_date) || (@start_date.to_date > @migration_date && @end_date.to_date > @migration_date))
                return redirect_to(summary_misc_income_internal_finance_reports_path, error: 'Daterange cannot be in between of before and after migration')
            end
        end

        @headers = %w[Date Type Amount Count]
        @data, @stats = Report::SummaryMiscIncomeService.new(@start_date, @end_date, @branch_id, @migration_date).result if @start_date.present? && @end_date.present?

        respond_to do |format|
            format.html { render_finance_html }
            format.pdf { render_finance_pdf }
            format.xlsx { render_finance_xlsx }
        end
    end

    def portal_transactions
        set_date_time
        @start_date = params[:start_date].presence
        @end_date = params[:end_date].presence
        @customer_code = params[:customer_code]
        @invoice_number = params[:invoice_number]
        @transaction_id = params[:transaction_id]&.strip
        @payment_method_id = params[:payment_method]
        @headers = ['No.', 'Payment Date', 'Payment Method', 'Customer Code', 'Customer Name',
                    'Transaction ID', 'Invoice No', 'Subtotal Amount','Conv Fee',
                    'Total Amount']

        if @start_date.present? && @end_date.present?
            @orders =
                Order
                .joins(:creator, ipay88_requests: :ipay88_responses)
                .with_customer_code(@customer_code)
                .with_invoice_number(@invoice_number)
                .with_fpx_transaction_id(@transaction_id)
                .with_payment_method(@payment_method_id)
                .created_at_portal
                .where(status: 'PAID')
                .where('paid_at BETWEEN ? AND ?', @start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day)
                .where.not(ipay88_requests: { ipay88_responses: { payment_id: [nil, ''] } })
                .order('orders.paid_at')
                .decorate
                .reject { |order| order.latest_fpx_transaction_id.blank? || order.latest_payment_date.blank? }

                # ipay88
        end
        respond_to do |format|
            format.html { render_finance_html }
            format.pdf { render_portal_transaction_pdf }
            format.xlsx do
                render xlsx: 'index', filename: "portal_transactions-#{@start_date}to#{@end_date}.xlsx",
                       template: 'internal/reports/finance/portal_transactions/index'
            end
        end
    end

    def summary_doctor_certification
        @service_provider_groups = ServiceProviderGroup.where(category: 'Doctor').without_giro.pluck(:name, :id)
        respond_to do |format|
            format.html { render 'internal/reports/finance/summary_doctor_certification/index' }
            format.xlsx do
                @start_date = params[:certification_date_from]
                @end_date = params[:certification_date_to]
                @group = params[:group]
                @doctor_data, @state_data, @stats = Report::SummaryDoctorCertificationService.new(@start_date, @end_date, @group).result
                render xlsx: 'index', filename: "SummaryDoctorCertification-#{@group}-#{@start_date}to#{@end_date}.xlsx",
                       template: 'internal/reports/finance/summary_doctor_certification/index'
            end
        end
    end

    def doctor_certification_details
        @service_provider_groups = ServiceProviderGroup.where(category: 'Doctor').without_giro.pluck(:name, :id)
        respond_to do |format|
            format.html { render 'internal/reports/finance/doctor_certification_details/index' }
            format.xlsx do
                @start_date = params[:certification_date_from]
                @end_date = params[:certification_date_to]
                @group = params[:group]
                @service_provider_code = params[:service_provider_code].presence
                @doctor_data = Report::DoctorCertificationDetailService.new(@start_date, @end_date, @group, @service_provider_code).result
                render xlsx: 'index', filename: "DoctorCertificationDetails-#{@group_name}-#{@start_date}to#{@end_date}.xlsx",
                       template: 'internal/reports/finance/doctor_certification_details/index'
            end
        end
    end

    def summary_laboratory_certification
        @service_provider_groups = ServiceProviderGroup.where(category: 'Laboratory').without_giro.pluck(:name, :id)
        respond_to do |format|
            format.html { render 'internal/reports/finance/summary_laboratory_certification/index' }
            format.xlsx do
                @start_date = params[:certification_date_from]
                @end_date = params[:certification_date_to]
                @group = params[:group]
                @laboratory_data, @state_data, @stats = Report::SummaryLaboratoryCertificationService.new(@start_date, @end_date, @group).result
                render xlsx: 'index', filename: "SummaryLaboratoryCertification-#{@group}-#{@start_date}to#{@end_date}.xlsx",
                       template: 'internal/reports/finance/summary_laboratory_certification/index'
            end
        end
    end

    def laboratory_certification_details
        @service_provider_groups = ServiceProviderGroup.where(category: 'Laboratory').without_giro.pluck(:name, :id)
        respond_to do |format|
            format.html { render 'internal/reports/finance/laboratory_certification_details/index' }
            format.xlsx do
                @start_date = params[:certification_date_from]
                @end_date = params[:certification_date_to]
                @service_provider_code = params[:service_provider_code].presence
                @service_provider_group_code = params[:service_provider_group_code].presence
                @group = params[:group]
                @laboratory_data = Report::LaboratoryCertificationDetailService.new(@start_date, @end_date, @group, @service_provider_group_code, @service_provider_code).result
                render xlsx: 'index', filename: "LaboratoryCertificationDetails-#{@group}-#{@start_date}to#{@end_date}.xlsx",
                       template: 'internal/reports/finance/laboratory_certification_details/index'
            end
        end
    end

    def summary_xray_certification
        @service_provider_groups = ServiceProviderGroup.where(category: 'XrayFacility').without_giro.pluck(:name, :id)
        respond_to do |format|
            format.html { render 'internal/reports/finance/summary_xray_certification/index' }
            format.xlsx do
                @start_date = params[:certification_date_from]
                @end_date = params[:certification_date_to]
                @group = params[:group]
                @xray_facility_data, @state_data, @stats = Report::SummaryXrayFacilityCertificationService.new(@start_date, @end_date, @group).result
                render xlsx: 'index', filename: "SummaryXrayFacilityCertification-#{@group}-#{@start_date}to#{@end_date}.xlsx",
                       template: 'internal/reports/finance/summary_xray_certification/index'
            end
        end
    end

    def xray_certification_details
        @service_provider_groups = ServiceProviderGroup.where(category: 'XrayFacility').without_giro.pluck(:name, :id)
        respond_to do |format|
            format.html { render 'internal/reports/finance/xray_certification_details/index' }
            format.xlsx do
                @start_date = params[:certification_date_from]
                @end_date = params[:certification_date_to]
                @group = params[:group]
                @service_provider_code = params[:service_provider_code].presence
                @xray_facility_data = Report::XrayFacilityCertificationDetailService.new(@start_date, @end_date, @group, @service_provider_code).result
                render xlsx: 'index', filename: "XrayFacilityCertificationDetails-#{@group}-#{@start_date}to#{@end_date}.xlsx",
                       template: 'internal/reports/finance/xray_certification_details/index'
            end
        end
    end

    def xray_not_done_certifications
        @service_provider_groups = ServiceProviderGroup.where(category: 'XrayFacility').without_giro.pluck(:name, :id)
        respond_to do |format|
            format.html { render 'internal/reports/finance/xray_not_done_certifications/index' }
            format.xlsx do
                @start_date = params[:certification_date_from]
                @end_date = params[:certification_date_to]
                @group =  params[:group]
                @xray_facility_data = Report::XrayNotDoneCertificationService.new(@start_date, @end_date, @group).result
                render xlsx: 'index', filename: "XrayNotDone-#{@group}-#{@start_date}to#{@end_date}.xlsx",
                       template: 'internal/reports/finance/xray_not_done_certifications/index'
            end
        end
    end

    def laboratory_certification_by_gender
        respond_to do |format|
            format.html { render 'internal/reports/finance/laboratory_certification_by_gender/index' }
            format.xlsx do
                @start_date = params[:certification_date_from]
                @end_date = params[:certification_date_to]
                @laboratory_data = Report::LaboratoryCertificationGenderStatisticService.new(@start_date, @end_date).result
                render xlsx: 'index', filename: "LaboratoryReport-#{@start_date}to#{@end_date}.xlsx",
                       template: 'internal/reports/finance/laboratory_certification_by_gender/index'
            end
        end
    end

    def laboratory_not_done_certification
        @service_provider_groups = ServiceProviderGroup.where(category: 'Laboratory').without_giro.pluck(:name, :id)
        respond_to do |format|
            format.html { render 'internal/reports/finance/laboratory_not_done_certification/index' }
            format.xlsx do
                @start_date = params[:certification_date_from]
                @end_date = params[:certification_date_to]
                @group =  params[:group]
                @laboratory_data = Report::LaboratoryNotDoneCertificationService.new(@start_date, @end_date, @group).result
                render xlsx: 'index', filename: "LaboratoryNotDone-#{@group}-#{@start_date}to#{@end_date}.xlsx",
                       template: 'internal/reports/finance/laboratory_not_done_certification/index'
            end
        end
    end

    ## removed - finance decided not to have this report
    def summary_worker_insurance
        set_date_time
        @start_date = params[:start_date].presence
        @end_date = params[:end_date].presence
        @branch_id = params[:branch]
        @headers = ['Date', 'Type', 'Gender', 'Count', 'Amount (RM)']

        if @start_date && @end_date
            @data = OrderItem.joins(:order)
            .merge(Order.search_organization(@branch_id))
            .joins("JOIN organizations ON orders.organization_id = organizations.id")
            .where(orders:{paid_at: @start_date.to_date.beginning_of_day..@end_date.to_date.end_of_day})
            .get_insurance_gross_premium
            .select('organizations.name as branch_name, DATE(orders.paid_at) as paid_date , gender,count(*), sum(order_items.amount)')
            .group('branch_name, paid_date, gender')

            @grand_total_count = @data.map {|s| s['count']}.sum
            @grand_total_sum = @data.map {|s| s['sum']}.sum
            @grand_total_male = @data.map {|s| s['gender'] == 'M' ? s['count'] : 0}.sum
            @grand_total_female = @data.map {|s| s['gender'] == 'F' ? s['count'] : 0}.sum

            @data = @data.group_by {|x| x['branch_name']}
        end

        respond_to do |format|
            format.html { render_finance_html }
            format.xlsx do
                render_finance_xlsx
            end
        end
    end
    ## remove end

    def details_worker_insurance
        @current = Time.now if @current.blank?
        @date = @current.strftime('%d/%m/%Y')
        @start_date = params[:start_date].presence
        @end_date = params[:end_date].presence
        @branch_id = params[:branch]
        @insurance_service_provider_id = params[:insurance_service_provider_id]


        if @start_date && @end_date
            order_ids = OrderItem.joins(:order).get_insurance_fee.where(orders:{paid_at: @start_date.to_date.beginning_of_day..@end_date.to_date.end_of_day}).pluck('orders.id').uniq

            # @data = Order.search_organization(@branch_id).where(:id => order_ids).order('paid_at ASC')
            query = apply_scopes(Order).search_organization(@branch_id).where("orders.id in (?)", order_ids)

            if !@insurance_service_provider_id.blank?
                query = query.joins("JOIN insurance_purchases ON insurance_purchases.order_id = orders.id")
                .where("insurance_purchases.insurance_service_provider_id = #{@insurance_service_provider_id}")
            end

            @data = query.order('paid_at ASC')

            order_items = @data.joins(:order_items)
            @total_sst = order_items.merge(OrderItem.get_insurance_sst).sum('order_items.amount') || 0
            @total_stamp_duty = order_items.merge(OrderItem.get_insurance_stamp_duty).sum('order_items.amount') || 0
            @total_gross_premium = order_items.merge(OrderItem.get_insurance_gross_premium).sum('order_items.amount') || 0
            @total_adminfees = order_items.merge(OrderItem.get_insurance_adminfees).sum('order_items.amount') || 0
            @total_adminfees_sst = order_items.merge(OrderItem.get_insurance_adminfees_sst).sum('order_items.amount') || 0
            @total_premium_paid = [@total_sst,@total_stamp_duty,@total_gross_premium,@total_adminfees,@total_adminfees_sst].sum
        end

        respond_to do |format|
            format.html { render_finance_html }
            format.xlsx do
                render_finance_xlsx
            end
        end
    end

    def employer_account
        @closing_date = params[:closing_date].presence

        if @closing_date
            @closing_date = @closing_date.to_date.end_of_day
            sql = "SELECT employer_code,employers.name,SUM(amount) as amount
            FROM fomema_backup_nios.employer_account
            JOIN employers on employer_account.employer_code = employers.code
            WHERE creation_date <= '#{@closing_date}'
            GROUP BY employer_code, employers.name
            HAVING SUM(amount) != 0"

            @data = ActiveRecord::Base.connection.execute(sql)
        end

        respond_to do |format|
            format.html { render "internal/reports/finance/employer_account/index" }
            format.xlsx do
                render xlsx: 'index', filename: "employer-account-#{@closing_date}.xlsx",
                template: 'internal/reports/finance/employer_account/index'
            end
        end
    end

    def summary_transaction_expired_without_examination
        @current = Time.now if @current.blank?
        @date = @current.strftime('%d/%m/%Y')
        @time = @current.strftime('%H:%M:%S %p')

        @branches = Organization.where(:org_type => 'BRANCH').select('id,code,name').order('name ASC')
        @start_date = params[:start_date]
        @end_date = params[:end_date]
        @branch_id = params[:branch]
        @headers = ['Date', 'Gender', 'Count']
        @expired_transactions, @grand_total = Report::SummaryTransactionExpiredWithoutExaminationService.new(@start_date, @end_date, @branch_id).result if @start_date.present? && @end_date.present?

        respond_to do |format|
            format.html { render "internal/reports/finance/summary_transaction_expired_without_examination/index.html" }
            format.pdf {
                return redirect_to(summary_transaction_expired_without_examination_internal_finance_reports_path, notice: 'required valid date input') unless @start_date.present? && @end_date.present?

                render pdf: "summary_transaction_expired_without_examination",
                       template: 'internal/reports/finance/summary_transaction_expired_without_examination/_pdf_template.html.haml',
                       layout: "pdf.html",
                       margin: {
                           top: 50,
                           left: 12,
                           right: 12,
                           bottom: 10,
                       },
                       page_size: nil,
                       page_height: "29.7cm",
                       page_width: "21cm",
                       dpi: "300",
                       header: {
                           html: {
                               template: '/internal/reports/finance/summary_transaction_expired_without_examination/pdf_template_header'
                           }
                       }
            }
            format.xlsx do
                render xlsx: 'index', filename: "summary_transaction_expired_without_examination-#{@start_date}to#{@end_date}.xlsx",
                       template: 'internal/reports/finance/summary_transaction_expired_without_examination/index'
            end
        end
    end

    def detail_transaction_expired_without_examination
        @expired_at = params[:expired_at]
        return redirect_to(summary_transaction_expired_without_examination_internal_finance_reports_path, notice: 'required valid date input') unless @expired_at.present?

        @current = Time.now if @current.blank?
        @date = @current.strftime('%d/%m/%Y')
        @time = @current.strftime('%H:%M:%S %p')

        @expired_at = params[:expired_at]

        @branches = Organization.where(:org_type => ['BRANCH', 'HEADQUARTER']).select('id, code, name').order('name ASC')
        @branch = Organization.find(params[:organization_id])

        @organization_id = params[:organization_id]
        @headers = ['Date', 'Worker Code', 'Worker Name', 'Amount']

        @transactions = Transaction.joins(:order_item).joins("left join v_orders_order_items vooi on transactions.fw_gender != order_items.gender
        and vooi.order_itemable_id = transactions.foreign_worker_id and vooi.order_itemable_type = 'ForeignWorker'
        and vooi.fee_code = 'FOREIGN_WORKER_GENDER_AMENDMENT'
        left join v_refunds_refund_items vrri on vrri.refund_itemable_id = transactions.foreign_worker_id and vrri.refund_itemable_type = 'ForeignWorker' and vrri.category = 'FOREIGN_WORKER_GENDER_AMENDMENT'")
        .select("transactions.*, coalesce(order_items.amount, 0) + coalesce(vooi.order_item_amount, 0) - coalesce(vrri.refund_item_amount, 0) as final_amount")
        .search_organization(params[:organization_id])

        if !params[:expired_at].blank?
            @transactions = @transactions.where("transactions.expired_at between ? and ?", params[:expired_at].to_date.beginning_of_day, params[:expired_at].to_date.end_of_day)
            .where("transactions.medical_examination_date is null and transactions.certification_date is null")
            .where.not(status: ['REJECTED', 'CANCELLED'])
        end
        if !params[:gender].blank?
            @transactions = @transactions.where(fw_gender: params[:gender])
        end

        respond_to do |format|
            format.html {
                # @transactions = @transactions.page(params[:page])
                # .per(get_per)

                render "internal/reports/finance/detail_transaction_expired_without_examination/index"
            }
            format.pdf {
                render pdf: "detail_transaction_expired_without_examination-#{Time.now.strftime('%Y%m%d-%H%I%S')}",
                       template: 'internal/reports/finance/detail_transaction_expired_without_examination/pdf_template.html.erb',
                       layout: "pdf.html",
                       margin: {
                           top: 50,
                           left: 12,
                           right: 12,
                           bottom: 10,
                       },
                       page_size: nil,
                       page_height: "21cm",
                       page_width: "29.7cm",
                       dpi: "300",
                       header: {
                           html: {
                               template: '/internal/reports/finance/detail_transaction_expired_without_examination/pdf_template_header'
                           }
                       }
            }
            format.xlsx {
                render xlsx: 'index', filename: "detail_transaction_expired_without_examination-#{Time.now.strftime('%Y%m%d-%H%I%S')}.xlsx", template: 'internal/reports/finance/detail_transaction_expired_without_examination/index'
            }
        end
    end

    def summary_transaction_transmission_expired
        @current = Time.now if @current.blank?
        @date = @current.strftime('%d/%m/%Y')
        @time = @current.strftime('%H:%M:%S %p')

        @branches = Organization.where(:org_type => 'BRANCH').select('id,code,name').order('name ASC')
        @start_date = params[:start_date]
        @end_date = params[:end_date]
        @branch_id = params[:branch]
        @headers = ['Date', 'Gender', 'Count']
        @expired_transactions, @grand_total = Report::SummaryTransactionTransmissionExpiredService.new(@start_date, @end_date, @branch_id).result if @start_date.present? && @end_date.present?

        respond_to do |format|
            format.html { render "internal/reports/finance/summary_transaction_transmission_expired/index.html" }
            format.pdf {
                return redirect_to(summary_transaction_transmission_expired_internal_finance_reports_path, notice: 'required valid date input') unless @start_date.present? && @end_date.present?

                render pdf: "summary_transaction_transmission_expired",
                       template: 'internal/reports/finance/summary_transaction_transmission_expired/_pdf_template.html.haml',
                       layout: "pdf.html",
                       margin: {
                           top: 50,
                           left: 12,
                           right: 12,
                           bottom: 10,
                       },
                       page_size: nil,
                       page_height: "29.7cm",
                       page_width: "21cm",
                       dpi: "300",
                       header: {
                           html: {
                               template: '/internal/reports/finance/summary_transaction_transmission_expired/pdf_template_header'
                           }
                       }
            }
            format.xlsx do
                render xlsx: 'index', filename: "summary_transaction_transmission_expired-#{@start_date}to#{@end_date}.xlsx",
                       template: 'internal/reports/finance/summary_transaction_transmission_expired/index'
            end
        end
    end

    def detail_transaction_transmission_expired
        @transmission_expired_at = params[:transmission_expired_at]
        return redirect_to(summary_transaction_transmission_expired_internal_finance_reports_path, notice: 'required valid date input') unless @transmission_expired_at.present?

        @current = Time.now if @current.blank?
        @date = @current.strftime('%d/%m/%Y')
        @time = @current.strftime('%H:%M:%S %p')

        @transmission_expired_at = params[:transmission_expired_at]

        @branches = Organization.where(:org_type => ['BRANCH', 'HEADQUARTER']).select('id, code, name').order('name ASC')
        @branch = Organization.find(params[:organization_id])

        @organization_id = params[:organization_id]
        @headers = ['Date', 'Worker Code', 'Worker Name', 'Amount']

        @transactions = Transaction.joins(:order_item).joins("left join v_orders_order_items vooi on transactions.fw_gender != order_items.gender
        and vooi.order_itemable_id = transactions.foreign_worker_id and vooi.order_itemable_type = 'ForeignWorker'
        and vooi.fee_code = 'FOREIGN_WORKER_GENDER_AMENDMENT'
        left join v_refunds_refund_items vrri on vrri.refund_itemable_id = transactions.foreign_worker_id and vrri.refund_itemable_type = 'ForeignWorker' and vrri.category = 'FOREIGN_WORKER_GENDER_AMENDMENT'")
        .select("transactions.*, coalesce(order_items.amount, 0) + coalesce(vooi.order_item_amount, 0) - coalesce(vrri.refund_item_amount, 0) as final_amount")
        .search_organization(params[:organization_id])

        if !params[:transmission_expired_at].blank?
            @transactions = @transactions.where("transactions.transmission_expired_at between ? and ?", params[:transmission_expired_at].to_date.beginning_of_day, params[:transmission_expired_at].to_date.end_of_day)
            .where("transactions.medical_examination_date is not null and transactions.certification_date is null")
            .where.not(status: ['REJECTED', 'CANCELLED'])
        end
        if !params[:gender].blank?
            @transactions = @transactions.where(fw_gender: params[:gender])
        end

        respond_to do |format|
            format.html {
                # @transactions = @transactions.page(params[:page])
                # .per(get_per)

                render "internal/reports/finance/detail_transaction_transmission_expired/index"
            }
            format.pdf {
                render pdf: "detail_transaction_transmission_expired-#{Time.now.strftime('%Y%m%d-%H%I%S')}",
                       template: 'internal/reports/finance/detail_transaction_transmission_expired/pdf_template.html.erb',
                       layout: "pdf.html",
                       margin: {
                           top: 50,
                           left: 12,
                           right: 12,
                           bottom: 10,
                       },
                       page_size: nil,
                       page_height: "21cm",
                       page_width: "29.7cm",
                       dpi: "300",
                       header: {
                           html: {
                               template: '/internal/reports/finance/detail_transaction_transmission_expired/pdf_template_header'
                           }
                       }
            }
            format.xlsx {
                render xlsx: 'index', filename: "detail_transaction_transmission_expired-#{Time.now.strftime('%Y%m%d-%H%I%S')}.xlsx", template: 'internal/reports/finance/detail_transaction_transmission_expired/index'
            }
        end
    end

    def daily_refund_payment_failed_reminder
        @csv = [Report::DailyRefundPaymentFailedService.headers]
        @query_date = params[:query_date]

        if @query_date.present?
            @csv = Report::DailyRefundPaymentFailedService.new(@query_date.to_datetime).csv_result
        end

        @filter_options = [{ type: "date", label: "Refund Updated Date" }]
        parse_output_format("Refund Payment Failed Report")
    end

    private

    def set_company_name
        @company_name = SystemConfiguration.find_by(code: 'COMPANY_NAME')&.value
    end

    def set_finance_filtering_variables
        @start_date = params[:start_date].presence
        @end_date = params[:end_date].presence
        @branch_id = params[:branch].presence
        @branches = Organization.where(org_type: 'BRANCH').select('id,code,name').order('name ASC')
    end

    def set_branches
        @branches = Organization.where(:org_type => 'BRANCH')
    end

    def render_finance_html
        render "internal/reports/finance/#{action_name}/index"
    end

    def render_finance_pdf
        render pdf: action_name,
               template: "internal/reports/finance/#{action_name}/_pdf_template.html.haml",
               header: {
                   html: {
                       template: "internal/reports/finance/#{action_name}/pdf_template_header"
                   }
               },
               **default_pdf_options
    end

    def render_finance_xlsx
        render xlsx: 'index',
               filename: "#{action_name}-#{@start_date}to#{@end_date}.xlsx",
               template: "internal/reports/finance/#{action_name}/index"
    end

    def service_provider_group_code(group_code)
        return group_code if group_code == 'ALL' || group_code == 'NON-GROUP'

        ServiceProviderGroup.find(group_code).name
    end

    # no bank account - cash order
    # group should use group online and cash order count
    def query_payment_mode_statistic(service_provider)
        sp_name = service_provider.model_name.plural
        service_provider.joins(:payment_method)
        .joins("left join service_provider_groups on #{sp_name}.service_provider_group_id = service_provider_groups.id")
        .joins("left join payment_methods as group_payment_method on service_provider_groups.payment_method_id = group_payment_method.id")
        .select("SUM(CASE WHEN (#{sp_name}.bank_account_number is null OR payment_methods.code IN ('OUT_CASHORDER','OUT_CHEQUE')) AND #{sp_name}.status = 'ACTIVE' AND service_provider_group_id is null THEN 1 ELSE 0 END) AS cash_order_active_non_group,
        SUM(CASE WHEN (#{sp_name}.bank_account_number is null OR payment_methods.code IN ('OUT_CASHORDER','OUT_CHEQUE')) AND #{sp_name}.status != 'ACTIVE' AND service_provider_group_id is null THEN 1 ELSE 0 END) AS cash_order_inactive_non_group,
        SUM(CASE WHEN (#{sp_name}.bank_account_number is null OR payment_methods.code IN ('OUT_CASHORDER','OUT_CHEQUE')) AND service_provider_group_id is null THEN 1 ELSE 0 END) AS cash_order_total_non_group,

        SUM(CASE WHEN (#{sp_name}.bank_account_number is not null AND payment_methods.code IN ('OUT_GIROROC','OUT_GIRONEWIC','OUT_GIROPASSPORT')) AND #{sp_name}.status = 'ACTIVE' AND service_provider_group_id is null THEN 1 ELSE 0 END) AS online_active_non_group,
        SUM(CASE WHEN (#{sp_name}.bank_account_number is not null AND payment_methods.code IN ('OUT_GIROROC','OUT_GIRONEWIC','OUT_GIROPASSPORT')) AND #{sp_name}.status != 'ACTIVE' AND service_provider_group_id is null THEN 1 ELSE 0 END) AS online_inactive_non_group,
        SUM(CASE WHEN (#{sp_name}.bank_account_number is not null AND payment_methods.code IN ('OUT_GIROROC','OUT_GIRONEWIC','OUT_GIROPASSPORT')) AND service_provider_group_id is null THEN 1 ELSE 0 END) AS online_total_non_group,

        SUM(CASE WHEN (service_provider_groups.bank_account_number is null OR group_payment_method.code IN ('OUT_CASHORDER','OUT_CHEQUE')) AND #{sp_name}.status = 'ACTIVE' AND service_provider_group_id is not null THEN 1 ELSE 0 END) AS cash_order_active_group,
        SUM(CASE WHEN (service_provider_groups.bank_account_number is null OR group_payment_method.code IN ('OUT_CASHORDER','OUT_CHEQUE')) AND #{sp_name}.status != 'ACTIVE' AND service_provider_group_id is not null THEN 1 ELSE 0 END) AS cash_order_inactive_group,
        SUM(CASE WHEN (service_provider_groups.bank_account_number is null OR group_payment_method.code IN ('OUT_CASHORDER','OUT_CHEQUE')) AND service_provider_group_id is not null THEN 1 ELSE 0 END) AS cash_order_total_group,

        SUM(CASE WHEN (service_provider_groups.bank_account_number is not null AND group_payment_method.code IN ('OUT_GIROROC','OUT_GIRONEWIC','OUT_GIROPASSPORT')) AND #{sp_name}.status = 'ACTIVE' AND service_provider_group_id is not null THEN 1 ELSE 0 END) AS online_active_group,
        SUM(CASE WHEN (service_provider_groups.bank_account_number is not null AND group_payment_method.code IN ('OUT_GIROROC','OUT_GIRONEWIC','OUT_GIROPASSPORT')) AND #{sp_name}.status != 'ACTIVE' AND service_provider_group_id is not null THEN 1 ELSE 0 END) AS online_inactive_group,
        SUM(CASE WHEN (service_provider_groups.bank_account_number is not null AND group_payment_method.code IN ('OUT_GIROROC','OUT_GIRONEWIC','OUT_GIROPASSPORT')) AND service_provider_group_id is not null THEN 1 ELSE 0 END) AS online_total_group
        ")
    end

    def payment_mode_statistic_mapping(statistics)
        online_active_group = statistics&.online_active_group || 0
        online_inactive_group = statistics&.online_inactive_group || 0
        online_active_non_group = statistics&.online_active_non_group || 0
        online_inactive_non_group = statistics&.online_inactive_non_group || 0
        cash_order_active_group = statistics&.cash_order_active_group || 0
        cash_order_inactive_group = statistics&.cash_order_inactive_group || 0
        cash_order_active_non_group = statistics&.cash_order_active_non_group || 0
        cash_order_inactive_non_group = statistics&.cash_order_inactive_non_group || 0

        online_total_non_group = statistics&.online_total_non_group || 0
        online_total_group = statistics&.online_total_group || 0
        cash_order_total_non_group = statistics&.cash_order_total_non_group || 0
        cash_order_total_group = statistics&.cash_order_total_group || 0

        online_row = [
          online_active_group,
          online_inactive_group,
          online_total_group,
          online_active_non_group,
          online_inactive_non_group,
          online_total_non_group
        ]

        cash_order_row = [
          cash_order_active_group,
          cash_order_inactive_group,
          cash_order_total_group,
          cash_order_active_non_group,
          cash_order_inactive_non_group,
          cash_order_total_non_group
        ]

        online_row << [online_active_group,online_inactive_group,online_active_non_group,online_inactive_non_group].sum
        cash_order_row << [cash_order_active_group,cash_order_inactive_group,cash_order_active_non_group,cash_order_inactive_non_group].sum

        grand_total = [online_row, cash_order_row].transpose.map(&:sum)

        [online_row.insert(0,'Online'),cash_order_row.insert(0,'Cashier Order'), grand_total.insert(0,'Grand Total')]
    end

    def render_portal_transaction_pdf
        render pdf: action_name,
            template: "internal/reports/finance/#{action_name}/_pdf_template.html.haml",
            header: {
                html: {
                    template: "internal/reports/finance/#{action_name}/pdf_template_header"
                }
            },
            layout: 'pdf.html',
            margin: {
                top: 34,
                left: 12,
                right: 12,
                bottom: 10,
            },
            page_size: nil,
            page_height: '21cm',
            page_width: '29.7cm',
            dpi: '300'
    end
end
