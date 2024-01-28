class CreateUnsuitableReasons < ActiveRecord::Migration[6.0]
    def change
        create_table :unsuitable_reasons do |t|
            t.string    :reason_en
            t.string    :reason_bm
            t.integer   :priority
            t.timestamps
        end

        add_index :unsuitable_reasons, :priority
    end
end