class CreateErrorLoggers < ActiveRecord::Migration[6.0]
    def change
        create_table :error_loggers do |t|
            t.string    :event_type
            t.bigint    :user_id
            t.string    :user_code
            t.string    :user_email
            t.string    :user_name
            t.json      :parameters
            t.boolean   :notice_sent, default: false
            t.timestamps
        end

        add_index :error_loggers, :event_type
        add_index :error_loggers, :notice_sent
        add_index :error_loggers, :created_at
    end
end