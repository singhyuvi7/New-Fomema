class Internal::InsurancePaymentsController < InternalController
    include Sage

    skip_before_action :verify_authenticity_token, :only => [:process_payment]

    before_action :set_batch, only: [:show, :destroy, :process_payment, :export]
    before_action :check_batch_date, only: [:create]
    before_action :set_payment_to, only: [:show, :export]

    def index
        @batches = InsurancePaymentBatch
        .search_code(params[:code])
        .search_status(params[:status])
        .search_date_range(params[:batch_date_start],params[:batch_date_end])
        .group(:id)
        .order('code desc')
        .page(params[:page])
        .per(get_per)
    end

    def new
        @pass_dates = InsurancePaymentBatch.select("to_char(start_date, 'YYYY-MM-DD') as from, to_char(end_date, 'YYYY-MM-DD') as to").as_json(:except => :id)
    end

    def create
        # nios insurance enhancement - One invoice for one order
        # create invoice based on payment method (to exclude those payment methods which are paid to FGSB)
        # to pay full insurance amount to FGSB
        # Refer to "SAGE-BolehPay Integration" email date 21/10/2022, create invoice to SAGE system for FPX and BolehPay

        default_status = 'NOT_PROCESS'
        start_date = params[:start_date]
        end_date = params[:end_date]

        #commission_percentage = SystemConfiguration.find_by(code: 'INSURANCE_COMMISSION')&.value&.to_d || 0

        # order_ids = Order.joins("JOIN insurance_purchases ON orders.id = insurance_purchases.order_id")
        # .where('orders.paid_at BETWEEN ? AND ?', start_date.to_date.beginning_of_day, end_date.to_date.end_of_day)
        # .where("orders.status = 'PAID' and insurance_purchases.is_collection = true").select('orders.id').distinct
        order_ids = Order.joins("JOIN insurance_purchases ON orders.id = insurance_purchases.order_id")
        .where('orders.paid_at BETWEEN ? AND ?', start_date.to_date.beginning_of_day, end_date.to_date.end_of_day)
        .where("orders.status = 'PAID'")
        .joins("JOIN payment_methods ON orders.payment_method_id = payment_methods.id")
        .where("payment_methods.code not in ('SWIPE_CC', 'SWIPE_EWALLET', 'SWIPE_FPX_B2C', 'SWIPE_FPX_B2B', 'IPAY_CC', 'IPAY_EWALLET', 'IPAY_FPX_B2C', 'IPAY_FPX_B2B')")
        .select('orders.id').distinct

        if order_ids.blank?
            flash[:error] = "No insurance purchased in the date range selected"
            redirect_to (request.env["HTTP_REFERER"] || new_internal_insurance_payment_path) and return
        end

        @insurance_payment_batch = InsurancePaymentBatch.create({
            start_date: start_date,
            end_date: end_date,
            status: default_status
        })

        insurance_payments = InsurancePayment.where(:order_id => order_ids)     # insurance_payments inserted upon order PAID

        insurance_payments.each do |insurance_payment|
            insurance_purchases = insurance_payment&.order&.insurance_purchases
            total_premium = insurance_purchases&.sum(&:total_premium) || 0
            total_gross_premium = insurance_purchases&.sum(&:gross_premium) || 0
            # commission = ("%.2f" % ((insurance_payment.commission_percentage/100)*total_gross_premium)).to_f
            # ipay_charges =  ("%.2f" % ((insurance_payment.transaction_fee/100)*total_premium)).to_f

            # total_payment_amount = [total_premium,(commission*-1),(ipay_charges*-1)].sum
            total_payment_amount = [total_premium].sum

            insurance_payment.update({
                insurance_payment_batch_id: @insurance_payment_batch.id,
                total_premium: total_premium,
                total_gross_premium: total_gross_premium,
                # commission: commission,
                # ipay_charges: ipay_charges,
                total_payment_amount: total_payment_amount
            })
        end

        # insurance_payments = InsurancePayment.joins(:order)
        # .select('insurance_payment_batch_id, DATE(orders.paid_at) as paid_date, sum(total_payment_amount) as total_insurance, sum(commission) as total_commission')
        # .where('orders.paid_at BETWEEN ? AND ?', start_date.to_date.beginning_of_day, end_date.to_date.end_of_day).group('insurance_payment_batch_id, paid_date')
        insurance_payments = InsurancePayment.joins(:order)
        .select('insurance_payment_batch_id, DATE(orders.paid_at) as paid_date, total_payment_amount as total_insurance, orders.code as order_code, orders.insurance_service_provider_id')
        .where('orders.paid_at BETWEEN ? AND ?', start_date.to_date.beginning_of_day, end_date.to_date.end_of_day)
        .joins("JOIN payment_methods ON orders.payment_method_id = payment_methods.id")
        .where("payment_methods.code not in ('SWIPE_CC', 'SWIPE_EWALLET', 'SWIPE_FPX_B2C', 'SWIPE_FPX_B2B', 'IPAY_CC', 'IPAY_EWALLET', 'IPAY_FPX_B2C', 'IPAY_FPX_B2B')")

        insurance_payments.each do |insurance_payment|
            # IpInvoice.create({
            #     batchable_id: insurance_payment.insurance_payment_batch_id,
            #     batchable_type: 'InsurancePaymentBatch',
            #     payment_to: 'HOWDEN_CODE',
            #     payment_date: insurance_payment.paid_date,
            #     total_amount: insurance_payment.total_insurance,
            #     status: default_status
            # })

            ins_provider = InsuranceServiceProvider.find_by(id: insurance_payment.insurance_service_provider_id)
            payment_to = ins_provider.payment_to_code

            IpInvoice.create({
                batchable_id: insurance_payment.insurance_payment_batch_id,
                batchable_type: 'InsurancePaymentBatch',
                payment_to: payment_to,
                payment_date: insurance_payment.paid_date,
                # total_amount: insurance_payment.total_commission,
                total_amount: insurance_payment.total_insurance,
                document_number: "I#{insurance_payment.order_code}",
                status: default_status
            })
        end

        respond_to do |format|
            format.html { redirect_to internal_insurance_payment_path(@insurance_payment_batch), notice: "Insurance Payment Batch #{@insurance_payment_batch.code} successfully created" }
        end
    end

    def show
    end

    def destroy
        @batch.insurance_payments.update({
            insurance_payment_batch_id: nil
        })
        @batch.ip_invoices.destroy_all
        @batch.destroy

        respond_to do |format|
            format.html { redirect_to internal_insurance_payments_path, notice: "Insurance payment batch #{@batch.code} was successfully destroyed." }
            format.json { head :no_content }
        end
    end

    def process_payment
        if ['NOT_PROCESS'].include? @batch.status
            @batch.ip_invoices.where(:status => ['NOT_PROCESS','PROCESS_FAILED']).update({
                status: 'PROCESSING'
            })
            InsurancePaymentWorker.perform_async(@batch.id)

            notice = "PROCESSING PAYMENT(S)"
        else
            notice = "UNABLE TO PROCESS PAYMENT"
        end
        redirect_back fallback_location: internal_insurance_payment_path(@batch), notice: notice
    end

    def export
        filename = "Insurance_Payment_Batch_#{@batch&.code} (#{@batch.start_date.strftime("%Y%m%d")} - #{@batch.end_date.strftime("%Y%m%d")}).xlsx"
        respond_to do |format|
            format.xlsx { render xlsx: "index" , filename: filename, template: 'internal/insurance_payments/index' }
        end
    end

private
    def set_batch
        @batch = InsurancePaymentBatch.find(params[:id])
    end

    def check_batch_date
        batches = InsurancePaymentBatch.where.not('DATE(insurance_payment_batches.end_date) < ? or DATE(insurance_payment_batches.start_date) > ?', params[:start_date], params[:end_date])

        if !batches.blank?
            flash[:error] = "Date selected has already exist in other batch"
            redirect_to (request.env["HTTP_REFERER"] || new_internal_insurance_payment_path) and return
        end
    end

    def set_payment_to
        @payment_to = @batch.ip_invoices.pluck(:payment_to).uniq
    end
end