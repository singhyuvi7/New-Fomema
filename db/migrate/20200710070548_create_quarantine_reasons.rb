class CreateQuarantineReasons < ActiveRecord::Migration[6.0]
    def change
        create_table :quarantine_reasons do |t|
            t.string    :reason
            t.string    :code
            t.boolean   :is_active, default: :true
            t.timestamps
        end

        add_index :quarantine_reasons, :code
        add_index :quarantine_reasons, :is_active
    end
end