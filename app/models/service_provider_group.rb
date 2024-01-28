class ServiceProviderGroup < ApplicationRecord
    CATEGORIES = {
        "Doctor" => "Doctor",
        "Laboratory" => "Laboratory",
        "XrayFacility" => "X-Ray Facility"
    }

    STATUSES = [
        "ACTIVE", "INACTIVE"
    ]

    audited
    include CaptureAuthor
	include Sequence
    include SearchGeo
    include Sage

    belongs_to :bank, optional: true
    belongs_to :payment_method, optional: true
    has_many :doctors
    has_many :laboratories
    has_many :xray_facilities
    has_many :sp_fin_batches, as: :batchable

    validates :name, presence: true

    after_create :update_code
    after_create :set_country_id
    after_commit :post_finance_system, on: :create
    after_commit :patch_finance_system, on: :update

    scope :without_giro, lambda {
        joins(:payment_method).where.not(payment_methods: { payment_code: ['OUT_GIROROC','OUT_GIRONEWIC','OUT_GIROPASSPORT'] })
    }

    def self.search_code(code)
        return all if code.blank?
        code = code.strip
        where('service_provider_groups.code = ?', "#{code}")
    end

    def self.search_name(name)
        return all if name.blank?
        name = name.strip
        where('service_provider_groups.name ILIKE ?', "%#{name}%")
    end

    def self.search_category(category)
        return all if category.blank?
        where('service_provider_groups.category = ?', "#{category}")
    end

    def self.search_status(status)
        return all if status.blank?
        where('service_provider_groups.status = ?', status)
    end

	def update_code
		self.update({
			code: generate_code
		})
	end

	def generate_code
		sprintf("#{self.category[0..0].upcase}%05d", get_sequence)
	end

	def get_sequence
		sequence_name = "sp_group_#{self.category.snakecase}_seq"
		seq_nextval(sequence_name)
	end

    def set_country_id
        self.update_columns(country_id: Country.malaysia_id)
    end

    def members
        case self.category
        when 'Doctor'
            self.doctors
        when 'Laboratory'
            self.laboratories
        when 'XrayFacility'
            self.xray_facilities
        else
            []
        end
    end

    def rate_for(gender)
       gender == :male ? male_rate : female_rate
    end

    def post_finance_system
        @vendor_status = 'NEW_APPROVED'
        submit_vendor (self)
    end

    def patch_finance_system
        @vendor_status = 'UPDATE_APPROVED'
        submit_vendor (self)
    end
end
