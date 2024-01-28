class Refund < ApplicationRecord
	CATEGORIES = {
		"AUTOMATIC" => "Automatic",
		"MANUAL" => "Manual",
		"TRANSACTION_CANCELLATION" => "Transaction Cancellation",
		"TRANSACTION_SPECIAL_RENEWAL_REJECT" => "Special Renewal Transaction Rejected",
		"REJECT_FOREIGN_WORKER_AMENDMENT" => "Reject Foreign Worker Amendment",
		"REJECT_TRANSACTION_CHANGE_DOCTOR" => "Reject Transaction Change Doctor",
		"FOREIGN_WORKER_GENDER_AMENDMENT" => "Foreign Worker Gender Amendment",
		"REJECT_FOREIGN_WORKER_GENDER_AMENDMENT" => "Reject Foreign Worker Gender Amendment",
	}

    STATUSES = {
		"DRAFT" => "Draft",
		"NEW" => "New",
		"APPROVAL" => "Pending Approval",
		"REJECTED" => "Rejected",
		# "APPROVED" => "Approved", # direct to go PENDING_PAYMENT
        "PENDING_PAYMENT" => "Pending Payment",
		"PENDING_REPROCESS" => "Pending Reprocess",	# after employer updates the bank info
		"CANCELLED" => "Cancelled",
        "PAYMENT_SUCCESS" => "Payment Success",
		"PAYMENT_FAILED" => "Payment Failed",
		"PENDING_SEND" => "Pending Send To Accounting System",
		"PROCESS_FAILED" => "Process Failed",
	}

 	# portal revampp to split refund status nios and portal
	STATUSES_EMPLOYER = {
		"REJECTED" => "Rejected",
		"PENDING_PAYMENT" => "Pending Payment",
		"PENDING_REPROCESS" => "Pending Reprocess",
		"CANCELLED" => "Cancelled",
    	"PAYMENT_SUCCESS" => "Payment Success",
		"PAYMENT_FAILED" => "Payment Failed",
		"PENDING_SEND" => "Pending Send To Accounting System"
	}

	REASONS = {
		"001" => "ACCOUNT NOT FOUND",
		"619" => "Invalid/Missing ID Number",
		"R02" => "ACCOUNT CLOSED",
		"R03" => "NO ACC / UNABLE TO LOC AC",
		"R04" => "INVALID ACC NUMBER",
		"R16" => "ACCOUNT FROZEN",
		"R20" => "NON-TRANSACTION ACCOUNT",
		"R21" => "INVALID COMPANY INDENT",
		"R22" => "INVALID INDV ID NUMBER",
		"R23" => "CR ENTRY REFUSED BY RCVER",
	}

	UNUTILISED = {
		"Yes" => true
	}

	audited
    include CaptureAuthor
    include CaptureOrganization
	include Sequence

	belongs_to :customerable, polymorphic: true, optional: true
	belongs_to :payment_method, optional: true
	has_many :refund_items
	has_many :uploads, as: :uploadable
	belongs_to :refund_batch, optional: true

	after_create :update_code
	after_save :after_save_callback
	after_save :send_refund_failed_email, if: -> { saved_changes[:status] || (self.status == 'PAYMENT_FAILED' && saved_changes[:updated_at]) }
	after_save :send_manual_refund_reject_email, if: -> { saved_changes[:status] }
	after_save :send_manual_refund_created_email, if: -> { self.category == 'MANUAL' && saved_changes[:status] }
	after_save :update_batch_status, if: -> { saved_changes[:status] && !self.refund_batch_id.blank? }

	scope :category, -> category { where(category: category) }
	scope :start_date, -> start_date { where("date >= ?", start_date) }
	scope :end_date, -> end_date { where("date <= ?", end_date) }

    def self.search_code(code)
		return all if code.blank?
		code = code.strip
        where('refunds.code = ?', "#{code}")
    end

    def self.search_status(status)
        return all if status.blank?
        where('refunds.status = ?', "#{status}")
	end

    def self.search_payment_method(payment_method_id)
        return all if payment_method_id.blank?
        where('refunds.payment_method_id = ?', "#{payment_method_id}")
	end

	def self.search_employer_code(employer_code)
		return all if employer_code.blank?
		employer_code = employer_code.strip
		joins("join employers on refunds.customerable_id = employers.id")
		.where("refunds.customerable_type = 'Employer' and employers.code = ?",employer_code)
	end

	def self.search_employer_name(employer_name)
		return all if employer_name.blank?
		employer_name = employer_name.strip
		joins("join employers on refunds.customerable_id = employers.id")
		.where("refunds.customerable_type = 'Employer' and employers.name ilike ?", "%#{employer_name}%")
	end

	def self.search_customerable_type(customerable_type)
        return all if customerable_type.blank?
        customerable_type = customerable_type.strip
        where("refunds.customerable_type = ?", customerable_type)
    end

	def self.search_customerable_by_code(customerable_type, customerable_code)
        return all if customerable_type.blank?
        customerable_type = customerable_type.strip
        where = where("refunds.customerable_type = ?", customerable_type)
        return where if customerable_code.blank?
        customerable_code = customerable_code.strip
        where = where.where("exists (select 1 from #{customerable_type.constantize.table_name} where refunds.customerable_id = #{customerable_type.constantize.table_name}.id and #{customerable_type.constantize.table_name}.code = ?)", customerable_code)
    end

	def self.search_customerable_by_name(customerable_type, customerable_name)
        return all if customerable_type.blank?
        customerable_type = customerable_type.strip
        where = where("refunds.customerable_type = ?", customerable_type)
        return where if customerable_type.blank?
        customerable_type = customerable_type.strip
        where = where.where("exists (select 1 from #{customerable_type.constantize.table_name} where refunds.customerable_id = #{customerable_type.constantize.table_name}.id and #{customerable_type.constantize.table_name}.name ilike ?)", "%#{customerable_name}")
    end

	def update_code
		self.update_columns({
			code: generate_code,
			date: Time.now
		})
	end

	def generate_code
		sprintf("#{Time.now.strftime("%Y%m%d")}%06d", get_sequence)
	end

	def get_sequence
		sequence_name = "refunds_code_#{Time.now.strftime("%Y%m%d")}_seq"
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

	def after_save_callback
		if saved_change_to_status?
			if ["CANCELLED"].include?(saved_changes["status"][1])
				self.refund_items.each do |refund_item|
					if refund_item.refund_itemable_type == 'BankDraft'
						BankDraftAllocation.where(allocatable: self).destroy_all
					end
				end
			end
		end
	end

	def update_total_amount
		self.update({
			amount: refund_items.sum(:amount)
		})
	end

	def send_refund_failed_email
		if status == 'PAYMENT_FAILED' && !self.customerable&.email.blank?
			RefundMailer.with({
				refund: self
            }).failed_email.deliver_later
		end
	end

    def send_manual_refund_reject_email
        if category == 'MANUAL' && ['REJECTED','PENDING_PAYMENT','PENDING_SEND'].include?(status) && ['REJECT'].include?(approval_decision) && !self.customerable&.email.blank?
            RefundMailer.with({
                refund: self
            }).manual_refund_reject_email.deliver_later
        end
	end

	def send_manual_refund_created_email
		if ['APPROVAL'].include?(status)
			RefundMailer.with({
				refund: self
			}).manual_refund_created_email.deliver_later
		end
	end

	def update_document_number
		if category != 'MANUAL' || (category == 'MANUAL' && approval_decision == 'APPROVE' && unutilised == true)
			self.update_columns({
				document_number: generate_document_number
			})
		end
	end

	def generate_document_number
		sprintf("#{Time.now.strftime("%Y%m%d")}%06d", get_or_create_sequence('collection_document_number_seq'))
	end

	def update_batch_status
		statuses = Refund.where(:refund_batch_id => self.refund_batch_id).distinct.pluck(:status)

		if statuses.include? 'NOT_PROCESS'
			_status = 'NOT_PROCESS'
		elsif statuses.include? 'PROCESS_FAILED'
			_status = 'PROCESS_FAILED'
		elsif statuses.include? 'PROCESSING'
			_status = 'PROCESSING'
		elsif statuses.include? 'PAYMENT_FAILED'
			_status = 'PAYMENT_FAILED'
		elsif statuses.include? 'PENDING_PAYMENT'
			_status = 'PENDING_PAYMENT'
		else
			_status = 'PAYMENT_SUCCESS'
		end

		RefundBatch.find(self.refund_batch_id).update(status: _status)
	end
end