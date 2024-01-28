class BankDraft < ApplicationRecord
    PAYERABLE_TYPES = {
        "Employer" => "Employer",
        "Agency" => "Agency",
        "Doctor" => "Doctor",
        "Laboratory" => "Laboratory",
        "XrayFacility" => "X-Ray Facility",
        "Radiologist" => "Radiologist"
    }

    IS_POSTED = {
        "Yes" => true,
        "No" => false
    }

    audited
    include CaptureAuthor
    include CaptureOrganization
    include Sequence

    belongs_to :payerable, polymorphic: true, optional: true
    belongs_to :bank
    belongs_to :zone
    has_many :bank_draft_allocations
    has_many :bank_draft_hold_logs
    # has_one :refund_item, as: :refund_itemable
    # # has_one :refund, through: :refund_item
    belongs_to :replacement, class_name: "BankDraft", foreign_key: "replacement_id", optional: true

    validates :number, uniqueness: { scope: [:bank_id, :issue_date, :zone_id, :amount], case_sensitive: false, message: " - Duplicate cheque found in system. You are not allowed to proceed." }, if: :unique_bad_draft_exists?
    validate :issue_date_expiry, on: :create

    after_save :after_save_block_fw
    after_save :update_bad_at, if: -> { saved_changes[:bad] }

    def update_document_number
        self.update_columns({
			document_number: generate_document_number
		})
    end

    def generate_document_number
        "#{self.created_at.strftime('%Y%m%d')}#{get_or_create_sequence('collection_document_number_seq')}"
    end

    def self.search_number(number)
        return all if number.blank?
        number = number.strip
        where('bank_drafts.number = ?', "#{number}")
    end

    def self.search_bank(bank)
        return all if bank.blank?
        bank = bank.strip
        where('bank_drafts.bank_id = ?', "#{bank}")
    end

    def self.search_issue_date(issue_date)
        return all if issue_date.blank?
        where('bank_drafts.issue_date = ?', "#{issue_date}")
    end

    def self.search_issue_date_from(issue_date_from)
        return all if issue_date_from.blank?
        where('bank_drafts.issue_date >= ?', "#{issue_date_from}")
    end

    def self.search_issue_date_to(issue_date_to)
        return all if issue_date_to.blank?
        issue_date_to = issue_date_to.to_date + 1.day
        where('bank_drafts.issue_date < ?', "#{issue_date_to.strftime('%Y-%m-%d')}")
    end

    def self.search_zone(zone)
        return all if zone.blank?
        where('bank_drafts.zone_id = ?', "#{zone}")
    end

    def self.search_organization(organization)
        return all if organization.blank?
        where('bank_drafts.organization_id = ?', "#{organization}")
    end

    def self.search_bad(bad)
        return all if bad.blank?
        bad = ['1', 'y', 'yes', 'true'].include?(bad.to_s.downcase)
        where("bank_drafts.bad is #{bad ? "true" : "false"}")
    end

    def self.search_holded(holded)
        return all if holded.blank?
        holded = ['1', 'y', 'yes', 'true'].include?(holded.to_s.downcase)
        where("bank_drafts.holded is #{holded ? "true" : "false"}")
    end

    def self.search_order_code(order_code)
        return all if order_code.blank?
        order_code = order_code.strip
        where("exists (select 1 from bank_draft_allocations bda join orders on bda.allocatable_id = orders.id and bda.allocatable_type = 'Order' where bda.bank_draft_id = bank_drafts.id and orders.code = ?)", "#{order_code}")
    end

    def self.search_payerable_by_code(payerable_type, payerable_code)
        return all if payerable_type.blank?
        payerable_type = payerable_type.strip
        where = where("bank_drafts.payerable_type = ?", payerable_type)
        return where if payerable_code.blank?
        payerable_code = payerable_code.strip
        where = where.where("exists (select 1 from #{payerable_type.constantize.table_name} where bank_drafts.payerable_id = #{payerable_type.constantize.table_name}.id and #{payerable_type.constantize.table_name}.code = ?)", payerable_code)
    end

    def self.search_posted(is_posted)
        return all if is_posted.blank?
        where("bank_drafts.sync_date #{is_posted == 'true' ? "IS NOT NULL" : "IS NULL" }")
    end

    def self.search_created_date_from(created_date_from)
        return all if created_date_from.blank?
        where('bank_drafts.created_at >= ?', "#{created_date_from}")
    end

    def self.search_created_date_to(created_date_to)
        return all if created_date_to.blank?
        created_date_to = created_date_to.to_date + 1.day
        where('bank_drafts.created_at < ?', "#{created_date_to.strftime('%Y-%m-%d')}")
    end

=begin
    def self.schedule_refund
        where("")
    end
=end

    def update_allocated_amount
        self.amount_allocated = bank_draft_allocations.sum(:amount)
        self.save(validate: false)
    end

    def issue_date_expiry
        if bank.bank_draft_expiry_day > 0 and issue_date < bank.bank_draft_expiry_day.days.ago
            errors.add(:issue_date, "Bank draft is expired, #{bank.name} has #{bank.bank_draft_expiry_day.to_i} expiry days")
        end
    end

    def can_new_refund?
        !self.bad && !self.holded && (self.amount_allocated.nil? || self.amount > self.amount_allocated)
        # and Refund.joins(:refund_items).where("refund_items.refund_itemable_id = ? and refund_items.refund_itemable_type = 'BankDraft' and refunds.status in (?)", self.id, ["DRAFT", "APPROVAL", "REJECTED", "PENDING_PAYMENT", "PAYMENT_SUCCESS", "PAYMENT_FAILED"]).count == 0
    end

    def after_save_block_fw
        if (payerable_type.eql?("Employer") and !self.from_migration and (saved_changes.include?("holded") or saved_changes.include?("bad")))
            block_or_unblock_fw
        end
    end

    def block_or_unblock_fw
        bank_draft_allocations.where("allocatable_type = ?", 'Order').each do |bda|
            ForeignWorker.where("exists (select 1 from transactions join order_items on transactions.order_item_id = order_items.id
            join orders on order_items.order_id = orders.id
            where order_items.order_id = ? and transactions.foreign_worker_id = foreign_workers.id)", bda.allocatable_id).each do |fw|
                if holded or bad
                    data = {
                        blocked: true,
                        block_reason_id: BlockReason.find_by(code: "PAYMENTISSUE", category: "BLOCK")&.id,
                        blocked_at: Time.now,
                        blocked_by: Current.user.id
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

    def unique_bad_draft_exists?
        return true if !BankDraft.where(:number => number,:bank_id => bank_id, :issue_date => issue_date, :zone_id => zone_id, :amount => amount, :bad => false).blank?
    end

end
