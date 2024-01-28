class CreateCallLogCaseTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :call_log_case_types do |t|
      t.string :code, index: true
      t.string :description
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
