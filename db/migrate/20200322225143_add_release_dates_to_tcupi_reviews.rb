class AddReleaseDatesToTcupiReviews < ActiveRecord::Migration[6.0]
    def change
        add_column :tcupi_reviews, :medical_mle1_decision_at, :datetime
        add_column :tcupi_reviews, :medical_mle2_decision_at, :datetime
        add_index  :tcupi_reviews, :medical_mle1_decision_at
        add_index  :tcupi_reviews, :medical_mle2_decision_at
    end
end