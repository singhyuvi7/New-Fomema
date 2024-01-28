class CreateForeignWorkers < ActiveRecord::Migration[5.2]
  def change
    create_table :foreign_workers do |t|
      t.string :code, index: true
      t.string :name, index: true
      t.string :passport_number, index: true
      t.string :gender, index: true
      t.datetime :gender_amended_at
      t.date :date_of_birth
      t.belongs_to :employer, index: true
      t.belongs_to :employer_supplement, optional: true
      t.belongs_to :country
      t.belongs_to :job_type
      t.date :arrival_date
      t.string :plks_number
      t.boolean :pati, default: false

      t.belongs_to :amendment_reason
      t.text :amendment_reason_comment
      t.datetime :employer_amended_at
      t.datetime :amended_at
      t.bigint :amended_by, index: true
      t.boolean :blocked, default: false
      t.belongs_to :block_reason
      t.text :block_comment
      t.bigint :unblock_reason_id, index: true
      t.text :unblock_comment
      t.datetime :blocked_at
      t.bigint :blocked_by, index: true

      t.string :afis_id
      
      t.string :approval_status, index: true
      t.string :approval_remark

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
