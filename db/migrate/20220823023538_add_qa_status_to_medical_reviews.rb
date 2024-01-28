class AddQaStatusToMedicalReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :medical_reviews, :qa_status, :string
  end
end
