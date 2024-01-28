class AddResponsableToFingerprintResponses < ActiveRecord::Migration[6.0]
  def change
    add_column :fingerprint_responses, :responsable_type, :string, index: true
    add_column :fingerprint_responses, :responsable_id, :bigint, index: true
  end
end
