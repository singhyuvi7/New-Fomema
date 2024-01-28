class XqccPoolMigrator < NiosBaseMigrator

  def migrate

    nios_xqcc_pools = migration_source_data

    # TODO: Replace loop with find_each for real migration
    # https://api.rubyonrails.org/classes/ActiveRecord/Batches.html#method-i-find_each

    nios_xqcc_pools.each do |nios_xqcc_pool|

      transaction_code = nios_xqcc_pool.trans_id

      new_transaction = get_transaction(transaction_code)

      if new_transaction.present?

        if already_migrate?(nios_xqcc_pool.id)

          puts "#{transaction_code} already migrated previously. SKIPPED"

        else

          xqcc_pool_data = map_data(nios_xqcc_pool, new_transaction)

          new_xqcc_pool = XqccPool.create(xqcc_pool_data)

          puts "migrated #{transaction_code} into ID: #{new_xqcc_pool.id}"

        end

      else
        puts "#{transaction_code} not exist, please migrate this transaction first"
      end

    end

    puts "Pending Review migration completed"
  end

  def migration_source_data

    # MERTS origin (Eg: Xray normal)
    # nios_xqcc_pools = Nios::Dxbasket.where(source_ref: 1).limit(5)

    # PENDING REVIEW origin (Eg: Pending Review decision Radiographer Review)
    # nios_xqcc_pools = Nios::Dxbasket.where(source_ref: 2).limit(5)

    nios_xqcc_pools = Nios::Dxbasket.limit(5)
  end

  # I override this method for demo purpose. In real live, please migrate transaction first
  def get_transaction(transaction_code)
    transaction = Transaction.find(1)
  end

  private


  def map_data(nios_xqcc_pool, new_transaction)

    migrate_data = {}

    # legacy data indicator

    nios_trans_id = nios_xqcc_pool.trans_id

    migrate_data[:is_legacy] = true
    migrate_data[:trans_id] = nios_trans_id
    migrate_data[:legacy_id] = nios_xqcc_pool.id

    # new structure data mapping

    migrate_data[:transaction_id] = new_transaction.id


    migrate_data[:created_at] = nios_xqcc_pool.submit_date
    migrate_data[:updated_at] = nios_xqcc_pool.submit_date
    migrate_data[:picked_up_at] = nios_xqcc_pool.pickup_date

    source = map_source(nios_xqcc_pool)

    migrate_data[:source] = source
    migrate_data[:status] = map_status(nios_xqcc_pool)
    migrate_data[:case_type] = map_case_type(source)

    if source == 'PENDING_REVIEW'

      sourceable = map_sourceable(nios_trans_id)

      migrate_data[:sourceable_type] = sourceable[:sourceable_type]
      migrate_data[:sourceable_id] = sourceable[:sourceable_id]

    end

    migrate_data

  end

  def map_status(nios_xqcc_pool)

    status = nil

    case nios_xqcc_pool.status

    when "NORMAL"
      status = 'XQCC_POOL'
    when "ASSIGN"
      status = 'ASSIGN'
    when "CHECK"

    end

    status

  end

  def map_source(nios_xqcc_pool)

    source = nil

    case nios_xqcc_pool.source_ref.to_s

    when "1"
      source = 'MERTS'
    when "2"
      source = 'PENDING_REVIEW'
    else
      # not sure if source null
    end

    source

  end

  def map_case_type(source)

    case_type = nil

    case source

    when "MERTS"
      case_type = 'XRAY_EXAMINATION_NORMAL'
    when "PENDING_REVIEW"
      case_type = 'XQCC_PENDING_REVIEW_XQCC_POOL'
    else

    end

    case_type

  end

  # for PENDING_REVIEW source only. Create polymorphic relations with PENDING_REVIEW
  def map_sourceable(trans_id)

    xray_pending_review = XrayPendingReview.where(trans_id: trans_id).first

    sourceable_type = nil
    sourceable_id = nil

    sourceable = {
        :sourceable_type => sourceable_type,
        :sourceable_id => sourceable_id,
    }

    if xray_pending_review.present?
      sourceable[:sourceable_type] = xray_pending_review.class.name
      sourceable[:sourceable_id] = xray_pending_review.id
    end

    sourceable

  end

  def already_migrate?(id)
    xqcc_pool = XqccPool.where(legacy_id: id).first

    return true if xqcc_pool.present?

    return false
  end

end