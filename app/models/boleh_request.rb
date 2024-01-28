require 'boleh'

class BolehRequest < ApplicationRecord
    include CaptureAuthor
    include Sequence

    after_create :update_signature

    belongs_to :order
    has_many :boleh_responses

    def update_signature
        exorderno = ex_order_number.blank? ? generate_ex_order_number : ex_order_number
        signature_string = [order_number, ActionController::Base.helpers.number_to_currency(amount, unit: ''), Boleh.api_key].join("")

        self.update({
            ex_order_number: exorderno,
            signature: Boleh.sha256(signature_string)
        })
    end

    def update_document_number
        self.update_columns({
            document_number: generate_document_number
        })
    end

    def generate_document_number
        "#{self.created_at.strftime('%Y%m%d')}#{get_or_create_sequence('collection_document_number_seq')}"
    end

    def generate_ex_order_number
        sequence_name = "boleh_exorderno_seq"
        sprintf("#{ENV['BOLEH_REFERENCE_NUMBER_PREFIX']}#{Time.now.strftime("%Y%m%d")}%06d", get_or_create_sequence("#{sequence_name}"))
    end

    def transaction_id
        return if boleh_responses.blank?
        return if boleh_responses.success.blank?

        boleh_responses.success.last.transaction_id
    end

    def has_success_ar_response?
        BolehRequest.find_by(msg_type: 'AR', order_number: order_number).boleh_responses.success.count > 0
    end

    def has_success_ae_response?
        return false if BolehRequest.find_by(msg_type: 'AE', order_number: order_number).blank?

        BolehRequest.find_by(msg_type: 'AE', order_number: order_number).boleh_responses.success.count > 0
    end

    def has_success_response?
        has_success_ar_response? || has_success_ae_response?
    end

    def has_pending_response?
        BolehRequest.find_by(order_number: order_number).boleh_responses.pending.count > 0
    end

    def has_failed_response?
        BolehRequest.find_by(order_number: order_number).boleh_responses.failed.count > 0
    end

    def has_sync_date?
        BolehRequest.where(order_number: order_number).where.not(sync_date: [nil]).count > 0
    end
end