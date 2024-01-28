class CreateConditions < ActiveRecord::Migration[6.0]
    def change
        create_table :conditions do |t|
            t.string    :code
            t.text      :description
            t.string    :exam_type
            t.string    :field_type
            t.string    :category
            t.timestamps
            t.bigint    :created_by
            t.bigint    :updated_by
            t.datetime  :deleted_at
        end

        add_index :conditions, :code
        add_index :conditions, :exam_type
        add_index :conditions, :field_type
        add_index :conditions, :category
        add_index :conditions, :deleted_at
    end
end