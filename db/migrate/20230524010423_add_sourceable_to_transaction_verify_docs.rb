class AddSourceableToTransactionVerifyDocs < ActiveRecord::Migration[6.0]
  def change
    add_reference :transaction_verify_docs, :sourceable, polymorphic: true, index: {name: 'index_tvd_sourceable'}
  end
end