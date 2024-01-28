class WsAccessToken < ApplicationRecord
    def xray_facility
        XrayFacility.where(code: self.usercode).first
    end

    def digital_xray_provider
        DigitalXrayProvider.where(code: self.digital_xray_provider_code).first
    end
end
