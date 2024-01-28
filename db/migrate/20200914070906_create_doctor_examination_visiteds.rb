class CreateDoctorExaminationVisiteds < ActiveRecord::Migration[6.0]
    def change
        create_table :doctor_examination_visiteds do |t|
            t.bigint    :doctor_examination_id
            t.boolean   :visited_history_1
            t.boolean   :visited_history_2
            t.boolean   :visited_physical
            t.boolean   :visited_system_1
            t.boolean   :visited_system_2
            t.boolean   :visited_laboratory_result
            t.boolean   :visited_xray_facility_result
            t.boolean   :visited_condition
            t.boolean   :visited_certification
            t.boolean   :visited_follow_up
            t.timestamps
            t.bigint    :created_by
            t.bigint    :updated_by
            t.datetime  :deleted_at
        end

        add_index :doctor_examination_visiteds, :doctor_examination_id
        add_index :doctor_examination_visiteds, :deleted_at
    end
end