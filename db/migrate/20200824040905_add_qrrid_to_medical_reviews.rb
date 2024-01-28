class AddQrridToMedicalReviews < ActiveRecord::Migration[6.0]
    def change
        add_column :medical_reviews, :qrrid, :integer
        add_index :medical_reviews, :qrrid
        add_column :transaction_tcupi_todos, :medical_review_id, :integer
        add_index :transaction_tcupi_todos, :medical_review_id
    end
end