class AgencyRenewalReminderWorker
    include Sidekiq::Worker

    def perform(*args)
        # Create renewal order and send reminder email x days before account expired
        Agency.where("agencies.status = ? and agencies.expired_at <= ?", 'ACTIVE', DateTime.now.beginning_of_day + SystemConfiguration.find_by(code: "AGENCY_RENEWAL_X_DAYS_BEFORE_EXPIRY").value.to_i.days)
        .joins("inner join users on agencies.code = users.code").each do |agency|

            if !agency.has_created_renewal_order?
                user = User.find_by(code: agency.code)
                fee = Fee.find_by(code: 'AGENCY_RENEWAL')
                organization = Organization.find_by(code: 'PT')
                order = Order.create({
                    customerable: agency,
                    category: "AGENCY_RENEWAL",
                    date: Time.now,
                    amount: fee.amount,
                    status: 'NEW',
                    created_by: user.id,
                    updated_by: user.id,
                    organization_id: organization.id
                })
                order.order_items.create({
                    order_itemable: agency,
                    fee_id: fee.id,
                    amount: fee.amount,
                    created_by: user.id,
                    updated_by: user.id
                })

                agency.update({
                    renewal_order_created: true
                })

                if !agency&.email.blank?
                    AgencyMailer.with({
                        agency: agency,
                        renewal_order_link: "#{ENV["APP_URL_PORTAL"]}orders/#{order.id}/edit",
                        renewal_fee: fee.amount
                    }).renewal_reminder_email.deliver_later
                end
            end
        end
    end
end