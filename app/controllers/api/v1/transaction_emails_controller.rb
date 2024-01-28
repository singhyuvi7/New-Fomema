class Api::V1::TransactionEmailsController < ApplicationController
    protect_from_forgery unless: -> { request.format.json? }
    before_action :authenticate

    def patch_email_sent
        if params[:transaction_id].blank?
            render plain: 'transaction_id is needed' and return
        end

        if params[:send_type].blank?
            render plain: 'send_type is needed' and return
        end

        transaction = Transaction.find_by(id: params[:transaction_id])
        send_type = params[:send_type]
        employer_email = transaction.employer.email

        TransactionEmail.create(transaction_id: transaction.id, send_type: send_type, email: employer_email)

        render plain: 'done' and return
    end

private
    def authenticate
        system_token = ENV['IT_API_TOKEN'] || 'fomema2308'
        authenticate_or_request_with_http_token do |token, options|
            ActiveSupport::SecurityUtils.secure_compare(token, system_token)
        end
    end
end
