class External::XrayImagesController < ExternalController
    include XrayWebServiceHelper

    before_action -> { can_access?("DELETE_DIGITAL_XRAY_IMAGE_FROM_SALINEE") }

    def index
    end

    def search_image
        transaction = Transaction.find_by(code: params[:transaction_code])
        transaction ||= XrayRetake.find_by(code: params[:transaction_code])
        response    = search_image_response(transaction)
        render json: response, status: :ok
    end

    def delete_image
        transaction = Transaction.find_by(code: params[:confirm_delete_transaction_code])
        transaction ||= XrayRetake.find_by(code: params[:confirm_delete_transaction_code])
        remarks     = params[:remarks].strip
        redirect_to external_xray_images_path(worker_code: params[:confirm_delete_transaction_code]), error: "Remarks cannot be blank." and return if remarks.blank?
        redirect_to external_xray_images_path(worker_code: params[:confirm_delete_transaction_code]), error: "An error has occured. Could not find transaction by the code: #{ params[:confirm_delete_transaction_code] }" and return if transaction.blank?
        response    = search_image_response(transaction)

        if response[:timeout]
            render "shared/timeout_error_page", layout: false and return
        elsif response[:assigned_to_radiologist]
            flash[:error]   = "This transaction has been assigned to a radiologist. Unable to delete."
        elsif response[:exam_is_completed]
            flash[:error]   = "The examination results for this transaction have been submitted. Unable to delete."
        elsif response[:transaction_does_not_belong]
            flash[:error]   = "This transaction does not belong to you."
        elsif response[:images_not_found]
            flash[:error]   = "Could not find Digital Xray Images for Transaction #{ transaction.code }."
        elsif response[:images_found]
            xray_examination    = transaction.xray_examination
            xray_webservice     = XrayWebService.new(code: xray_examination.xray_ref_number, user_id: current_user.id, source: xray_examination.sourceable)
            result_code         = xray_webservice.delete_study(remarks)

            if result_code == :timeout_error
                render "shared/timeout_error_page", layout: false and return
            else
                xray_examination.update(upload_status: nil, xray_taken_date: nil, digital_xray_available: false)
                transaction.update(digital_xray_provider_id: nil)
            end

            flash[:notice]  = "Digital Xray Images for #{ transaction.code } has been deleted."
        else
            flash[:error]   = "An unexpected error has occured. Please contact Fomema for followup action."
        end

        redirect_to external_xray_images_path
    end
private
    def search_image_response(transaction)
        if transaction.present?
            worker          = transaction.foreign_worker
            is_transmitted  = transaction.class.to_s == "Transaction" ? transaction.xray_transmit_date? : transaction.completed_at?

            # Checking for existing transactions which fit the criteria:
            # 1. Belongs to xray user; 2. Not yet assigned to radiologist; 3. Still in examination phase (not yet submitted).
            if transaction.xray_facility_id != current_user.userable_id
                return { transaction_does_not_belong: true }
            elsif transaction.radiologist_id?
                return { assigned_to_radiologist: true }
            elsif is_transmitted
                return { exam_is_completed: true }
            end

            result_code = checking_digital_xray_available(transaction.xray_examination&.id)

            if result_code == :timeout_error
                return { timeout: true }
            elsif result_code
                return { images_found: true, worker_name: worker.name, worker_code: worker.code }
            else
                return { images_not_found: true, worker_name: worker.name, worker_code: worker.code }
            end
        else
            return { transaction_not_found: true }
        end
    end
end