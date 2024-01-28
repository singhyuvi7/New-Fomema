class CreateBiodataResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :biodata_responses do |t|
      t.belongs_to :biodata_request, optional: true
      t.belongs_to :foreign_worker, foreign_key: true
      t.string :status_code
      t.string :status_message
      t.text :description
      t.bigint :row_count

      t.string :passport_number
      t.string :nationality
      t.string :date_of_birth
      t.string :gender
      t.string :worker_name
      t.string :document_expiry_date
      t.string :document_issue_authority
      t.string :application_number
      t.string :afis_id
      t.string :ners_reason_code
      t.string :date_of_arrival
      t.string :employer_name
      t.string :employer_id
      t.string :employer_type
      t.string :employer_address_1
      t.string :employer_address_2
      t.string :employer_address_3
      t.string :employer_address_4
      t.string :employer_postcode
      t.string :employer_city
      t.string :employer_state
      t.string :employer_email
      t.string :employer_phone_number
      t.string :ners_status
      t.text :ners_message
      t.string :fp_availability_status
      t.string :fp_bio_sl
      t.string :fp_avail
      t.string :transaction_id
      t.bigint :renewal_count_years
      t.string :pra_create_id

      t.datetime :request_datetime
      t.datetime :response_datetime

      t.timestamps
    end
  end
end
