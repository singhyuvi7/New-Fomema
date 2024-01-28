class OrderPayment < ApplicationRecord
	audited
    include CaptureAuthor
    include Sequence

    belongs_to :order
    has_many :order_payment_hold_logs
    belongs_to :replacement, class_name: "OrderPayment", foreign_key: "replacement_id", optional: true
    before_save :strip_reference, if: :reference_changed?

    validate :validate_amount
    validate :validate_payment_reference

    after_save :block_or_unblock_fw, if: -> { saved_changes[:bad] }
    after_save :update_bad_at, if: -> { saved_changes[:bad] }

    def validate_amount
        errors.add(:amount, "is different from order amount") if order.amount != self.amount
    end

    def validate_payment_reference
        if order.payment_method.code == 'CIMB_CLICKS'
            order_payment = OrderPayment.joins(:order).where(:reference => self.reference, :issue_date => self.issue_date, :bad => false)
            .where(orders:{payment_method_id: order.payment_method_id}).where.not(:id => self.id)
            if !order_payment.blank?
                errors.add(:reference, "number with the same issue date already exist")
            end
        end
    end

    def self.search_payment_method(payment_method)
        return all if payment_method.blank?
        joins(:order).where(orders: { payment_method_id: payment_method })
    end

    def self.search_reference(reference)
        return all if reference.blank?
        reference = reference.strip
        where('order_payments.reference = ?', "#{reference}")
    end

    def self.search_issue_date_from(issue_date_from)
        return all if issue_date_from.blank?
        where('order_payments.issue_date >= ?', "#{issue_date_from}")
    end

    def self.search_issue_date_to(issue_date_to)
        return all if issue_date_to.blank?
        issue_date_to = issue_date_to.to_date + 1.day
        where('order_payments.issue_date < ?', "#{issue_date_to.strftime('%Y-%m-%d')}")
    end

    def self.search_organization(organization)
        return all if organization.blank?
        joins(:order).where(orders: { organization_id: organization })
    end

    def self.search_bad(bad)
        return all if bad.blank?
        bad = ['1', 'y', 'yes', 'true'].include?(bad.to_s.downcase)
        where("order_payments.bad is #{bad ? "true" : "false"}")
    end

    def self.search_holded(holded)
        return all if holded.blank?
        holded = ['1', 'y', 'yes', 'true'].include?(holded.to_s.downcase)
        where("order_payments.holded is #{holded ? "true" : "false"}")
    end

    def self.search_order_code(order_code)
        return all if order_code.blank?
        order_code = order_code.strip
        joins(:order).where(orders: { code: order_code })
    end

    def self.search_posted(is_posted)
        return all if is_posted.blank?
        where("order_payments.sync_date #{is_posted == 'true' ? "IS NOT NULL" : "IS NULL" }")
    end

    def self.search_created_date_from(created_date_from)
        return all if created_date_from.blank?
        where('order_payments.created_at >= ?', "#{created_date_from}")
    end

    def self.search_created_date_to(created_date_to)
        return all if created_date_to.blank?
        created_date_to = created_date_to.to_date + 1.day
        where('order_payments.created_at < ?', "#{created_date_to.strftime('%Y-%m-%d')}")
    end

    ##

    def update_document_number
        self.update_columns({
			document_number: generate_document_number
		})
    end

    def generate_document_number
        "#{self.created_at.strftime('%Y%m%d')}#{get_or_create_sequence('collection_document_number_seq')}"
    end

    def block_or_unblock_fw
        if self.order.customerable_type.eql?("Employer") && !self.from_migration && ['TRANSACTION_REGISTRATION','SPECIAL_RENEWAL_TRANSACTION_REGISTRATION'].include?(self.order&.category)
            self.order.order_items.exclude_convenient_fee.each do |order_item|
                fw = ForeignWorker.find(order_item.order_itemable_id)
                if self.bad == true
                    data = {
                        blocked: true,
                        block_reason_id: BlockReason.find_by(code: "PAYMENTISSUE", category: "BLOCK")&.id,
                        blocked_at: Time.now,
                        blocked_by: Current.user&.id
                    }
                else
                    data = {
                        blocked: false,
                        unblock_reason_id: BlockReason.find_by(code: "PAYMENTUPDATE", category: "UNBLOCK")&.id,
                        blocked_at: nil,
                        blocked_by: nil,
                    }
                end
                fw.update(data)
            end
        end
    end

    def update_bad_at
        datetime = self.bad == true ? DateTime.now : nil
        self.update_columns(bad_at: datetime)
    end

    def strip_reference
        self.reference = self.reference.strip
    end
end
