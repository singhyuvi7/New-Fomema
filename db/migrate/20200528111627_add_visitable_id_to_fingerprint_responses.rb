class AddVisitableIdToFingerprintResponses < ActiveRecord::Migration[6.0]
  def change
    add_column :fingerprint_responses, :visitable_id, :bigint
  end
end
