require 'typhoeus'

class IPay88
    include ActionView::Helpers::NumberHelper

    def self.payment_url
        raise ArgumentError, "Missing iPay88 payment url. Please add IPAY88_PAYMENT_URL into .env.#{Rails.env} file." if ENV['IPAY88_PAYMENT_URL'].blank?
        ENV['IPAY88_PAYMENT_URL']
    end

    def payment_url
        self.class.payment_url
    end

    def self.merchant_key(payment_method)
        payment_method_code = payment_method&.code
        env_merchant_key = case payment_method_code 
        when 'IPAY_EWALLET'  
            "IPAY88_MERCHANT_KEY_EWALLET"
        when 'IPAY_CC'
            "IPAY88_MERCHANT_KEY_CC"
        when 'IPAY_FPX_B2C'
            'IPAY88_MERCHANT_KEY_B2C'
        when 'IPAY_FPX_B2B'
            'IPAY88_MERCHANT_KEY_B2B'
        else 
            ''
        end
        raise ArgumentError, "Missing iPay88 merchant key. Please add #{env_merchant_key} into .env.#{Rails.env} file." if ENV[env_merchant_key].blank?
        ENV[env_merchant_key]
    end

    def merchant_key(payment_method)
        self.class.merchant_key(payment_method)
    end

    def self.merchant_code(payment_method)
        payment_method_code = payment_method&.code
        env_merchant_code = case payment_method_code 
        when 'IPAY_EWALLET'  
            "IPAY88_MERCHANT_CODE_EWALLET"
        when 'IPAY_CC'
            "IPAY88_MERCHANT_CODE_CC"
        when 'IPAY_FPX_B2C'
            'IPAY88_MERCHANT_CODE_B2C'
        when 'IPAY_FPX_B2B'
            'IPAY88_MERCHANT_CODE_B2B'
        else 
            ''
        end
        raise ArgumentError, "Missing iPay88 merchant code. Please add #{env_merchant_code} into .env.#{Rails.env} file." if ENV[env_merchant_code].blank?
        ENV[env_merchant_code]
    end

    def merchant_code(payment_method)
        self.class.merchant_code(payment_method)
    end

    def self.currency
        ENV["IPAY88_CURRENCY"] || "MYR"
    end

    def currency
        self.class.currency
    end

    def self.lang
        "UTF-8"
    end

    def lang
        self.class.lang
    end

    def self.signature_type
        "SHA256"
    end

    def signature_type
        self.class.signature_Type
    end

    def self.sha256(signature_string)
        return '' if signature_string.blank?
        Digest::SHA256.hexdigest(signature_string)
    end

    def sha256(signature_string)
        self.class.sha256(signature_string)
    end
end