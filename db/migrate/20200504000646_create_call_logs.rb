class CreateCallLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :call_logs do |t|
      t.string :callable_type
      t.bigint :callable_id
      t.datetime :called_at
      t.string :phone
      t.string :discussant_name
      t.string :fax
      t.string :email
      t.text :comment
      t.text :issue
      t.string :status
      t.bigint :call_log_case_type_id, index: true
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
    add_index :call_logs, [:callable_id, :callable_type]
  end
end
