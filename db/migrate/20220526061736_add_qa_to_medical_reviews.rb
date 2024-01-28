class AddQaToMedicalReviews < ActiveRecord::Migration[6.0]
  def change
    add_column :medical_reviews, :medical_mle_qa_by, :bigint
    add_column :medical_reviews, :medical_mle_qa_status, :string
    add_column :medical_reviews, :medical_mle_qa_comment, :string
    add_column :medical_reviews, :medical_mle_qa_status_at, :datetime
    add_column :medical_reviews, :is_iqa, :boolean, default: false
  end
end
