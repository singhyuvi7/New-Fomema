class AddQrridToTcupiReviews < ActiveRecord::Migration[6.0]
    def change
        add_column :tcupi_reviews, :qrrid, :integer
        add_index :tcupi_reviews, :qrrid
        add_column :transaction_tcupi_todos, :tcupi_review_id, :integer
        add_index :transaction_tcupi_todos, :tcupi_review_id
        add_column :transaction_tcupi_todos, :description_other, :text
    end
end