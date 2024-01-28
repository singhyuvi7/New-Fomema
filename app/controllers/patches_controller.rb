class PatchesController < InternalController
    include OrderPaymentUpdate
    include Approvalable



    def patch_external_transactions

        if params[:passcode] == 'dev_patch'
            if params[:order_code].blank?
                render plain: 'order_code is needed' and return
            end

            order_code = params[:order_code]
            @order = Order.find_by_code(order_code)

            if @order.blank?
                render plain: 'order invalid' and return
            end

            if !['PAID'].include?(@order.status)
                @order.status = 'PAID'
                @order.save

                case @order.category
                when "TRANSACTION_REGISTRATION"
                    payment_update_transaction_registration
                when "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION"
                    payment_update_special_renewal_transaction_registration
                when "AGENCY_REGISTRATION"
                    payment_update_agency_registration
                when "AGENCY_RENEWAL"
                    payment_update_agency_renewal
                end
            end
        else
            render plain: 'passcode is required' and return
        end
        render plain: 'done' and return
    end
end
# /class