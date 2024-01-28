class CreateLqccLetters < ActiveRecord::Migration[6.0]
  def change
    create_table :lqcc_letters do |t|
      t.belongs_to :visit_report

      t.string :explanation_type
      t.time :visit_time
      t.date :reply_date

      t.string :operation_type

      t.string :explanation_status, index: true

      t.bigint :explanation_request_by
      t.datetime :explanation_request_at
      t.string :explanation_approval_decision
      t.text :explanation_approval_comment
      t.bigint :explanation_approval_by
      t.datetime :explanation_approval_at

      t.string :warning_status, index: true

      t.bigint :warning_request_by
      t.datetime :warning_request_at
      t.string :warning_approval_decision
      t.text :warning_approval_comment
      t.bigint :warning_approval_by
      t.datetime :warning_approval_at

      t.string :explanation_signature_name
      t.string :explanation_signature_designation
      t.text :explanation_signature

      t.string :warning_signature_name
      t.string :warning_signature_designation
      t.text :warning_signature

      t.text :explanation_non_compliances
      t.text :explanation_clauses
      t.text :warning_clauses

      t.string :laboratory_pic_name

      t.datetime :explanation_letter_date
      t.datetime :warning_letter_date

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
