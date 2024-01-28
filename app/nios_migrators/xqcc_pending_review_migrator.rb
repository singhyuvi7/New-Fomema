class XqccPendingReviewMigrator < NiosBaseMigrator

    # NOTE: 60% completed. Waiting for NF-956
    def migrate
        nios_pending_reviews = migration_source_data

        # TODO: Replace loop with find_each for real migration
        # https://api.rubyonrails.org/classes/ActiveRecord/Batches.html#method-i-find_each
        nios_pending_reviews.each do |nios_pending_review|
            transaction_code = nios_pending_review.trans_id
            new_transaction = get_transaction(transaction_code)
            if new_transaction.present?
                if already_migrate?(nios_pending_review.trans_id)
                    puts "#{transaction_code} already migrated previously. SKIPPED"
                else
                    pending_review_data = map_data(nios_pending_review, new_transaction)
                    new_pending_review = XrayPendingReview.create(pending_review_data)

                    # update main transaction status
                    puts "migrated #{transaction_code} into ID: #{new_pending_review.id}"
                end
            else
                puts "#{transaction_code} not exist, please migrate this transaction first"
            end
        end

        puts "Pending Review migration completed"
    end

    def migration_source_data
        # NOTE: only merts source goes to pending review, others source to pending decision (new flow)
        merts_source = 1

        nios_pending_reviews = Nios::XqccQuarantineFwDoc.where(qrtn_source: merts_source).limit(5)
    end

    # I override this method for demo purpose. In real live, please migrate transaction first
    def get_transaction(transaction_code)
        transaction = Transaction.find(1)
    end

    private
    # TODO: update the mapping data based on NF-956 ticket
    def map_data(nios_pending_review, new_transaction)
        migrate_data = {}

        # legacy data indicator
        migrate_data[:is_legacy] = true
        migrate_data[:trans_id] = nios_pending_review.trans_id

        # new structure data mapping
        migrate_data[:transaction_id] = new_transaction.id
        migrate_data[:quarantine_reason] = nios_pending_review.quarantine_reason
        migrate_data[:created_at] = nios_pending_review.time_inserted
        migrate_data[:updated_at] = nios_pending_review.modification_date
        migrate_data[:source] = map_source(nios_pending_review)
        migrate_data[:status] = map_status(nios_pending_review)
        migrate_data[:quarantine_type] = map_quarantine_type(nios_pending_review)

        migrate_data
    end

    # xray_pending_reviews.source = xqcx_quarantine_fw_doc.qrtn_source
    def map_source(nios_pending_review)
        source = nil

        case nios_pending_review.qrtn_source.to_s

        when "1"
            source = 'MERTS'
        when "2"
        # from MEDICAL
        when "3"
        # from PCR
        # this data row should migrate to PENDING DECISION
        when "4"
        # from XQCC
        # this data row should migrate to PENDING DECISION
        end

        source
    end

    def map_status(nios_pending_review)
        status = nil

        case nios_pending_review.status

        when "A" # approved
            status = 'XQCC_PENDING_REVIEW'
        when "N" # new
        # TODO: Get the meaning of N and map it, ticket NF-956
        when "R" # rejected
        # TODO: Get the meaning of R and map it, ticket NF-956
        when "S" # submit for approval
        # TODO: Get the meaning of R and map it, ticket NF-956
        end

        status
    end

    def map_quarantine_type(nios_pending_review)
        quarantine_type = nil

        case nios_pending_review.source
        when "M" # Worker has been manually tagged for monitoring - 28 cases
            quarantine_type = 'MANUAL'
        when "P" # Abnormal lab/x-ray findings with incomplete (no certification) last transaction - 247 cases
            quarantine_type = 'ABNORMAL_FINDING'
        when "Q" # Normal quarantine - 72892 cases
            quarantine_type = 'NORMAL_QUARANTINE' # from merts
        when "U" # Certified SUITABLE by was previously UNSUITABLE (last transaction) - 6321 cases
            quarantine_type = 'PREVIOUS_UNSUITABLE'
        when "X" # From XQCC to medical pending review - 0 cases
            quarantine_type = 'XQCC_TO_MEDICAL_PENDING_REVIEW'
        end

        quarantine_type
    end

    def already_migrate?(trans_id)
        xray_pending_review = XrayPendingReview.where(trans_id: trans_id).first
        return true if xray_pending_review.present?
        return false
    end

end