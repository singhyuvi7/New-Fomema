class AgencyRenewalUnpaidWorker
    include Sidekiq::Worker

    def perform(*args)
        # Change agency role to AGENCY_UNPAID if agency's renewal fee is not paid
        Agency.where("agencies.status = ? and agencies.expired_at < ?", 'ACTIVE', DateTime.now.beginning_of_day)
        .joins("join users on agencies.code = users.code")
        .select("agencies.id as agency_id, users.id as user_id").each do |agency_user|

            user = User.find_by(id: agency_user.user_id)
            role = Role.find_by(code: 'AGENCY_UNPAID')
            user.update({
                role_id: role.id
            })

            agency = Agency.find_by(id: agency_user.agency_id)
            agency.update({
                sop_acknowledge: false
            })

        end
    end
end