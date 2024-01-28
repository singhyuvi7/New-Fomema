require 'typhoeus'

class Boleh
    include ActionView::Helpers::NumberHelper

    def self.payment_url
        raise ArgumentError, "Missing Boleh payment url. Please add BOLEH_PAYMENT_URL into .env.#{Rails.env} file." if ENV['BOLEH_PAYMENT_URL'].blank?
        ENV['BOLEH_PAYMENT_URL']
    end

    def payment_url
        self.class.payment_url
    end

    def self.payment_url_web
        raise ArgumentError, "Missing Boleh payment url. Please add BOLEH_PAYMENT_URL_WEB into .env.#{Rails.env} file." if ENV['BOLEH_PAYMENT_URL_WEB'].blank?
        ENV['BOLEH_PAYMENT_URL_WEB']
    end

    def payment_url_web
        self.class.payment_url_web
    end

    def self.payment_requery_url
        raise ArgumentError, "Missing Boleh payment requery url. Please add BOLEH_REQUERY_URL into .env.#{Rails.env} file." if ENV['BOLEH_REQUERY_URL'].blank?
        ENV['BOLEH_REQUERY_URL']
    end

    def payment_requery_url
        self.class.payment_requery_url
    end

    def self.api_key
        raise ArgumentError, "Missing Boleh API key. Please add BOLEH_API_KEY into .env.#{Rails.env} file." if ENV['BOLEH_API_KEY'].blank?
        ENV['BOLEH_API_KEY']
    end

    def api_key
        self.class.api_key
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