class AddDigitalXrayAvailableToXrayExaminations < ActiveRecord::Migration[6.0]
    def change
        add_column :xray_examinations, :digital_xray_available, :boolean
    end
end