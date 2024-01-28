class AddDateRetrievalErrorToXrayExaminations < ActiveRecord::Migration[6.0]
    def change
        add_column :xray_examinations, :xray_api_error , :string
    end
end