class Internal::MohNotificationsController < InternalController
    before_action -> { can_access?("VIEW_MOH_NOTIFICATIONS") }, only: [:index]
    before_action -> { can_access?("EDIT_MOH_NOTIFICATIONS") }, only: [:release_notification]

    def index
        if params[:result_date_start].present? && params[:result_date_end].present?
            start_date      = params[:result_date_start].to_date
            end_date        = params[:result_date_end].to_date.tomorrow

            # without_quarantine  = Transaction.where(status: ["REVIEW", "CERTIFIED"], communicable_diseases: true, xray_pending_review_id: nil).where("(medical_pr_source is null or medical_pr_source != ?) and certification_date > ? and certification_date <= ?", "MERTS", start_date, end_date).pluck(:id)
            # notifications       = MohNotification.where("(moh_notifications.quarantined = ? AND quarantine_release_date > ? AND quarantine_release_date <= ?) or transaction_id in (?)", "Y", start_date, end_date, without_quarantine)

            @moh_notification_checks    = MohNotificationCheck.where(final_result: "UNSUITABLE", final_result_date: start_date...end_date).pluck(:transaction_id, :final_result_date).to_h
            notifications               = MohNotification.where(transaction_id: @moh_notification_checks.keys)
            display_filter  = params[:displayed_cases] || "Unreleased"
            notifications   = notifications.where(release_flag: nil)        if display_filter == "Unreleased"
            notifications   = notifications.where.not(release_flag: nil)    if display_filter == "Released"
            notifications   = notifications.where(release_flag: "Y")    if display_filter == "Released - Y"
            notifications   = notifications.where(release_flag: "N")    if display_filter == "Released - N"
            @noti_ids       = notifications.select(:transaction_id, :id).order(:transaction_id).page(params[:page]).per(get_per)
        else
            notifications   = MohNotification.none
            @noti_ids       = notifications.page(params[:page]).per(get_per)
        end

        @total_count    = notifications.size
        @notifications  = MohNotification.where(id: @noti_ids.map(&:id)).includes(:transactionz).order(:transaction_id)
        @numbering      = ((params[:page] || 1).to_i - 1) * get_per
    end

    def release_notification
        notifications_hash_map = params[:notifications].to_unsafe_h.map do |key, hash|
            [key.to_i, hash[:release].present? ? hash[:release] : nil]
        end.to_h

        MohNotification.where(id: notifications_hash_map.keys).each do |notification|
            release_flag    = notifications_hash_map[notification.id]
            updated_check   = notification.release_flag != release_flag
            notification.release_flag = release_flag

            if updated_check
                notification.notification_release_date ||= Time.now
            else
                notification.notification_release_date = nil
            end

            notification.save
        end

        flash[:notice] = "Notifications updated"
        redirect_to internal_moh_notifications_path(result_date_start: params[:result_date_start], result_date_end: params[:result_date_end])
    end
end