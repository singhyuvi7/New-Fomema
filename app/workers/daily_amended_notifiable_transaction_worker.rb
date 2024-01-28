class DailyAmendedNotifiableTransactionWorker
    include Sidekiq::Worker
    include Sms

    def perform(*args)
        # Send email/sms notification to service provider for notifiable cases amended by FOMEMA
        date = Date.yesterday

        amended_transactions = AmendedNotifiableTransaction.where(created_at: date.beginning_of_day..date.end_of_day)

        notified_list = []
        amended_transactions.each do |amended_transaction|
            @transaction = amended_transaction.transactionz
            @notifiable_type = amended_transaction.notifiable_type
            if amended_transaction.notifiable_type == "Doctor"
                @doctor = amended_transaction.transactionz.doctor
                @doctor_name = @doctor.name
                @clinic_name = @doctor.clinic_name
                @doctor_address = @doctor&.amended_notifiable_doctor_address

            elsif amended_transaction.notifiable_type == "XrayFacility"
                @doctor = amended_transaction.transactionz.xray_facility
                @doctor_name = @doctor.license_holder_name
                @clinic_name = @doctor.name
                @doctor_address = @doctor&.amended_notifiable_xray_address
            end
                @exam_date = @transaction&.medical_examination_date
                @xray_taken_date = @transaction&.xray_examination&.xray_taken_date
                @certification_date = @transaction&.certification_date
                @fw_name = @transaction.fw_name
                @fw_code = @transaction.fw_code
                @fw_passport_number = @transaction.fw_passport_number
                @xray_pending_decision_comment = @transaction&.xray_pending_decision&.comment
                @doctor_info = @transaction&.xray_facility&.amended_notifiable_xray_address
                @xray_result = @transaction&.xray_examination&.result
                @xqcc_result = @transaction.xray_result
                @email = @doctor.email
                notified = amended_transaction.notifiable_type + @transaction.id.to_s

            if amended_transaction.email_sent_at.blank?
                if amended_transaction.disease == "TB" && amended_transaction.notifiable_type == "Doctor" &&  @xray_result == "ABNORMAL"  && @xqcc_result == "UNSUITABLE"
                    send_daily_amended_notifiable_transaction_tuberculosis_email
                elsif amended_transaction.disease == "TB" && @xray_result == "NORMAL" && @xqcc_result == "UNSUITABLE"
                    send_daily_amended_notifiable_transaction_tuberculosis_email
                elsif amended_transaction.disease != "TB"
                    send_daily_amended_notifiable_transaction_email if !notified_list.include?(notified)
                end
                amended_transaction.update(email_sent_at: Time.now, email: @email)
            end

            if amended_transaction.sms_sent_at.blank?
                send_daily_amended_notifiable_transaction_sms if !notified_list.include?(notified)
                amended_transaction.update(sms_sent_at: Time.now, mobile: @phone)
            end
            notified_list << notified
        end
    end

    private

    def send_daily_amended_notifiable_transaction_email
        TransactionMailer.with({
            transaction: @transaction,
            email: @email,
            doctor_name: @doctor_name,
            clinic_name: @clinic_name,
        }).amended_notifiable_transaction_email.deliver_later
    end

    def send_daily_amended_notifiable_transaction_tuberculosis_email
        TransactionMailer.with({
            transaction: @transaction,
            email: @email,
            doctor_name: @doctor_name,
            clinic_name: @clinic_name,
            doctor_address: @doctor_address,
            exam_date: @exam_date,
            xray_taken_date: @xray_taken_date,
            certification_date: @certification_date,
            fw_name: @fw_name,
            fw_code: @fw_code,
            fw_passport_number: @fw_passport_number,
            xray_pending_decision_comment: @xray_pending_decision_comment,
            doctor_info: @doctor_info,
            notifiable_type: @notifiable_type,
            xray_result: @xray_result
        }).amended_notifiable_transaction_tuberculosis_email.deliver_later
    end

    def send_daily_amended_notifiable_transaction_sms
        return if SystemConfiguration.get("MSG_ENABLE_SMS") == "0"

        message = "#{ENV['MESSAGING_FROM']} Hi Dr #{@doctor_name} of #{@clinic_name}. You are advised to notify the nearest DHO of the foreign worker #{@transaction.fw_name} (#{@transaction.fw_code}) who is UNSUITABLE due to a notifiable disease. Please log in MERTS for details."
        @phone = ""
        @phone = @doctor.mobile.strip if @doctor.mobile_with_country_code? || @doctor.mobile_without_country_code?
        @phone = "#{ENV['MOBILE_PREFIX']}#{@phone}" if !@phone.blank? && !@phone.start_with?(ENV['MOBILE_PREFIX'])

        unless @phone == ""
            data = {
                app_code: ENV['MESSAGING_MEDICAL_CODE'],
                app_secret: ENV['MESSAGING_MEDICAL_SECRET'],
                message: message,
                type: ENV['MESSAGING_TYPE'],
                to: @phone
            }
            send_sms(data)
        end
    end
end