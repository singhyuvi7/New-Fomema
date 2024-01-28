class CreateFingerprintResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :fingerprint_responses do |t|
      
      t.string :visitable_type
      t.belongs_to :fingerprint_request, optional: true
      t.belongs_to :foreign_worker, foreign_key: true
      t.string :status_code
      t.string :status_message
      t.text :description
      t.bigint :row_count

      t.string :status
      t.text :message
      t.string :fp_matching_status
      t.string :fp_biosl
      t.string :transaction_id

      t.datetime :request_datetime
      t.datetime :response_datetime

      t.timestamps
    end
  end
end
