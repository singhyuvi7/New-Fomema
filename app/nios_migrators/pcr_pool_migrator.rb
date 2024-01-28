class PcrPoolMigrator < NiosBaseMigrator

    def migrate
        nios_pcr_pools = migration_source_data

        # TODO: Replace loop with find_each for real migration
        # https://api.rubyonrails.org/classes/ActiveRecord/Batches.html#method-i-find_each
        nios_pcr_pools.each do |nios_pcr_pool|
            transaction_code = nios_pcr_pool.trans_id
            new_transaction = get_transaction(transaction_code)

            if new_transaction.present?
                if already_migrate?(nios_pcr_pool.id)
                    puts "#{transaction_code} already migrated previously. SKIPPED"
                else
                    pcr_pool_data = map_data(nios_pcr_pool, new_transaction)
                    new_pcr_pool = PcrPool.create(pcr_pool_data)
                    puts "migrated #{transaction_code} into ID: #{new_pcr_pool.id}"
                end
            else
                puts "#{transaction_code} not exist, please migrate this transaction first"
            end

        end

        puts "PCR Pool migration completed"
    end

    def migration_source_data
        nios_pcr_pools = Nios::DxpcrPool.limit(5)
    end

    # I override this method for demo purpose. In real live, please migrate transaction first
    def get_transaction(transaction_code)
        transaction = Transaction.find(1)
    end

    private


    def map_data(nios_pcr_pool, new_transaction)
        migrate_data = {}

        # legacy data indicator
        nios_trans_id = nios_pcr_pool.trans_id

        migrate_data[:is_legacy] = true
        migrate_data[:trans_id] = nios_trans_id
        migrate_data[:legacy_id] = nios_pcr_pool.id
        # new structure data mapping
        migrate_data[:transaction_id] = new_transaction.id
        migrate_data[:created_at] = nios_pcr_pool.create_date
        migrate_data[:updated_at] = nios_pcr_pool.modify_date

        case_type = map_case_type(nios_pcr_pool)
        status = map_status(nios_pcr_pool)
        source = map_source(nios_pcr_pool)

        if status == 'ASSIGN'
            migrate_data[:picked_up_at] = nios_pcr_pool.modify_date
            migrate_data[:picked_up_by] = map_picked_up_by(nios_pcr_pool)
        end

        migrate_data[:case_type] = case_type
        migrate_data[:status] = status
        migrate_data[:source] = source

        if source == 'PENDING_REVIEW' || source == 'XQCC_REVIEW'
            sourceable = map_sourceable(nios_trans_id, source)

            migrate_data[:sourceable_type] = sourceable[:sourceable_type]
            migrate_data[:sourceable_id] = sourceable[:sourceable_id]
        end

        migrate_data
    end

    def map_status(nios_pcr_pool)
        return 'ASSIGN' if nios_pcr_pool.audit_film_id.present?
        return 'PCR_POOL'
    end

    def map_source(nios_pcr_pool)
        source = nil
        case nios_pcr_pool.source_ref.to_s
        when "1"
            if nios_pcr_pool.status == 'ABNORMAL'
                source = 'MERTS'
            else
                source = 'XQCC_REVIEW'
            end
        when "2"
            source = 'PENDING_REVIEW'
        else
            # not sure if source null
        end

        source
    end

    def map_case_type(nios_pcr_pool)
        case_type = nil

        case nios_pcr_pool.status
        when "ABNORMAL"
            case_type = 'XRAY_EXAMINATION_ABNORMAL'
        when "APPEAL"
            case_type = 'XRAY_EXAMINATION_APPEAL'
        when "AUDIT"
            case_type = 'XQCC_PENDING_REVIEW_PCR_POOL'
        when "IDENTICAL"
            case_type = 'XQCC_REVIEW_IDENTICAL'
        when "IQA"
            case_type = 'XQCC_REVIEW_IQA'
        when "MISMATCH"
            case_type = 'XQCC_REVIEW_MISMATCH'
        when "SUSPICIOUS"
            case_type = 'XQCC_REVIEW_SUSPICIOUS'
        when "WRONG"
            case_type = 'XQCC_REVIEW_WRONG_TRANSMISSION'
        else
            case_type = nios_pcr_pool.status
        end

        case_type
    end

    # for PENDING_REVIEW or XQCC_REVIEW source only. Create polymorphic relations with PENDING_REVIEW / XQCC_REVIEW
    def map_sourceable(trans_id, source)

        sourceable_model = nil

        if source == 'PENDING_REVIEW'
        sourceable_model = XrayPendingReview.where(trans_id: trans_id).first
        end

        if source == 'XQCC_REVIEW'
        sourceable_model = XrayReview.where(trans_id: trans_id).first
        end

        sourceable_type = nil
        sourceable_id = nil

        sourceable = {
            :sourceable_type => sourceable_type,
            :sourceable_id => sourceable_id,
        }

        if sourceable_model.present?
        sourceable[:sourceable_type] = sourceable_model.class.name
        sourceable[:sourceable_id] = sourceable_model.id
        end

        sourceable

    end

    def map_picked_up_by(nios_pcr_pool)
        nios_pcr_review = Nios::DxpcrAuditFilm.find(nios_pcr_pool.audit_film_id)
        nios_user_uuid = nios_pcr_review.creator_id
        nios_user = get_nios_user(nios_user_uuid)
        new_user = get_user(nios_user.userid)
        new_user.id
    end

    def already_migrate?(id)
        pcr_pool = PcrPool.where(legacy_id: id).first
        return true if pcr_pool.present?
        return false
    end

end