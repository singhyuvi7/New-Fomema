class WeeklyMohNotificationDiseasesSeedWorker
    include Sidekiq::Worker

    def perform(*args)
        date            = Date.today
        date            += 1.day if date.wday == 0 # if get 0 (Sunday), must at least 1. Because Sunday is considered the last day, it will mess with the start_date.
        start_date      = date.last_week.beginning_of_week - 1.day # Must start on Sunday. Beginning of week always finds a Monday.
        end_date        = start_date + 1.week

        # Health check, sets communicable diseases if somehow not updated correctly.
        communicable_diseases_list = Condition.where(code: ["3501", "3502", "3503", "3504", "3505", "3506"]).pluck(:id)
        Transaction.where(status: ["REVIEW", "CERTIFIED"], updated_at: start_date...end_date, transaction_date: (start_date - 1.year)..end_date).includes(doctor_examination: [:doctor_examination_details], medical_examination: [:medical_examination_details]).each {|transaction| transaction.check_for_communicable_diseases(communicable_diseases_list) }

        unsuitable_ids  = MohNotificationCheck.where(final_result: "UNSUITABLE", final_result_date: start_date...end_date).pluck(:transaction_id)
        all_ids         = Transaction.where(id: unsuitable_ids, communicable_diseases: true)
        MohNotification.seed_transactions(all_ids)

        # Note: these are all old codes. Using MohNotificationCheck now instead of these.
            # transactions    = Transaction.where(status: ["REVIEW", "CERTIFIED"], communicable_diseases: true)

            # # Regular Certification
            # regular         = transactions.where(xray_pending_review_id: nil, certification_date: start_date...end_date).where("medical_pr_source is null or medical_pr_source != ? ", "MERTS").pluck(:id)

            # # Medical PR
            # medical_pr      = transactions.where(xray_pending_review_id: nil, medical_pr_source: "MERTS", medical_quarantine_release_date: start_date...end_date).pluck(:id)

            # # XQCC PR
            # xqcc_pr         = transactions.where.not(xray_pending_review_id: nil).where(xray_quarantine_release_date: start_date...end_date).where("medical_pr_source is null or medical_pr_source != ? ", "MERTS").pluck(:id)

            # # Latest between Medical & XQCC PR
            # latest_pr       = transactions.where.not(xray_pending_review_id: nil).where(medical_pr_source: "MERTS").where("(medical_quarantine_release_date >= ? AND medical_quarantine_release_date < ?) OR (xray_quarantine_release_date >= ? AND xray_quarantine_release_date < ?)", start_date, end_date, start_date, end_date).pluck(:id)

            # all_ids         = (regular + medical_pr + xqcc_pr + latest_pr).uniq.sort
    end
end

# Debugging for NF-1536
# start_date = "2020-10-01".to_date;
# end_date = Date.today + 1.day;
# fw = ForeignWorker.find_by(code: "W9EM506359");

# t = Transaction.where("certification_date > ?", "2020-10-10").find_by(foreign_worker_id: fw.id);
# transactions    = Transaction.where(status: ["REVIEW", "CERTIFIED"], communicable_diseases: true, medical_status: "CERTIFIED").where(id: t.id);
# regular         = transactions.where(xray_pending_review_id: nil, certification_date: start_date...end_date).where("medical_pr_source is null or medical_pr_source != ? ", "MERTS").pluck(:id);
# medical_pr      = transactions.where(xray_pending_review_id: nil, medical_pr_source: "MERTS", medical_quarantine_release_date: start_date...end_date).pluck(:id);
# xqcc_pr         = transactions.where.not(xray_pending_review_id: nil).where(xray_quarantine_release_date: start_date...end_date).where("medical_pr_source is null or medical_pr_source != ? ", "MERTS").pluck(:id);
# latest_pr         = transactions.where.not(xray_pending_review_id: nil).where(medical_pr_source: "MERTS").where("(medical_quarantine_release_date >= ? AND medical_quarantine_release_date < ?) OR (xray_quarantine_release_date >= ? AND xray_quarantine_release_date < ?)", start_date, end_date, start_date, end_date).pluck(:id);
# pp "regular: #{ regular }, medical_pr: #{ medical_pr }, xqcc_pr: #{ xqcc_pr }, latest_pr: #{ latest_pr }"
# pp t.slice(:status, :communicable_diseases, :medical_status, :xray_pending_review_id, :certification_date, :medical_pr_source, :medical_quarantine_release_date, :xray_quarantine_release_date)