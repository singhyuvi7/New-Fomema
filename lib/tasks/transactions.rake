# frozen_string_literal: true

namespace :transactions do
  desc 'Update registration type (new or renewal) for existing records'
  task update_registration_type: :environment do
    Transaction.find_each do |transaction|
      if transaction.check_renewal_registration?(count: 1) && (transaction.foreign_worker.transactions.order(:created_at).first.id != transaction.id)
        transaction.registration_type_renewal!
      else
        transaction.registration_type_new!
      end
    end
  end
end
