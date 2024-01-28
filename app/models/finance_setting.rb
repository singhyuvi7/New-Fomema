class FinanceSetting < ApplicationRecord
    audited
    include CaptureAuthor

    CATEGORIES = {
        "REFUND" => "Refund",
        "COLLECTION" => "Collection",
        "PAYMENT" => "Payment",
        "REVENUE" => "Revenue",
        "BANK" => "Bank",
        "SOURCE_TYPE" => "Source Type",
        "GROUP" => "Group"
    }

    validates :code, presence: true, uniqueness: true

    scope :get_value, -> (code) {
        data = self.where(code: code) 
        return !data.blank? ? data.pluck(:value).first : ""
    }

    scope :code, -> code { where(code: code.strip) }
    scope :category, -> category { where(category: category) }
    scope :description, -> description { where("lower(description) LIKE ?","%#{description.downcase}%") }
    scope :value, -> value { where(value: value.strip) }

end
