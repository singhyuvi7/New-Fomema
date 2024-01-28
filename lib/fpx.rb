require 'typhoeus'

class Fpx
    include ActionView::Helpers::NumberHelper

    def self.payment_url
        raise ArgumentError, "Missing FPX payment url. Please add FPX_PAYMENT_URL into .env.#{Rails.env} file." if ENV['FPX_PAYMENT_URL'].blank?
        ENV['FPX_PAYMENT_URL']
    end

    def payment_url
        self.class.payment_url
    end

    def self.payment_requery_url
        raise ArgumentError, "Missing FPX payment requery url. Please add FPX_AE_URL into .env.#{Rails.env} file." if ENV['FPX_AE_URL'].blank?
        ENV['FPX_AE_URL']
    end

    def payment_requery_url
        self.class.payment_requery_url
    end

    def self.msg_token(payment_method)
        payment_method_code = payment_method&.code
        env_msg_token = case payment_method_code 
        when 'PAYNET_FPX_B2C'
            'FPX_MSG_TOKEN_B2C'
        when 'PAYNET_FPX_B2B'
            'FPX_MSG_TOKEN_B2B'
        else 
            ''
        end
        raise ArgumentError, "Missing FPX message token. Please add #{env_msg_token} into .env.#{Rails.env} file." if ENV[env_msg_token].blank?
        ENV[env_msg_token]
    end

    def msg_token(payment_method)
        self.class.msg_type(payment_method)
    end

    def self.msg_token_name(msg_token)
        msg_token_name = case msg_token
        when '01'
            'RETAIL BANKING'
        when '02'
            'CORPORATE BANKING'
        else
            ''
        end
    end

    def msg_token_name(msg_token)
        self.msg_token_name(msg_token)
    end

    def self.seller_ex_id
        ENV["FPX_SELLER_EXCHANGE_ID"] || ""
    end

    def seller_ex_id
        self.class.seller_ex_id
    end

    def self.seller_id
        ENV["FPX_SELLER_ID"] || ""
    end

    def seller_id
        self.class.seller_id
    end

    def self.seller_bank_code
        ENV["FPX_SELLER_BANK_CODE"] || "01"
    end

    def seller_bank_code
        self.class.seller_bank_code
    end

    def self.currency
        ENV["FPX_CURRENCY"] || "MYR"
    end

    def currency
        self.class.currency
    end

    def self.transaction_time
        Time.now.strftime("%Y%m%d%H%M%S")
    end

    def transaction_time
        self.class.transaction_time
    end

    def self.version
        "7.0"
    end

    def version
        self.class.version
    end

    def self.sha1(signature_string)
        return '' if signature_string.blank?

        private_key_file = File.open(ENV["FPX_SELLER_KEY_PATH"])
        private_key = OpenSSL::PKey::RSA.new(File.read(private_key_file))
        digest = OpenSSL::Digest::SHA1.new
        signature = private_key.sign(digest, signature_string)
        hex_signature = signature.unpack('H*').first.upcase
        return hex_signature
    end

    def sha1(signature_string)
        self.class.sha1(signature_string)
    end

    def self.sha256(signature_string)
        return '' if signature_string.blank?

        private_key_file = File.open(ENV["FPX_SELLER_KEY_PATH"])
        private_key = OpenSSL::PKey::RSA.new(File.read(private_key_file))
        digest = OpenSSL::Digest::SHA256.new
        signature = private_key.sign(digest, signature_string)
        hex_signature = signature.unpack('H*').first.upcase
        return hex_signature
    end

    def sha256(signature_string)
        self.class.sha256(signature_string)
    end

    def self.get_public_key
        raw_current = File.read(ENV['FPX_CURRENT_CERT_PATH'])
        cert_current = OpenSSL::X509::Certificate.new raw_current
        valid_to = cert_current.not_after

        if Time.now < valid_to
            public_key = cert_current.public_key
        else
            Rails.logger.info "One certificate found expired. ErrorCode : [07]"
            raw = File.read(ENV['FPX_CERT_PATH'])
            cert = OpenSSL::X509::Certificate.new raw
            valid_to = cert.not_after

            if Time.now < valid_to
                public_key = cert.public_key
                # Rename cert_current to cert_current_yyyymmdd
                File.rename(ENV['FPX_CURRENT_CERT_PATH'], "#{ENV['FPX_CURRENT_CERT_PATH']}_#{Time.now.strftime('%Y%m%d')}")
                # Rename the cert to cert_current
                File.rename(ENV['FPX_CERT_PATH'], "#{ENV['FPX_CURRENT_CERT_PATH']}")
            else
                Rails.logger.info "Both certificates expired. ErrorCode : [08]"
            end
        end
        return public_key
    end

    def get_public_key
        self.class.get_public_key
    end

    def self.verify_checksum(signed, to_sign)
        digest = OpenSSL::Digest::SHA1.new
        # hextobin = signed.hex.to_s(2).rjust(signed.size*4, '0')
        hextobin = signed.scan(/../).map { |x| x.hex }.pack('c*')
        public_key = get_public_key
        is_valid = public_key.verify(digest, hextobin, to_sign)
        return is_valid
    end

    def verify_checksum(signed, to_sign)
        self.class.verify_checksum(signed, to_sign)
    end
end