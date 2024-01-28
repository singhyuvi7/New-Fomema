require 'typhoeus'

class Swipe
    include ActionView::Helpers::NumberHelper

    def self.payment_url
        raise ArgumentError, "Missing Swipe payment url. Please add SWIPE_PAYMENT_URL into .env.#{Rails.env} file." if ENV['SWIPE_PAYMENT_URL'].blank?
        ENV['SWIPE_PAYMENT_URL']
    end

    def payment_url
        self.class.payment_url
    end

    def self.merchant_key(payment_method)
        payment_method_code = payment_method&.code
        env_merchant_key = case payment_method_code 
        when 'SWIPE_EWALLET'  
            "SWIPE_MERCHANT_KEY_EWALLET"
        when 'SWIPE_CC'
            "SWIPE_MERCHANT_KEY_CC"
        when 'SWIPE_FPX_B2C'
            'SWIPE_MERCHANT_KEY_B2C'
        when 'SWIPE_FPX_B2B'
            'SWIPE_MERCHANT_KEY_B2B'
        else 
            ''
        end
        raise ArgumentError, "Missing Swipe merchant key. Please add #{env_merchant_key} into .env.#{Rails.env} file." if ENV[env_merchant_key].blank?
        ENV[env_merchant_key]
    end

    def merchant_key(payment_method)
        self.class.merchant_key(payment_method)
    end

    def self.merchant_code(payment_method)
        payment_method_code = payment_method&.code
        env_merchant_code = case payment_method_code 
        when 'SWIPE_EWALLET'  
            "SWIPE_MERCHANT_CODE_EWALLET"
        when 'SWIPE_CC'
            "SWIPE_MERCHANT_CODE_CC"
        when 'SWIPE_FPX_B2C'
            'SWIPE_MERCHANT_CODE_B2C'
        when 'SWIPE_FPX_B2B'
            'SWIPE_MERCHANT_CODE_B2B'
        else 
            ''
        end
        raise ArgumentError, "Missing Swipe merchant code. Please add #{env_merchant_code} into .env.#{Rails.env} file." if ENV[env_merchant_code].blank?
        ENV[env_merchant_code]
    end

    def merchant_code(payment_method)
        self.class.merchant_code(payment_method)
    end

    def self.currency
        ENV["SWIPE_CURRENCY"] || "MYR"
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

    def self.payment_id(payment_method)
        payment_method_code = payment_method&.code
        payment_id = case payment_method_code
        when 'SWIPE_CC'
            '1'
        when 'SWIPE_EWALLET'
            '2'
        when 'SWIPE_FPX_B2B'
            '3'
        when 'SWIPE_FPX_B2C'
            '4'
        else
            ''
        end
    end
    
    def payment_id(payment_method)
        self.class.payment_id(payment_method)
    end


end