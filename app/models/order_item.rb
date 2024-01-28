class OrderItem < ApplicationRecord
    REGISTRATION_CATEGORIES = %w[TRANSACTION_REGISTRATION
                                 SPECIAL_RENEWAL_TRANSACTION_REGISTRATION
                                 TRANSACTION_CANCELLATION].freeze

    audited
    include CaptureAuthor

    after_save :update_order_amount
    after_destroy :update_order_amount
    before_commit :update_gender, on: [:create, :update]

    belongs_to :order
    belongs_to :order_itemable, polymorphic: true, optional: true
    belongs_to :fee, optional:  true
    has_one :transactionz, foreign_key: "order_item_id", class_name: "Transaction"
    has_one :biodata_transaction, foreign_key: "order_item_id", class_name: "BiodataTransaction"
    has_one :insurance_purchase

    scope :for_summary_worker_registration, lambda {
        joins(:order, :fee)
            .where('orders.category IN (?) OR fees.code = ?', REGISTRATION_CATEGORIES, 'FOREIGN_WORKER_GENDER_AMENDMENT')
    }
    scope :for_misc_income, lambda {
        joins(:order, :fee)
            .where(orders: { category: Report::SummaryMiscIncomeService::CATEGORIES })
            .where.not(fees: { code: ['FOREIGN_WORKER_GENDER_AMENDMENT'] })
    }
    scope :date_between, lambda { |start_date, end_date| where(created_at: start_date...end_date) }
    scope :paid_at_date_between, lambda { |start_date, end_date|
        joins(:order).where(orders: { paid_at: start_date...end_date })
    }
    scope :refunded_at_date_between, lambda { |start_date, end_date|
        where(refunded_at: start_date...end_date)
    }
    scope :search_organization, -> (organization) {
        return all if organization.blank?

        joins(:order).where('orders.organization_id = ?', "#{organization}")
    }
    scope :join_foreign_workers, lambda {
        joins("LEFT JOIN foreign_workers ON order_items.order_itemable_id = foreign_workers.id AND order_items.order_itemable_type = 'ForeignWorker'")
    }

    scope :without_rejected, -> { where(refunded_at: nil) }
    scope :rejected, -> { where.not(refunded_at: nil) }

    scope :exclude_convenient_fee, -> { joins(:fee).where("fees.code not ilike 'ipay%' and fees.code not ilike 'swipe%' and fees.code not ilike 'paynet%' and fees.code not ilike 'boleh%'") }
    scope :exclude_insurance, -> { joins(:fee).where.not("fees.code" => ["INSURANCE_GROSS_PREMIUM", "INSURANCE_SST", "INSURANCE_STAMP_DUTY", "INSURANCE_ADMINFEES", "INSURANCE_ADMINFEES_SST"]) }
    scope :get_convenient_fee, -> { joins(:fee).where("fees.code ilike 'ipay%' or fees.code ilike 'swipe%' or fees.code ilike 'paynet%' or fees.code ilike 'boleh%'") }
    scope :sort_convenient_fee_as_last, -> { order("CASE
    WHEN order_itemable_type != 'Employer' THEN 0 ELSE 1
    END") }

    ## for insurance
    scope :exclude_insurance_fee, -> { joins(:fee).where("fees.code not ilike 'insurance%'") }
    scope :get_insurance_fee, -> { joins(:fee).where("fees.code ilike 'insurance%' and order_items.amount != 0") }
    scope :get_insurance_sst, -> { joins(:fee).where("fees.code = 'INSURANCE_SST'") }
    scope :get_insurance_stamp_duty, -> { joins(:fee).where("fees.code = 'INSURANCE_STAMP_DUTY'") }
    scope :get_insurance_adminfees, -> { joins(:fee).where("fees.code = 'INSURANCE_ADMINFEES'") }
    scope :get_insurance_adminfees_sst, -> { joins(:fee).where("fees.code = 'INSURANCE_ADMINFEES_SST'") }
    scope :get_insurance_gross_premium, -> { joins(:fee).where("fees.code = 'INSURANCE_GROSS_PREMIUM' and order_items.amount != 0") }

    ## for agency
    scope :exclude_agency_fee, -> { joins(:fee).where.not("fees.code" => ["AGENCY_REGISTRATION", "AGENCY_REGISTRATION"]) }
    scope :get_agency_registration_fee, -> { joins(:fee).where("fees.code = 'AGENCY_REGISTRATION'") }
    scope :get_agency_renewal_fee, -> { joins(:fee).where("fees.code = 'AGENCY_RENEWAL'") }

    ## for biometric
    scope :get_biometric_device_fee, -> { joins(:fee).where("fees.code" => ["BIOMETRIC_DEVICE"]) }
    scope :get_biometric_admin_fee, -> { joins(:fee).where("fees.code" => ["BIOMETRIC_ADMIN"]) }

    def update_order_amount
        order.update_total_amount
    end

    def get_additional_information_changes_old
        ret = {}
        self.additional_information["changes"].each do |key, arr|
            ret[key] = arr[0]
        end
        return ret
    end

    def get_additional_information_changes_new
        ret = {}
        self.additional_information["changes"].each do |key, arr|
            ret[key] = arr[1]
        end
        return ret
    end

    def get_additional_information_transaction_id
        transaction_id = self.additional_information["transaction_id"] || 0 if !self.additional_information.nil?
        return transaction_id
    end

    def update_gender
        if ['ForeignWorker','Transaction'].include?(self.order_itemable_type)
            case self.order_itemable_type
            when 'Transaction'
                self.update(gender: self.order_itemable.try(:fw_gender))
            else
                if order.category == 'FOREIGN_WORKER_GENDER_AMENDMENT' and ['Employer', 'Agency'].include?(User.find(order.created_by).userable_type)
                    self.get_additional_information_changes_new.each do |k, v|
                        if k == 'gender'
                            self.update(gender: v)
                        end
                    end
                else
                    self.update(gender: self.order_itemable.try(:gender))
                end
            end
        end
    end
end
