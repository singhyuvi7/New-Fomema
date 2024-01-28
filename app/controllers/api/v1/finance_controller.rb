class Api::V1::FinanceController < ApplicationController
    protect_from_forgery unless: -> { request.format.json? }
    include Validate

    before_action :authenticate
    before_action :validate_params

    # APINVOICEBATCHES API (refund and payment)
    def ap_invoices_update
        batch_id = params[:batch_id]
        list = params[:list]
        error = false

        invoice_batch = ApInvoiceBatch.find_by_batch_number(batch_id)
        invoice_batchable_type = invoice_batch.batchable_type
        invoice_batchable = invoice_batch.batchable

        # all use vendor code

        if ['FinBatch'].include? invoice_batchable_type
            vendor_types = ['Doctor','XrayFacility','Laboratory','ServiceProviderGroup']
            batch_id = invoice_batchable.id
            failed_payment = []

            list.each do |data|

                code = data['code']
                vendor = nil
                current_vendor_type = ''
                vendor_types.each do |vendor_type|
                    current_vendor_type = vendor_type
                    vendor = vendor_type.constantize.model_name.singular.classify.constantize.where(:code => code).first
                    break if vendor.present?
                end

                if vendor.present?
                    sp_fin_batch = SpFinBatch.where(:fin_batch_id => batch_id, :batchable_id => vendor.id, :batchable_type => current_vendor_type).first

                    if !sp_fin_batch.blank? && sp_fin_batch&.status != 'SUCCESS'
                        sp_fin_batch.status = data['status'] == 'F' ? 'FAILED' : 'SUCCESS'
                        sp_fin_batch.fail_reason = data['reason']
                        sp_fin_batch.save!

                        failed_payment << sp_fin_batch&.id
                    end
                else
                    # error
                    error = true
                end
            end
        elsif ['RefundBatch'].include? invoice_batchable_type
            vendor_types = ['Employer','Doctor','XrayFacility','Laboratory','Agency']
            refund_batch_id = invoice_batchable.id
            customers = []

            list.each do |data|

                code = data['code']
                vendor = nil
                current_vendor_type = ''
                vendor_types.each do |vendor_type|
                    current_vendor_type = vendor_type
                    vendor = vendor_type.constantize.model_name.singular.classify.constantize.where(:code => code).first
                    break if vendor.present?
                end

                if vendor.present?
                    refund = Refund.where(:customerable_id => vendor.id, :customerable_type => current_vendor_type, :refund_batch_id => refund_batch_id)
                    customer = "#{current_vendor_type}#{vendor.id}"

                    if !refund.blank? && refund.first&.status != 'PAYMENT_SUCCESS' && !customers.include?(customer)
                        refund.update({
                            status: data['status'] == 'F' ? 'PAYMENT_FAILED' : 'PAYMENT_SUCCESS',
                            fail_reason: data['reason'],
                            updated_at: Time.now    # to set the updated date to the monitoring date if there is no changes on status and fail_reason
                        })
                    end
                    customers << customer
                end
            end
        elsif ['InsurancePaymentBatch'].include? invoice_batchable_type
            vendor_codes = SystemConfiguration.where(:code => ['HOWDEN_CODE','FGSB_CODE','TFSB_CODE']).pluck(:value)

            list.each do |data|
                code = data['code']
                vendor = SystemConfiguration.find_by(:value => code)

                if !vendor.blank?
                    invoice_batchable.ip_invoices.where(:payment_to => vendor.code).update({
                        status: data['status'] == 'F' ? 'FAILED' : 'SUCCESS',
                        fail_reason: data['reason']
                    })
                end
            end
        else
            # refunds
            vendor_types = ['Employer','Doctor','XrayFacility','Laboratory','Agency']
            refund_id = invoice_batchable.id
            list.each do |data|

                code = data['code']
                vendor = nil
                current_vendor_type = ''
                vendor_types.each do |vendor_type|
                    current_vendor_type = vendor_type
                    vendor = vendor_type.constantize.model_name.singular.classify.constantize.where(:code => code).first
                    break if vendor.present?
                end

                if vendor.present?
                    refund = Refund.where(:id => refund_id, :customerable_id => vendor.id, :customerable_type => current_vendor_type).first

                    if !refund.blank? && refund&.status != 'PAYMENT_SUCCESS'
                        refund.status = data['status'] == 'F' ? 'PAYMENT_FAILED' : 'PAYMENT_SUCCESS'
                        refund.fail_reason = data['reason']
                        refund.save
                    end
                end
            end
        end

        response = { status: 'success', message: 'success', error: {} }
        full_response = render json: response
        log_api('ap_invoices_update',params,response,full_response)

        full_response and return
    end

private
      def validate_params
        parameters = Validate::APInvoiceBatches.new(params)
        if !parameters.valid?
            errors = { error: parameters.errors }
            full_response = render json: { status: 'error', message: 'Validation Failed', error: parameters.errors }, status: :bad_request
            log_api('ap_invoices_update',params,errors,full_response)
            full_response and return
        end
      end

      def log_api(method, params, response, full_response)

        log_data = {
            :name => self.class.name,
            :api_type => 'REST_API',
            :request_type => 'INCOMING',
            :method => method,
            :params => params,
            :response => response,
            :full_response => full_response,
        }

        api_log = ApiLog.create(log_data)
    end

    def authenticate
        system_token = ENV['FINANCE_API_TOKEN'] || 'fomema'
        authenticate_or_request_with_http_token do |token, options|
            ActiveSupport::SecurityUtils.secure_compare(token, system_token)
        end
    end
end
