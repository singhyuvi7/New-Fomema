class LabLicenseExpiryReminderWorker
    include Sidekiq::Worker

    def perform(*args)
        # Send reminder email x days before license expired
        Laboratory.where("samm_expiry_date = current_date ::timestamp + '2 month'::interval").each do | laboratory |

                if !laboratory.blank?
                    LabMailer.with({
                        laboratory: laboratory 
                    }).lab_license_expiry_reminder_email.deliver_later
                end
        end

        Laboratory.where("samm_expiry_date = current_date ::timestamp + '1 month'::interval").each do | laboratory |

            if !laboratory.blank?
                LabMailer.with({
                    laboratory: laboratory 
                }).lab_license_expiry_reminder_email.deliver_later
            end
        end
    end
end