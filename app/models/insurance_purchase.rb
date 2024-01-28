class InsurancePurchase < ApplicationRecord
    audited

    belongs_to :order, optional: true
    belongs_to :order_item, optional: true
    belongs_to :employer, optional: true
    belongs_to :foreign_worker, optional: true
    belongs_to :fw_country, class_name: "Country", optional: true
    belongs_to :fw_job_type, class_name: "JobType", optional: true
    belongs_to :insurance_service_provider, optional: true
    has_many :insurance_purchase_items

    def self.search_employer_name(name)
        name = name.try(:strip)
        return all if name.blank?
        joins(:employer).where("employers.name ILIKE ?", "%#{name}%")
    end

    def self.search_employer_code(code)
        code = code.try(:strip)
        return all if code.blank?
        joins(:employer).where("employers.code = ?", "#{code}")
    end

    def self.search_fw_name(name)
        name = name.try(:strip)
        return all if name.blank?
        where("insurance_purchases.fw_name ILIKE ?", "%#{name}%")
    end

    def self.search_fw_code(code)
        code = code.try(:strip)
        return all if code.blank?
        where("insurance_purchases.fw_code = ?", "#{code}")
    end

    def self.search_fw_passport_number(passport)
        passport = passport.try(:strip)
        return all if passport.blank?
        where("insurance_purchases.fw_passport_number = ?", "#{passport}")
    end

    def self.search_policy_date(start_date = nil, end_date = nil)
        start_date = start_date.try(:to_date)
        end_date = end_date.try(:to_date)
        if !start_date.blank? && !end_date.blank?
            where("(insurance_purchases.start_date >= ? and insurance_purchases.start_date < ?) or (insurance_purchases.end_date >= ? and insurance_purchases.end_date < ?)", start_date, end_date + 1.day, start_date, end_date + 1.day)
        elsif !start_date.blank? && end_date.blank?
            where("insurance_purchases.end_date >= ?", start_date)
        elsif start_date.blank? && !end_date.blank?
            where("insurance_purchases.start_date <= ?", end_date + 1.day)
        else
            all
        end
    end

    def self.search_order_status(status)
        status = status.try(:strip)
        return all if status.blank?
        joins(:order).where("orders.status = ?", "#{status}")
    end

    def self.search_order_code(code)
        code = code.try(:strip)
        return all if code.blank?
        joins(:order).where("orders.code = ?", "#{code}")
    end

    def self.search_order_branch(branch_id)
        branch_id = branch_id.try(:strip)
        return all if branch_id.blank?
        joins(:order).where("orders.organization_id = ?", "#{branch_id}")
    end

    def self.search_order_paid_date(start_date = nil, end_date = nil)
        start_date = start_date.try(:to_date)
        end_date = end_date.try(:to_date)
        if !start_date.blank? && !end_date.blank?
            joins(:order).where("(orders.paid_at >= ? and orders.paid_at < ?)", start_date, end_date + 1.day)
        elsif !start_date.blank? && end_date.blank?
            joins(:order).where("orders.paid_at >= ?", start_date)
        elsif start_date.blank? && !end_date.blank?
            joins(:order).where("orders.paid_at <= ?", end_date + 1.day)
        else
            all
        end
    end

    def policy_period_display
        return '' if self.start_date.blank? || self.end_date.blank?
        "#{self.start_date.strftime("%d/%m/%Y")} - #{self.end_date.strftime("%d/%m/%Y")}"
    end
end
