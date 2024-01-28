class AddAddtionalInformationToTransactionVerifyDocs < ActiveRecord::Migration[6.0]
  def change
    add_column :transaction_verify_docs, :additional_information, :json
    add_column :transaction_verify_docs, :assigned_to, :bigint
  end
end
