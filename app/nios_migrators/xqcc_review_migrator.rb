class XqccReviewMigrator < NiosBaseMigrator


  def migrate

    nios_xqcc_reviews = migration_source_data

    # TODO: Replace loop with find_each for real migration
    # https://api.rubyonrails.org/classes/ActiveRecord/Batches.html#method-i-find_each

    nios_xqcc_reviews.each do |nios_xqcc_review|

      transaction_code = nios_xqcc_review.trans_id

      new_transaction = get_transaction(transaction_code)

      if new_transaction.present?

        if already_migrate?(nios_xqcc_review.id)

          puts "#{transaction_code} already migrated previously. SKIPPED"

        else

          xqcc_review_data = map_data(nios_xqcc_review, new_transaction)

          new_xqcc_review = XrayReview.create(xqcc_review_data)

          puts "migrated #{transaction_code} into ID: #{new_xqcc_review.id}"

          # migrate xqcc review details
          migrate_xqcc_review_details(nios_xqcc_review, new_xqcc_review)

          # migrate xqcc review identicals
          migrate_xqcc_review_identicals(nios_xqcc_review, new_xqcc_review)

          # migrate xqcc review comments

          migrate_xqcc_review_comments(nios_xqcc_review, new_xqcc_review)

        end

      else
        puts "#{transaction_code} not exist, please migrate this transaction first"
      end

    end

    puts "XQCC Review migration completed"
  end

  def migrate_xqcc_review_details(nios_xqcc_review, new_xqcc_review)
    nios_xqcc_review_details = Nios::DxreviewFilmDetail.where(dxry_id: nios_xqcc_review.id)

    migrate_detail_data = {}

    unless nios_xqcc_review_details.nil?
      nios_xqcc_review_details.each do |nios_xqcc_review_detail|

        parameter_value = nios_xqcc_review_detail.parameter_value

        case nios_xqcc_review_detail.parameter_code.to_s

        when "6101"
          migrate_detail_data[:is_id_incomplete] = get_parameter_value(parameter_value)

        when "6109"
          migrate_detail_data[:is_pos_scapular_not_retracted] = get_parameter_value(parameter_value)

        when "6110"
          migrate_detail_data[:pos_apices_cut] = get_parameter_value(parameter_value)

        when "6111"
          migrate_detail_data[:pos_chest_wall_cut] = get_parameter_value(parameter_value)

        when "6112"
          migrate_detail_data[:pos_cpa_cut] = get_parameter_value(parameter_value)

        when "6113"
          migrate_detail_data[:pos_id_obscure_apex] = get_parameter_value(parameter_value)

        when "6115"
          migrate_detail_data[:pos_poor_colimation] = get_parameter_value(parameter_value)

        when "6116"
          migrate_detail_data[:pos_marker_obscure_apex] = get_parameter_value(parameter_value)

        when "6117"
          migrate_detail_data[:is_exp_overexposure] = get_parameter_value(parameter_value)

        when "6118"
          migrate_detail_data[:is_exp_underexposure] = get_parameter_value(parameter_value)

        when "6119"
          migrate_detail_data[:is_arti_processing_artifacts] = get_parameter_value(parameter_value)
          # old system dont have is_arti_poor_handling_artifacts
          migrate_detail_data[:is_arti_poor_handling_artifacts] = get_parameter_value(parameter_value)

        when "6120"
          migrate_detail_data[:is_pos_poor_inspiratory_effort] = get_parameter_value(parameter_value)

        when "6121"
          migrate_detail_data[:is_blur_movement] = get_parameter_value(parameter_value)
          # old system dont have is_blur_breathing
          migrate_detail_data[:is_blur_breathing] = get_parameter_value(parameter_value)

        when "6124"
          migrate_detail_data[:is_envelope_problem] = get_parameter_value(parameter_value)

        when "6127"
          migrate_detail_data[:is_id_not_available] = get_parameter_value(parameter_value)

        when "6128"
          migrate_detail_data[:is_id_wrong] = get_parameter_value(parameter_value)

        when "6129"
          migrate_detail_data[:is_improper_marking] = get_parameter_value(parameter_value)

        when "6130"
          migrate_detail_data[:is_improper_report] = get_parameter_value(parameter_value)

        end


      end

      new_xqcc_review.update(migrate_detail_data)

      puts "migrated #{new_xqcc_review.trans_id} review detail"
    end

  end

  # dependent on other xqcc reviews
  def migrate_xqcc_review_identicals(nios_xqcc_review, new_xqcc_review)

    nios_xqcc_review_id = nios_xqcc_review.id
    # hard code for testing
    # nios_xqcc_review_id = 1473208

    nios_xqcc_review_identicals = Nios::DxreviewFilmIdentical.where(dxry_id: nios_xqcc_review_id)

    unless nios_xqcc_review_identicals.nil?
      nios_xqcc_review_identicals.each do |nios_xqcc_review_identical|

        indentical_data = {}

        indentical_data[:is_legacy] = true
        indentical_data[:trans_id] = nios_xqcc_review_identical.trans_id
        indentical_data[:created_at] = new_xqcc_review.created_at
        indentical_data[:updated_at] = new_xqcc_review.updated_at

        indentical_data[:legacy_id] = nios_xqcc_review_identical.id

        indentical_data[:xray_review_id] = new_xqcc_review.id

        identical_xray_review = XrayReview.where(trans_id: nios_xqcc_review_identical.trans_id).first

        indentical_data[:identical_xray_review_id] = identical_xray_review.id

        new_xqcc_review_identical = XqccReviewIdentical.create(indentical_data)

        puts "migrated id: #{identical_xray_review.id} review identical"
      end
    end

  end

  def migrate_xqcc_review_comments(nios_xqcc_review, new_xqcc_review)

    nios_xqcc_review_id = nios_xqcc_review.id
    # hard code ID for testing
    # nios_xqcc_review_id = 324

    nios_xqcc_review_comments = Nios::DxreviewFilmComment.where(dxry_id: nios_xqcc_review_id)

    unless nios_xqcc_review_comments.nil?
      nios_xqcc_review_comments.each do |nios_xqcc_review_comment|

        comment_data = {}

        comment_data[:is_legacy] = true
        comment_data[:legacy_id] = nios_xqcc_review_comment.id
        comment_data[:created_at] = nios_xqcc_review_comment.create_date
        comment_data[:updated_at] = nios_xqcc_review_comment.modify_date

        comment_data[:created_by] = map_comment_created_by(nios_xqcc_review_comment)
        comment_data[:updated_by] = map_comment_updated_by(nios_xqcc_review_comment)

        comment_data[:comment] = nios_xqcc_review_comment.comments

        comment_data[:commentable_type] = new_xqcc_review.class.name
        comment_data[:commentable_id] = new_xqcc_review.id

        new_xqcc_comment = XqccComment.create(comment_data)

        puts "migrated id: #{nios_xqcc_review_comment.id} review comment"

      end
    end

  end

  def migration_source_data
    nios_xqcc_reviews = Nios::DxreviewFilm.limit(5)
  end

  # I override this method for demo purpose. In real live, please migrate transaction first
  def get_transaction(transaction_code)
    transaction = Transaction.find(1)
  end

  private


  def map_data(nios_xqcc_review, new_transaction)

    migrate_data = {}

    # legacy data indicator

    nios_trans_id = nios_xqcc_review.trans_id

    migrate_data[:is_legacy] = true
    migrate_data[:trans_id] = nios_trans_id
    migrate_data[:legacy_id] = nios_xqcc_review.id

    # new structure data mapping

    migrate_data[:transaction_id] = new_transaction.id

    migrate_data[:batch_id] = nios_xqcc_review.batch_id

    migrate_data[:result] = map_result(nios_xqcc_review)
    migrate_data[:status] = map_status(nios_xqcc_review)

    migrate_data[:transmitted_at] = nios_xqcc_review.review_date
    migrate_data[:created_at] = nios_xqcc_review.create_date
    migrate_data[:updated_at] = nios_xqcc_review.modify_date

    migrate_data[:created_by] = map_created_by(nios_xqcc_review)
    migrate_data[:updated_by] = map_updated_by(nios_xqcc_review)

    migrate_data[:radiographer_id] = map_radiographer_id(nios_xqcc_review)

    poolable = map_poolable(nios_trans_id)

    migrate_data[:poolable_type] = poolable[:poolable_type]
    migrate_data[:poolable_id] = poolable[:poolable_id]
    migrate_data[:case_type] = poolable[:case_type]

    migrate_data

  end

  def map_result(nios_xqcc_review)

    status = nil

    # MISMATCH and OTHERS is not use in new system
    # New system has new status RETAKE

    case nios_xqcc_review.status

    when "NORMAL"
      status = 'NORMAL'
    when "SUSPICIOUS"
      status = 'SUSPICIOUS'
    when "IDENTICAL"
      status = 'IDENTICAL'
    when "WRONG"
      status = 'WRONG_TRANSMISSION'
    when "MISMATCH"
      status = 'MISMATCH'
    when "OTHERS"
      status = 'OTHERS'
    end

    status

  end

  def map_status(nios_xqcc_review)

    status = 'XQCC_REVIEW'

    if nios_xqcc_review.review_date.present?
      status = 'TRANSMITTED'
    end

    status

  end

  def map_created_by(nios_xqcc_review)

    nios_user_uuid = nios_xqcc_review.creator_id

    nios_user = get_nios_user(nios_user_uuid)

    new_user = get_user(nios_user.userid)

    new_user.id

  end

  def map_updated_by(nios_xqcc_review)

    nios_user_uuid = nios_xqcc_review.modify_id

    nios_user = get_nios_user(nios_user_uuid)

    new_user = get_user(nios_user.userid)

    new_user.id

  end

  def map_radiographer_id(nios_xqcc_review)

    nios_user_uuid = nios_xqcc_review.radiographer_id

    nios_user = get_nios_user(nios_user_uuid)

    new_user = get_user(nios_user.userid)

    new_user.id

  end

  # Create polymorphic relations with XqccPool
  def map_poolable(trans_id)

    xqcc_pool = XqccPool.where(trans_id: trans_id).first

    poolable_type = nil
    poolable_id = nil
    case_type = nil

    poolable = {
        :poolable_type => poolable_type,
        :poolable_id => poolable_id,
        :case_type => case_type,
    }

    if xqcc_pool.present?
      poolable[:poolable_type] = xqcc_pool.class.name
      poolable[:poolable_id] = xqcc_pool.id
      poolable[:case_type] = xqcc_pool.case_type
    end

    poolable

  end

  def map_comment_created_by(nios_xqcc_comment)

    nios_user_uuid = nios_xqcc_comment.creator_id

    nios_user = get_nios_user(nios_user_uuid)

    new_user = get_user(nios_user.userid)

    new_user.id

  end

  def map_comment_updated_by(nios_xqcc_comment)

    nios_user_uuid = nios_xqcc_comment.modify_id

    nios_user = get_nios_user(nios_user_uuid)

    new_user = get_user(nios_user.userid)

    new_user.id

  end

  def already_migrate?(id)
    xqcc_review = XrayReview.where(legacy_id: id).first

    return true if xqcc_review.present?

    return false
  end

end