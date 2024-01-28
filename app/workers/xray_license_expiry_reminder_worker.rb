class XrayLicenseExpiryReminderWorker < ActionController::Base
    include Sidekiq::Worker

    def perform(*args)
        @csv = [["Xray Code","Xray Facility Name","License Holder Name","Xray License Expiry Date","District Name","State Name"]]
        data = []

        data = ActiveRecord::Base.connection.execute("
            select xf.code, xf.name as xray_name, xf.license_holder_name, xf.xray_license_expiry_date,
            t2.name as town_name , s2.name as state_name
            from xray_facilities xf, states s2, towns t2
            where s2.id = xf.state_id and t2.id = xf.town_id and xray_license_expiry_date = current_date ::timestamp - '1 day'::interval
        ")

        if data.count > 0
            puts "Send email if there is data"
            data.each {|row| @csv << row.values }
            XrayMailer.with({
                email:          SystemConfiguration.find_by(code: 'MSPD_EMAIL')&.value,
                csv:            CSV.generate { |csv| @csv.map{ |row| csv << row } },
            }).xray_license_expiry_reminder_email.deliver_later
        end
    end
end