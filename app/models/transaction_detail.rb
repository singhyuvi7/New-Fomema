# frozen_string_literal: true

class TransactionDetail < ApplicationRecord
    # details/history
    belongs_to :transactionz, foreign_key: "transaction_id", class_name: "Transaction", optional: true
    belongs_to :doc_country, class_name: "Country", optional: true
    belongs_to :doc_state, class_name: "State", optional: true
    belongs_to :doc_town, class_name: "Town", optional: true
    belongs_to :doc_service_provider_group, class_name: "ServiceProviderGroup", optional: true
    belongs_to :doc_payment_method, class_name: "PaymentMethod", optional: true

    belongs_to :lab_country, class_name: "Country", optional: true
    belongs_to :lab_state, class_name: "State", optional: true
    belongs_to :lab_town, class_name: "Town", optional: true
    belongs_to :lab_service_provider_group, class_name: "ServiceProviderGroup", optional: true
    belongs_to :lab_payment_method, class_name: "PaymentMethod", optional: true

    belongs_to :xray_country, class_name: "Country", optional: true
    belongs_to :xray_state, class_name: "State", optional: true
    belongs_to :xray_town, class_name: "Town", optional: true
    belongs_to :xray_service_provider_group, class_name: "ServiceProviderGroup", optional: true
    belongs_to :xray_payment_method, class_name: "PaymentMethod", optional: true

    belongs_to :rad_country, class_name: "Country", optional: true
    belongs_to :rad_state, class_name: "State", optional: true
    belongs_to :rad_town, class_name: "Town", optional: true

    belongs_to :doc_sp_group_payment_method, class_name: "PaymentMethod", optional: true
    belongs_to :lab_sp_group_payment_method, class_name: "PaymentMethod", optional: true
    belongs_to :xray_sp_group_payment_method, class_name: "PaymentMethod", optional: true

    scope :certification_date_between, lambda { |start_date, end_date|
        includes(:transactionz).where(transactions: { certification_date: DateTime.parse(start_date).in_time_zone('Kuala Lumpur').beginning_of_day..DateTime.parse(end_date).in_time_zone('Kuala Lumpur').end_of_day })
    }
    scope :with_doctor_code, ->(code) { where(doc_code: code) if code }
    scope :with_laboratory_code, ->(code) { where(lab_code: code) if code }
    scope :with_laboratory_group_code, ->(code) { where(lab_sp_group_code: code) if code }
    scope :exclude_xray_not_done, -> {
        includes(transactionz: :xray_examination).where(xray_examinations: {xray_examination_not_done: 'NO'})
    }
    scope :with_xray_code, ->(code) { where(xray_code: code) if code }

    delegate :name, to: :doc_state, prefix: true, allow_nil: true
    delegate :name, to: :lab_state, prefix: true, allow_nil: true
    delegate :name, to: :xray_state, prefix: true, allow_nil: true
    delegate :name, to: :doc_town, prefix: true, allow_nil: true
    delegate :name, to: :lab_town, prefix: true, allow_nil: true
    delegate :name, to: :xray_town, prefix: true, allow_nil: true
    delegate :certification_date, :fw_code, :fw_name, :fw_gender, :organization_code, to: :transactionz, allow_nil: true
    delegate :code, to: :transactionz, prefix: true, allow_nil: true
    def address_for(selector)
        %I[#{selector}_address1 #{selector}_address2 #{selector}_address3 #{selector}_address4]
            .map { |attribute| try(attribute) }
            .compact
            .join(' ')
            .strip
    end

    def full_address_for(selector)
        address = address_for(selector)
        postcode = try("#{selector}_postcode")
        town_name = try("#{selector}_town_name")
        state_name = try("#{selector}_town_name")

        [address, "#{postcode} #{town_name}".strip, state_name].join(', ')
    end

    def rate_for(service_provider, gender)
        # return service provider group rate if sp group present
        # otherwise, use service provider rate
        case service_provider
        when :doctor
            return doc_sp_group_rate_for(gender) if doc_service_provider_group_id.present?

            doc_rate_for(gender)
        when :laboratory
            return lab_sp_group_rate_for(gender) if lab_service_provider_group_id.present?

            lab_rate_for(gender)
        when :xray_facility
            return xray_sp_group_rate_for(gender) if xray_service_provider_group_id.present?

            xray_rate_for(gender)
        end
    end

    def invoice_number
        return unless transactionz
        return unless transactionz.order_item
        return unless transactionz.order_item.order
        return unless transactionz.order_item.order.latest_ipay88_request

        transactionz.order_item.order.latest_ipay88_request.transaction_id
    end

    def digital_xray_provider
        transactionz.digital_xray_provider&.code || ''
    end

    private

    def doc_sp_group_rate_for(gender)
        return unless doc_code

        gender == :male ? doc_sp_group_male_rate.to_f : doc_sp_group_female_rate.to_f
    end

    def doc_rate_for(gender)
        return unless doc_code

        gender == :male ? doc_male_rate.to_f : doc_female_rate.to_f
    end

    def lab_sp_group_rate_for(gender)
        return unless lab_code

        gender == :male ? lab_sp_group_male_rate.to_f : lab_sp_group_female_rate.to_f
    end

    def lab_rate_for(gender)
        return unless lab_code

        gender == :male ? lab_male_rate.to_f : lab_female_rate.to_f
    end

    def xray_sp_group_rate_for(gender)
        return unless xray_code

        gender == :male ? xray_sp_group_male_rate.to_f : xray_sp_group_female_rate.to_f
    end

    def xray_rate_for(gender)
        return unless xray_code

        gender == :male ? xray_male_rate.to_f : xray_female_rate.to_f
    end
end
