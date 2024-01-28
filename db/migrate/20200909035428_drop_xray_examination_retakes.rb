class DropXrayExaminationRetakes < ActiveRecord::Migration[6.0]
    def change
        drop_table :xray_examination_retakes
    end
end