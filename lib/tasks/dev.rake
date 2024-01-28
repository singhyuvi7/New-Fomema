namespace :dev do
    desc "set user's email to bookdoc email: <prefix>+code@bookdoc.com, prefix=fonghy"
    task set_bookdoc_email: :environment do
        email = "'#{ENV.fetch("prefix") { "fonghy" }}+'".upcase
        sql = "update users set email = upper(#{email} || code || '@BOOKDOC.COM') where email not ilike '%@bookdoc.com' or email is null and code is not null";
        ActiveRecord::Base.connection.execute(sql)
    end

    desc "find set of service providers ready for test. limit=3"
    task find_ready_sp: :environment do
        require 'pp'
        # doctor = Doctor.joins(:user).joins(:laboratory).joins(:xray_facility).first
        sql = "select d.id doctor_id, d.code doctor_code, du.code doctor_user_code, du.email doctor_user_email, 
        l.id laboraotry_id, l.code laboraotry_code, lu.code laboraotry_user_code, lu.email laboraotry_user_email, 
        x.id xray_facility_id, x.code xray_facility_code, xu.code xray_facility_user_code, xu.email xray_facility_user_email
        from doctors d join users du on d.id = du.userable_id and du.userable_type = 'Doctor' 
        join laboratories l on d.laboratory_id = l.id join users lu on l.id = lu.userable_id and lu.userable_type = 'Laboratory' 
        join xray_facilities x on d.xray_facility_id = x.id join users xu on x.id = xu.userable_id and xu.userable_type = 'XrayFacility' 
        limit #{ENV.fetch("limit") {"3"}}"
        rs = ActiveRecord::Base.connection.execute(sql)
        rs.each do |row|
            puts "#" * 30
            pp row
        end
    end
end