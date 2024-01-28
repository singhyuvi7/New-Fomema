namespace :fomema_migrate do
    desc "set first password for service provider"
    task set_sp_password: :environment do
        migration_log = MigrationLog.create({
            description: "SP password",
            start_at: Time.now
        })
        User.joins(role: :password_policy).where(roles: {code: ['DOCTOR', 'XRAY_FACILITY', 'RADIOLOGIST']}).each.with_index(1) do |user, index|
            data = {
                password: "#{user.code}#{(user.userable.icno || '').strip.split(//).last(4).join}",
                password_changed_at: (user.role.password_policy.password_expiry + 1).month.ago
            }
            user.update(data)
            puts "#{index} - #{user.code} - #{data[:password]} updated"
        end
        User.joins(role: :password_policy).where(roles: {code: ['LABORATORY']}).each.with_index(1) do |user, index|
            data = {
                password: "#{user.code}#{(user.userable.business_registration_number || '').strip.split(//).last(4).join}",
                password_changed_at: (user.role.password_policy.password_expiry + 1).month.ago
            }
            user.update(data)
            puts "#{index} - #{user.code} - #{data[:password]} updated"
        end
        migration_log.update({
            end_at: Time.now
        })
    end
    
    desc "upload support document"
    task upload_support_document: :environment do
        ProcessFilesWorker.new.perform
    end

    desc "reset user's password and send email"
    task reset_user_password: :environment do
        User.where(ENV.fetch("where") {"email is not null and status = 'ACTIVE'"}).each do |user|
            raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
            user.update({
                reset_password_token: hashed,
                reset_password_sent_at: Time.now
            })
            user.send_reset_password_instructions
            puts "password reset email for #{user.email}"
        end
    end
end