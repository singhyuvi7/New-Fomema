# frozen_string_literal: true

# app/models/order.rb
class Order < ApplicationRecord
  CATEGORIES = {
    "TRANSACTION_REGISTRATION" => "TRANSACTION REGISTRATION",
    "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION" => "SPECIAL RENEWAL TRANSACTION REGISTRATION",
    "TRANSACTION_SPECIAL_RENEWAL_REJECT" => "SPECIAL RENEWAL TRANSACTION REJECTED",
    "TRANSACTION_CANCELLATION" => "TRANSACTION CANCELLATION",
    "TRANSACTION_EXTENTION" => "TRANSACTION EXTENTION",
    "TRANSACTION_CHANGE_DOCTOR" => "TRANSACTION CHANGE DOCTOR",
    "FOREIGN_WORKER_AMENDMENT" => "FOREIGN WORKER AMENDMENT",
    "FOREIGN_WORKER_GENDER_AMENDMENT" => "FOREIGN WORKER GENDER AMENDMENT",
    "DOCTOR_REGISTRATION" => "DOCTOR REGISTRATION",
    "DOCTOR_CHANGE_ADDRESS" => "DOCTOR CHANGE ADDRESS",
    "LABORATORY_REGISTRATION" => "LABORATORY REGISTRATION",
    "LABORATORY_CHANGE_ADDRESS" => "LABORATORY CHANGE ADDRESS",
    "XRAY_FACILITY_REGISTRATION" => "XRAY FACILITY REGISTRATION",
    "XRAY_FACILITY_CHANGE_ADDRESS" => "XRAY_FACILITY CHANGE ADDRESS",
    "RADIOLOGIST_REGISTRATION" => "RADIOLOGIST REGISTRATION",
    "REPRINT_MEDICAL_FORM" => "REPRINT MEDICAL FORM",
    "MIGRATION" => 'MIGRATION',
    "INSURANCE_PURCHASE" => "INSURANCE PURCHASE",
    "AGENCY_REGISTRATION" => "AGENCY REGISTRATION",
    "AGENCY_RENEWAL" => "AGENCY RENEWAL",
    "DOCTOR_BIOMETRIC_DEVICE" => "DOCTOR BIOMETRIC DEVICE",
    "XRAY_FACILITY_BIOMETRIC_DEVICE" => "XRAY FACILITY BIOMETRIC DEVICE",
  }

  STATUSES = {
    "NEW" => "NEW",
    "PENDING_PAYMENT" => "PENDING PAYMENT",
    "CANCELLED" => "CANCELLED",
    "REJECTED" => "REJECTED",
    "PAID" => "PAID",
    "FAILED" => "FAILED",
    "PENDING_AUTHORIZATION" => "PENDING AUTHORIZATION",
    "PENDING" => "PENDING"
  }

  PORTAL_CATEGORIES = {
    "TRANSACTION_REGISTRATION" => "TRANSACTION REGISTRATION",
    "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION" => "SPECIAL RENEWAL TRANSACTION REGISTRATION",
    "TRANSACTION_CANCELLATION" => "TRANSACTION CANCELLATION",
    "INSURANCE_PURCHASE" => "INSURANCE PURCHASE"
  }

  PORTAL_AGENCY_CATEGORIES = {
    "TRANSACTION_REGISTRATION" => "TRANSACTION REGISTRATION",
    "SPECIAL_RENEWAL_TRANSACTION_REGISTRATION" => "SPECIAL RENEWAL TRANSACTION REGISTRATION",
    "TRANSACTION_CANCELLATION" => "TRANSACTION CANCELLATION",
    "INSURANCE_PURCHASE" => "INSURANCE PURCHASE",
    "AGENCY_REGISTRATION" => "AGENCY REGISTRATION",
    "AGENCY_RENEWAL" => "AGENCY RENEWAL"
  }

  MERTS_CATEGORIES = {
    "DOCTOR_REGISTRATION" => "DOCTOR REGISTRATION",
    "DOCTOR_CHANGE_ADDRESS" => "DOCTOR CHANGE ADDRESS",
    "LABORATORY_REGISTRATION" => "LABORATORY REGISTRATION",
    "LABORATORY_CHANGE_ADDRESS" => "LABORATORY CHANGE ADDRESS",
    "XRAY_FACILITY_REGISTRATION" => "XRAY FACILITY REGISTRATION",
    "XRAY_FACILITY_CHANGE_ADDRESS" => "XRAY_FACILITY CHANGE ADDRESS"
  }

  audited
  include CaptureAuthor
  include CaptureOrganization
  include Sequence

  after_create :update_code
  after_create :after_paid_success
  after_save :after_paid_success, if: -> { saved_changes[:status] }

  belongs_to :customerable, polymorphic: true, optional: true
  belongs_to :payment_method, optional: true
  belongs_to :creator, class_name: 'User', optional: true, foreign_key: :created_by
  belongs_to :insurance_service_provider, optional: true
  has_many :order_items
  has_many :ipay88_requests
  has_one :latest_ipay88_request, -> { order(created_at: :desc) }, class_name: 'Ipay88Request'
  has_many :swipe_requests
  has_one :latest_swipe_request, -> { order(created_at: :desc) }, class_name: 'SwipeRequest'
  has_many :fpx_requests
  has_one :latest_fpx_request, -> { order(created_at: :desc) }, class_name: 'FpxRequest'
  has_many :boleh_requests
  has_one :latest_boleh_request, -> { order(created_at: :desc) }, class_name: 'BolehRequest'
  has_many :bank_draft_allocations, as: :allocatable
  has_many :order_payments
  has_one :latest_order_payment, -> { order created_at: :desc }, class_name: 'OrderPayment'
  has_many :insurance_purchases
  has_one :insurance_payment

  # validation
  validate :paid_check, if: :status_changed?

  # scopes
  scope :code, -> code { where(code: code.strip) }
  scope :category, -> category { where(category: category) }
  scope :payment_method_id, -> payment_method_id { where(payment_method_id: payment_method_id) }
  scope :ipay88, -> { includes(:payment_method).where(payment_methods: { code: 'IPAY88' }) }
  scope :swipe, -> { includes(:payment_method).where(payment_methods: { code: 'SWIPE' }) }
  scope :fpx, -> { includes(:payment_method).where(payment_methods: { code: 'PAYNET' }) }
  scope :boleh, -> { includes(:payment_method).where(payment_methods: { code: 'BOLEH' }) }
  scope :created_at_portal, -> { includes(:creator).where(users: { userable_type: ['Employer', 'Agency']}) }
  scope :status, -> status { where(status: status) }
  scope :date_between, ->(start_date, end_date) { where(created_at: start_date...end_date ) }
  scope :with_customer_code, ->(code) { joins(:creator).where(users: { code: code }) if code.present? }
  scope :with_invoice_number, ->(code) { where(code: code) if code.present? }
  scope :with_fpx_transaction_id, lambda { |id|
    return unless id.present?

    joins(ipay88_requests: :ipay88_responses)
      .where(ipay88_requests: { ipay88_responses: { transaction_id: id } })
  }
  scope :with_payment_method, lambda { |id|
    return if id.blank?

    where(:payment_method_id => id)
  }

  scope :document_number, -> (document_number) {
    document_number = document_number.strip
    bank_drafts = BankDraft.where(:document_number => document_number)
                  .joins(:bank_draft_allocations)
                  .where(bank_draft_allocations:{ allocatable_type: 'Order' })
                  .pluck('bank_draft_allocations.allocatable_id')
    ipays = Ipay88Request.where(:document_number => document_number).pluck(:order_id)
    swipes = SwipeRequest.where(:document_number => document_number).pluck(:order_id)
    fpxs = FpxRequest.where(:document_number => document_number).pluck(:order_id)
    bolehs = BolehRequest.where(:document_number => document_number).pluck(:order_id)
    order_payments = OrderPayment.where(:document_number => document_number).pluck(:order_id)

    order_ids = bank_drafts+ipays+swipes+fpxs+bolehs+order_payments
    where('orders.id IN (?)',order_ids)
  }

  scope :customer_code, -> (customer_code) {
    customer_code = customer_code.strip
    id_found = []
    customerable_types = ['Employer','Doctor','XrayFacility','Laboratory','Radiologist','Agency']
    customerable_types.each do |customerable_type|
      model = customerable_type.constantize
      table = model.table_name
      order_ids = Order.where(:customerable_type => customerable_type).joins( "INNER JOIN #{table} ON orders.customerable_id = #{table}.id").where("#{table}.code = ?",customer_code).pluck('orders.id')

      id_found += order_ids
    end

    where('orders.id IN (?)',id_found)
  }

  scope :payment_no, -> (payment_no) {
    payment_no = payment_no.strip
    bank_drafts = BankDraft.where(:number => payment_no)
                  .joins(:bank_draft_allocations)
                  .where(bank_draft_allocations:{ allocatable_type: 'Order' })
                  .pluck('bank_draft_allocations.allocatable_id')
    ipays = Ipay88Response.where(:transaction_id => payment_no).joins(:ipay88_request).pluck('ipay88_requests.order_id')
    swipes = SwipeResponse.where(:transaction_id => payment_no).joins(:swipe_request).pluck('swipe_requests.order_id')
    fpxs = FpxResponse.where(:fpx_txn_id => payment_no).joins(:fpx_request).pluck('fpx_requests.order_id')
    bolehs = BolehResponse.where(:transaction_id => payment_no).joins(:boleh_request).pluck('boleh_requests.order_id')
    order_payments = OrderPayment.where(:reference => payment_no).pluck(:order_id)

    order_ids = bank_drafts+ipays+swipes+fpxs+bolehs+order_payments
    where('orders.id IN (?)',order_ids)
  }

  scope :get_document_numbers, -> (order_id){
    document_numbers = []
    payment_types = ['BankDraft','Ipay88Request','SwipeRequest','FpxRequest','BolehRequest','OrderPayment']
    payment_types.each do |payment_type|
      model = payment_type.constantize
      table = model.table_name

      if payment_type == 'BankDraft'
          document_number = BankDraft.joins(:bank_draft_allocations).where(bank_draft_allocations: {allocatable_type: 'Order',allocatable_id: order_id}).pluck('bank_drafts.document_number')
          document_numbers += document_number
      elsif payment_type == 'Ipay88Request'
          requests = Order.find(order_id).try(:ipay88_requests)
          if !requests.blank?
            document_number = requests.joins(:ipay88_responses).where('ipay88_responses.status = ?','1').pluck('ipay88_requests.document_number').last
            document_numbers << document_number if !document_number.blank?
          end
      elsif payment_type == 'SwipeRequest'
          requests = Order.find(order_id).try(:swipe_requests)
          if !requests.blank?
            document_number = requests.joins(:swipe_responses).where('swipe_responses.status = ?','1').pluck('swipe_requests.document_number').last
            document_numbers << document_number if !document_number.blank?
          end
      elsif payment_type == 'FpxRequest'
        requests = Order.find(order_id).try(:fpx_requests)
        if !requests.blank?
          document_number = requests.joins(:fpx_responses).where('fpx_responses.debit_auth_code = ?','00').pluck('fpx_requests.document_number').last
          document_numbers << document_number if !document_number.blank?
        end
      elsif payment_type == 'BolehRequest'
        requests = Order.find(order_id).try(:boleh_requests)
        if !requests.blank?
          document_number = requests.joins(:boleh_responses).where('boleh_responses.status = ?','approved').pluck('boleh_requests.document_number').last
          document_numbers << document_number if !document_number.blank?
        end
      else
          document_number = Order.find(order_id).try(:latest_order_payment).try(:document_number)
          document_numbers << document_number if !document_number.blank?
      end
    end
    return document_numbers
  }

  scope :get_payment_no, -> (order_id) {
    payment_nos = []
    payment_types = ['BankDraft','Ipay88Request','SwipeRequest','FpxRequest','BolehRequest','OrderPayment']
    payment_types.each do |payment_type|
      model = payment_type.constantize
      table = model.table_name

      if payment_type == 'BankDraft'
          payment_no = BankDraft.joins(:bank_draft_allocations).where(bank_draft_allocations: {allocatable_type: 'Order',allocatable_id: order_id}).pluck('bank_drafts.number')
          payment_nos += payment_no
      elsif payment_type == 'Ipay88Request'
          requests = Order.find(order_id).try(:ipay88_requests)
          if !requests.blank?
            payment_no = requests.joins(:ipay88_responses).where('ipay88_responses.status = ?','1').last.try(:transaction_id)
            payment_nos << payment_no if !payment_no.blank?
          end
      elsif payment_type == 'SwipeRequest'
          requests = Order.find(order_id).try(:swipe_requests)
          if !requests.blank?
            payment_no = requests.joins(:swipe_responses).where('swipe_responses.status = ?','1').last.try(:transaction_id)
            payment_nos << payment_no if !payment_no.blank?
          end
      elsif payment_type == 'FpxRequest'
          requests = Order.find(order_id).try(:fpx_requests)
          if !requests.blank?
            payment_no = requests.joins(:fpx_responses).where('fpx_responses.debit_auth_code = ?','00').last.try(:fpx_txn_id)
            payment_nos << payment_no if !payment_no.blank?
          end
      elsif payment_type == 'BolehRequest'
          requests = Order.find(order_id).try(:boleh_requests)
          if !requests.blank?
            payment_no = requests.joins(:boleh_responses).where('boleh_responses.status = ?','approved').last.try(:transaction_id)
            payment_nos << payment_no if !payment_no.blank?
          end
      else
          payment_no = Order.find(order_id).try(:latest_order_payment).try(:reference)
          payment_nos << payment_no if !payment_no.blank?
      end
    end
    return payment_nos
  }

  scope :get_bank, -> (order_id) {
    banks = []
    order = Order.find(order_id)
    if order.payment_method&.code == 'BANKDRAFT'
      banks = order.bank_draft_allocations.joins(:bank_draft).joins('join banks on bank_drafts.bank_id = banks.id').pluck('banks.name').uniq
    end

    return banks
  }

  scope :organization_id, -> (organization_id) {
    return all if organization_id.blank?
    where(organization_id: organization_id)
  }

  scope :start_date, -> (start_date) {
    return all if start_date.blank?
    where('orders.date >= ?',start_date.to_date.beginning_of_day)
  }

  scope :end_date, -> (end_date) {
    return all if end_date.blank?
    date = end_date.to_date + 1.day
    where('orders.date < ?', "#{date.strftime('%Y-%m-%d')}")
  }

  scope :paid_start_date, -> (paid_start_date) {
    return all if paid_start_date.blank?
    where('orders.paid_at >= ?',paid_start_date.to_date.beginning_of_day)
  }
  scope :paid_end_date, -> (paid_end_date) {
    return all if paid_end_date.blank?
    date = paid_end_date.to_date + 1.day
    where('orders.paid_at < ?', "#{date.strftime('%Y-%m-%d')}")
  }
  # end of scopes

  def self.search_code(code)
    return all if code.blank?
    code = code.strip
    where('orders.code = ?', code)
  end

  def has_pending_doctor_selection?
    self.order_items.joins(:transactionz).where("transactions.doctor_id is null").count > 0
  end

  def update_code
    self.update({
      code: generate_code,
      date: DateTime.now
    })
  end

  def generate_code
    sprintf("#{Time.now.strftime("%Y%m%d")}%06d", get_sequence)
  end

  def get_sequence
    sequence_name = "orders_code_#{Time.now.strftime("%Y%m%d")}_seq"
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

  def update_total_amount
    self.update({
      amount: order_items.sum(:amount)
    })
  end

  def subtotal
    order_items.exclude_convenient_fee.sum(&:amount) || 0
  end

  def conv_fee
    order_items.get_convenient_fee.sum(&:amount) || 0
  end

  def biometric_device_fee
    order_items.get_biometric_device_fee.sum(&:amount) || 0
  end

  def biometric_admin_fee
    order_items.get_biometric_admin_fee.sum(&:amount) || 0
  end

  def gst
    0
  end

  def total_amount
    amount
  end

  def after_paid_success
    if ['PAID'].include?(status)
      self.update_columns(paid_at: Time.now)

      ##  create or update insurance_payments
      if !self.order_items.get_insurance_fee.blank?
        ip = InsurancePayment.where(:order_id => self.id).first_or_create
        commission_percentage = self.insurance_service_provider.code == "HOWDEN" ? SystemConfiguration.find_by(code: 'INSURANCE_COMMISSION')&.value&.to_d || 0 : 0
        ip.update({
          commission_percentage: commission_percentage,
          transaction_fee: self.payment_method.transaction_fee
        })
      end
    end
  end

  def self.search_organization(organization)
    return all if organization.blank?
    where(organization_id: organization)
  end

  def paid_check
    if status_was == "PAID"
      errors.add(:status, "Order paid, no more changes on status allowed")
    end
  end

  def order_need_update?
    need_update = false
    self.order_items.where("order_itemable_type = 'ForeignWorker'").each do |order_item|
        if order_item.gender != ForeignWorker.find_by(id: order_item.order_itemable_id).gender
          need_update = true and return need_update
        end
    end
    return need_update
  end
end
