class XrayLicenseStatusWorker
    include Sidekiq::Worker

    def perform(*args)

        # update expired license
        XrayFacility.where("xray_license_expiry_date < ? and (moh_license_status is null or moh_license_status = ?)",Date.today,'VALID').update_all(moh_license_status: 'INVALID')

        # update valid license
        XrayFacility.where("xray_license_expiry_date >= ? and (moh_license_status is null or moh_license_status = ?)",Date.today,'INVALID').update_all(moh_license_status: 'VALID')

    end
end
