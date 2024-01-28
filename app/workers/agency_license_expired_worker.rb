class AgencyLicenseExpiredWorker
    include Sidekiq::Worker

    def perform(*args)
        # Deactivate agency if agency's license expired
        Agency.where("agencies.status = ? and agencies.license_expired_at < ?", 'ACTIVE', DateTime.now.beginning_of_day)
        .joins("join users on agencies.code = users.code")
        .select("agencies.id as agency_id, users.id as user_id").each do |agency_user|
            
            agency = Agency.find_by(id: agency_user.agency_id)
            user = User.find_by(id: agency_user.user_id)

            agency.update({
                status: "INACTIVE"
            })
        end
    end
end