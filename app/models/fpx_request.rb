require 'fpx'

class FpxRequest < ApplicationRecord
    include CaptureAuthor
    include Sequence

    after_create :update_checksum

    belongs_to :order
    has_many :fpx_responses

    # PAYMENT_METHOD = { b2c: '01', b2b: '02'}.freeze

    def update_checksum
        exorderno = seller_ex_order_no.blank? ? generate_seller_ex_order_no : seller_ex_order_no

        checksum_source_string = "||#{buyer_bank_id}|#{buyer_email}|||#{buyer_name}||#{msg_token}|#{msg_type}|#{product_description}|#{seller_bank_code}|#{seller_ex_id}|#{exorderno}|#{seller_id}|#{seller_order_no}|#{seller_txn_time}|#{ActionController::Base.helpers.number_to_currency(txn_amount, unit: "", delimiter: "")}|#{txn_currency}|#{version}"

        Rails.logger.info "checksum = #{checksum_source_string}"

        self.update({
            seller_ex_order_no: exorderno,
            checksum: Fpx.sha1(checksum_source_string).upcase
        })
    end

    def update_document_number
        self.update_columns({
            document_number: generate_document_number
        })
    end

    def generate_seller_ex_order_no
        sequence_name = "fpx_sellerexorderno_seq"
        sprintf("#{ENV['FPX_SELLER_EX_ORDER_NO_PREFIX']}#{Time.now.strftime("%Y%m%d")}%06d", get_or_create_sequence("#{sequence_name}"))
    end

    def generate_document_number
        "#{self.created_at.strftime('%Y%m%d')}#{get_or_create_sequence('collection_document_number_seq')}"
    end

    def fpx_txn_id
        return if fpx_responses.blank?
        return if fpx_responses.success.blank?

        fpx_responses.success.last.fpx_txn_id
    end

    def has_success_ar_response?
        FpxRequest.find_by(msg_type: 'AR', seller_order_no: seller_order_no, seller_ex_order_no: seller_ex_order_no).fpx_responses.success.count > 0
    end

    def has_success_ae_response?
        return false if FpxRequest.find_by(msg_type: 'AE', seller_order_no: seller_order_no, seller_ex_order_no: seller_ex_order_no).blank?

        FpxRequest.find_by(msg_type: 'AE', seller_order_no: seller_order_no, seller_ex_order_no: seller_ex_order_no).fpx_responses.success.count > 0
    end

    def has_success_response?
        has_success_ar_response? || has_success_ae_response?
    end

    def has_pending_response?
        FpxRequest.find_by(seller_order_no: seller_order_no, seller_ex_order_no: seller_ex_order_no).fpx_responses.pending.count > 0
    end

    def has_failed_response?
        FpxRequest.find_by(seller_order_no: seller_order_no, seller_ex_order_no: seller_ex_order_no).fpx_responses.failed.count > 0
    end

    def has_sync_date?
        FpxRequest.where(seller_order_no: seller_order_no).where.not(sync_date: [nil]).count > 0
    end
end
