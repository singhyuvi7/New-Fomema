namespace :nios_migrate do

  desc "Transaction"
  task transaction: :environment do

  end

  # Dependencies:
  # 1. Transaction
  desc "Migrate Pending Review"
  task pending_review: :environment do
    pending_review_migrator = XqccPendingReviewMigrator.new
    pending_review_migrator.migrate
  end

  # Dependencies:
  # 1. Transaction
  # 2. Pending Review
  desc "Migrate XQCC Pool"
  task xqcc_pool: :environment do
    xqcc_pool_migrator = XqccPoolMigrator.new
    xqcc_pool_migrator.migrate
  end

  # Dependencies:
  # 1. Transaction
  # 2. User
  # 3. XQCC Pool
  desc "Migrate XQCC Review"
  task xqcc_review: :environment do
    xqcc_review_migrator = XqccReviewMigrator.new
    xqcc_review_migrator.migrate
  end

  desc "TODO"
  task xqcc_retake: :environment do

  end

  # Dependencies:
  # 1. Transaction
  # 2. User
  # 3. Pending Review
  # 4. XQCC Pool
  # 5. XQCC Review
  desc "Migrate PCR Pool"
  task pcr_pool: :environment do
    pcr_pool_migrator = PcrPoolMigrator.new
    pcr_pool_migrator.migrate
  end

  desc "Migrate PCR Review"
  task pcr_review: :environment do
    pcr_review_migrator = PcrReviewMigrator.new
    pcr_review_migrator.migrate
  end

  desc "TODO"
  task pcr_retake: :environment do

  end

  desc "TODO"
  task pending_decision: :environment do

  end

  desc "TODO"
  task pending_decision_approval: :environment do

  end

  desc "TODO"
  task xqcc_movement: :environment do

  end

end
