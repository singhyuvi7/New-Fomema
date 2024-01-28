class AddAgreementAcceptedToAgencies < ActiveRecord::Migration[6.0]
  def change
    add_column :agencies, :agreement_accepted, :boolean, default: false
  end
end
