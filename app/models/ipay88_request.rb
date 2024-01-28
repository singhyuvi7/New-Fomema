require 'ipay88'

class Ipay88Request < ApplicationRecord
  include CaptureAuthor
  include Sequence

  after_create :update_signature

  belongs_to :order
  has_many :ipay88_responses

  PAYMENT_METHOD = { credit_card: 2, maybank2u: 6, alliance_online: 8,
                     am_online: 10, rhb_online: 14, hong_leong_online: 15,
                     cimb_click: 20, web_cash: 22, public_bank_online: 31,
                     paypal: 48, credit_card_pre_auth: 55,
                     bank_rakyat_internet_banking: 102,
                     affin_online: 103, pay4me: 122, bsn_online: 124,
                     bank_islam: 134, uob: 152, hong_leong_pex_qr_payment: 163,
                     bank_muamalat: 166, ocbc: 167, standard_chartered_bank: 168,
                     cimb_virtual_account: 173, hsbc_online_banking: 198,
                     kuwait_finance_house: 199, boost_wallet: 210,
                     alipay_merchant_scan: 234,
                     vcash: 243, grabpay_online: 523, touch_n_go_ewallet: 538,
                     maybank_pay_qr_online: 542 }.freeze

  def update_signature
    refno = reference_number.blank? ? generate_reference_number : reference_number
    signature_string = "#{merchant_key}#{merchant_code}#{refno}#{(amount*100).to_i}#{currency}"
    self.update({
      reference_number: refno,
      signature: IPay88.sha256(signature_string)
    })
  end

  def update_document_number
        self.update_columns({
      document_number: generate_document_number
    })
  end

  def generate_reference_number
    sprintf("S#{ENV["IPAY88_REFERENCE_NUMBER_PREFIX"]}#{Time.now.strftime("%Y%m%d")}%06d", get_sequence)
  end

  def get_sequence
    sequence_name = "ipay88_requests_reference_number_#{Time.now.strftime("%Y%m%d")}_seq"
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

  def generate_document_number
    "#{self.created_at.strftime('%Y%m%d')}#{get_or_create_sequence('collection_document_number_seq')}"
  end

  def payment_method
    return if ipay88_responses.blank?
    return if ipay88_responses.success.blank?

    id = ipay88_responses.success.last.payment_id.to_i

    PAYMENT_METHOD.key(id).to_s.humanize(capitalize: false)
  end

  def transaction_id
    return if ipay88_responses.blank?
    return if ipay88_responses.success.blank?

    ipay88_responses.success.last.transaction_id
  end
end
