class PcrReviewMigrator < NiosBaseMigrator

    def migrate
        nios_pcr_reviews = migration_source_data

        # TODO: Replace loop with find_each for real migration
        # https://api.rubyonrails.org/classes/ActiveRecord/Batches.html#method-i-find_each
        nios_pcr_reviews.each do |nios_pcr_review|
            transaction_code = nios_pcr_review.trans_id
            new_transaction = get_transaction(transaction_code)

            if new_transaction.present?
                if already_migrate?(nios_pcr_review.id)
                    puts "#{transaction_code} already migrated previously. SKIPPED"
                else
                    pcr_review_data = map_data(nios_pcr_review, new_transaction)
                    new_pcr_review = PcrReview.create(pcr_review_data)
                    puts "migrated #{transaction_code} into ID: #{new_pcr_review.id}"

                    # migrate pcr review details
                    migrate_pcr_review_details(nios_pcr_review, new_pcr_review)

                    # migrate pcr review detail comments
                    migrate_pcr_review_detail_comments(nios_pcr_review, new_pcr_review)
                end
            else
                puts "#{transaction_code} not exist, please migrate this transaction first"
            end
        end

        puts "PCR Review migration completed"
    end

    def migrate_pcr_review_details(nios_pcr_review, new_pcr_review)
        nios_pcr_review_id = nios_pcr_review.id
        nios_pcr_review_details = Nios::DxpcrAuditDetail.where(pcr_audit_film_id: nios_pcr_review_id)
        migrate_detail_data = {}

        unless nios_pcr_review_details.nil?
            nios_pcr_review_details.each do |nios_pcr_review_detail|
                parameter_value = nios_pcr_review_detail.parameter_value

                case nios_pcr_review_detail.parameter_code.to_s
                when "4020"
                    # TODO: confirm is STATUS is RESULT?
                    migrate_detail_data[:result] = map_result(new_pcr_review, parameter_value)
                when "4010"
                    migrate_detail_data[:id_quality] = get_acceptable_value(parameter_value)
                when "4011"
                    # TODO: map this
                when "4012"
                    migrate_detail_data[:thoracic_cage] = get_normal_value(parameter_value)
                when "4013"
                    migrate_detail_data[:heart_shape_and_size] = get_normal_value(parameter_value)
                when "4014"
                    migrate_detail_data[:lung_fields] = get_normal_value(parameter_value)
                when "4015"
                    migrate_detail_data[:mediastinum_and_hila] = get_normal_value(parameter_value)
                when "4016"
                    migrate_detail_data[:pleura_hemidiaphragms_costopherenic_angles] = get_normal_value(parameter_value)
                when "4017"
                    migrate_detail_data[:other_findings] = get_normal_value(parameter_value)
                end
            end

            new_pcr_review.update(migrate_detail_data)

            puts "migrated #{new_pcr_review.trans_id} review detail"
        end
    end

    def migrate_pcr_review_detail_comments(nios_pcr_review, new_pcr_review)

        nios_pcr_review_id = nios_pcr_review.id
        nios_pcr_review_detail_comments = Nios::DxpcrAuditComment.where(pcr_audit_film_id: nios_pcr_review_id)
        migrate_detail_data = {}

        unless nios_pcr_review_detail_comments.nil?
            nios_pcr_review_detail_comments.each do |nios_pcr_review_detail_comment|
                parameter_comment = nios_pcr_review_detail_comment.comments

                case nios_pcr_review_detail_comment.parameter_code.to_s
                when "4118"
                    migrate_detail_data[:comment] = parameter_comment
                when "4112"
                    migrate_detail_data[:thoracic_cage_comment] = parameter_comment
                when "4112"
                    migrate_detail_data[:thoracic_cage_comment] = parameter_comment
                when "4113"
                    migrate_detail_data[:heart_shape_and_size_comment] = parameter_comment
                when "4114"
                    migrate_detail_data[:lung_fields_comment] = parameter_comment
                when "4115"
                    migrate_detail_data[:mediastinum_and_hila_comment] = parameter_comment
                when "4116"
                    migrate_detail_data[:pleura_hemidiaphragms_costopherenic_angles_comment] = parameter_comment
                when "4117"
                    migrate_detail_data[:other_findings_comment] = parameter_comment
                end
            end

            new_pcr_review.update(migrate_detail_data)

            puts "migrated #{new_pcr_review.trans_id} review detail comment"
        end
    end

    # TODO: confirm Y is ACCEPTABLE NF-976
    def get_acceptable_value(value)
        return 'ACCEPTABLE' if value == 'Y'
        return 'NOT_ACCEPTABLE' if value == 'N'
        return value
    end

    # TODO: confirm Y is NORMAL NF-976
    def get_normal_value(value)
        return 'NORMAL' if value == 'Y'
        return 'ABNORMAL' if value == 'N'
        return value
    end

    def migration_source_data
        nios_pcr_reviews = Nios::DxpcrAuditFilm.limit(5)
    end

    # I override this method for demo purpose. In real live, please migrate transaction first
    def get_transaction(transaction_code)
        transaction = Transaction.find(1)
    end

    private


    def map_data(nios_pcr_review, new_transaction)
        migrate_data = {}

        # legacy data indicator
        nios_trans_id = nios_pcr_review.trans_id

        migrate_data[:is_legacy] = true
        migrate_data[:trans_id] = nios_trans_id
        migrate_data[:legacy_id] = nios_pcr_review.id

        # new structure data mapping
        migrate_data[:transaction_id] = new_transaction.id
        migrate_data[:status] = map_status(nios_pcr_review)
        migrate_data[:transmitted_at] = nios_pcr_review.audit_date
        migrate_data[:created_at] = nios_pcr_review.create_date
        migrate_data[:updated_at] = nios_pcr_review.modify_date

        created_by = map_created_by(nios_pcr_review)

        migrate_data[:created_by] = created_by
        migrate_data[:updated_by] = map_updated_by(nios_pcr_review)

        # creator_id is the pcr_id
        migrate_data[:pcr_id] = created_by

        poolable = map_poolable(nios_pcr_review)

        migrate_data[:poolable_type] = poolable[:poolable_type]
        migrate_data[:poolable_id] = poolable[:poolable_id]
        migrate_data[:case_type] = poolable[:case_type]

        migrate_data
    end

    # TODO: cant find result column in Nios::DxpcrAuditFilm. NF-975
    def map_result(new_pcr_review, status)
        status
    end

    def map_status(nios_pcr_review)
        status = 'PCR_REVIEW'

        if nios_pcr_review.audit_date.present?
            status = 'TRANSMITTED'
        end

        status
    end

    def map_created_by(nios_pcr_review)
        nios_user_uuid = nios_pcr_review.creator_id
        nios_user = get_nios_user(nios_user_uuid)
        new_user = get_user(nios_user.userid)
        new_user.id
    end

    def map_updated_by(nios_pcr_review)
        nios_user_uuid = nios_pcr_review.modify_id
        nios_user = get_nios_user(nios_user_uuid)
        new_user = get_user(nios_user.userid)
        new_user.id
    end

    # Create polymorphic relations with PcrPool
    def map_poolable(nios_pcr_review)
        new_xqcc_review = XrayReview.where(legacy_id: nios_pcr_review.review_film_id).first
        pcr_pool = nil

        if new_xqcc_review.present?
            pcr_pool = PcrPool.where(sourceable_type: new_xqcc_review.class.name).where(sourceable_id: new_xqcc_review.id).first
        end

        poolable_type = nil
        poolable_id = nil
        case_type = nil

        poolable = {
            :poolable_type => poolable_type,
            :poolable_id => poolable_id,
            :case_type => case_type,
        }

        if pcr_pool.present?
            poolable[:poolable_type] = pcr_pool.class.name
            poolable[:poolable_id] = pcr_pool.id
            poolable[:case_type] = pcr_pool.case_type
        end

        poolable
    end

    def already_migrate?(id)
        pcr_review = PcrReview.where(legacy_id: id).first
        return true if pcr_review.present?
        return false
    end

end