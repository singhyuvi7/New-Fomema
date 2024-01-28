class ChangeDefaultColumnForXrayExam < ActiveRecord::Migration[6.0]
    def change
        change_column_default(:xray_examinations, :xray_examination_not_done, from: "f", to: nil)
    end
end
