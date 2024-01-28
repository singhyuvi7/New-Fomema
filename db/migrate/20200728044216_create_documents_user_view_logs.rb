class CreateDocumentsUserViewLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :documents_user_view_logs do |t|
      t.belongs_to :upload, index: true
      t.bigint :document_id, index: true
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
