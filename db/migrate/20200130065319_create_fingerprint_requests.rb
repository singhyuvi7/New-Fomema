class CreateFingerprintRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :fingerprint_requests do |t|

      t.belongs_to :foreign_worker, foreign_key: true
      
      t.string :app_id
      t.string :app_transaction_id
      t.string :app_user_id
      t.string :app_reference_id
      t.string :client_device_serial
      t.string :client_mac
      t.string :client_ip
      t.string :client_computer_name
      t.datetime :request_datetime

      # request body
      t.string :surname
      t.string :given_name
      t.string :gender
      t.string :doc_no
      t.string :doc_expiry
      t.string :doc_issue_authority
      t.string :nationality
      t.string :birth_date
      t.string :application_number
      t.string :naid
      t.string :device_status

      t.text :left_thumb_img_content
      t.text :left_thumb_quality_score
      t.text :left_index_img_content
      t.text :left_index_quality_score
      t.text :left_middle_img_content
      t.text :left_middle_quality_score
      t.text :left_ring_img_content
      t.text :left_ring_quality_score
      t.text :left_little_img_content
      t.text :left_little_quality_score

      t.text :right_thumb_img_content
      t.text :right_thumb_quality_score
      t.text :right_index_img_content
      t.text :right_index_quality_score
      t.text :right_middle_img_content
      t.text :right_middle_quality_score
      t.text :right_ring_img_content
      t.text :right_ring_quality_score
      t.text :right_little_img_content
      t.text :right_little_quality_score

      t.timestamps
    end
  end
end
