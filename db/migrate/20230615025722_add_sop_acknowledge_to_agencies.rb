class AddSopAcknowledgeToAgencies < ActiveRecord::Migration[6.0]
  def change
      add_column :agencies, :sop_acknowledge, :boolean, default: false
  end
end
