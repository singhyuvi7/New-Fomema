class AddConcurCommentToTransactionAmendments < ActiveRecord::Migration[6.0]
    def change
        add_column :transaction_amendments, :approval_comment, :text
        add_column :transaction_amendments, :wrong_transmission_doctor, :boolean
        add_column :transaction_amendments, :wrong_transmission_lab, :boolean
        add_column :transaction_amendments, :wrong_transmission_xray, :boolean
        add_index :transaction_amendments, :wrong_transmission_doctor
        add_index :transaction_amendments, :wrong_transmission_lab
        add_index :transaction_amendments, :wrong_transmission_xray
    end
end