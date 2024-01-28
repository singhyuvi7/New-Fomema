require 'swipe'

class SwipeRequest < ApplicationRecord
    audited
    include CaptureAuthor
    include Sequence

    after_create :update_signature

    belongs_to :order
    has_many :swipe_responses

    PAYMENT_METHOD = { credit_card: 1, ewallet: 2, fpx_b2b: 3, fpx_b2c: 4}.freeze

    def update_signature
        refno = reference_number.blank? ? generate_reference_number : reference_number
        signature_string = "#{merchant_key}#{merchant_code}#{refno}#{(amount*100).to_i}#{currency}"
        self.update({
            reference_number: refno,
            signature: Swipe.sha256(signature_string)
        })
    end
  
    def update_document_number
        self.update_columns({
            document_number: generate_document_number
        })
    end

    def generate_reference_number
        #sprintf("S#{ENV["SWIPE_REFERENCE_NUMBER_PREFIX"]}#{Time.now.strftime("%Y%m%d")}%06d", get_sequence)
        sequence_name = "swipe_requests_reference_number_#{Time.now.strftime("%Y%m%d")}_seq"
        sprintf("S#{ENV["SWIPE_REFERENCE_NUMBER_PREFIX"]}#{Time.now.strftime("%Y%m%d")}%06d", get_or_create_sequence("#{sequence_name}"))
    end

=begin
    def get_sequence
        sequence_name = "swipe_requests_reference_number_#{Time.now.strftime("%Y%m%d")}_seq"
        rs = ActiveRecord::Base.connection.execute("SELECT count(*) FROM information_schema.sequences where sequence_name = '#{sequence_name}'")
        if rs.first["count"] == 0
            sql = "create sequence #{sequence_name}
            increment 1
            cycle
            start with 1"
            ActiveRecord::Base.connection.execute sql
        end
        seq_nextval(sequence_name)
    end
=end

    def generate_document_number
        "#{self.created_at.strftime('%Y%m%d')}#{get_or_create_sequence('collection_document_number_seq')}"
    end

    def payment_method
        return if swipe_responses.blank?
        return if swipe_responses.success.blank?

        id = swipe_responses.success.last.payment_id.to_i

        PAYMENT_METHOD.key(id).to_s.humanize(capitalize: false)
    end

    def transaction_id
        return if swipe_responses.blank?
        return if swipe_responses.success.blank?

        swipe_responses.success.last.transaction_id
    end

end
