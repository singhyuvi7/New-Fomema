class AddEmployerConsentedToAppeals < ActiveRecord::Migration[6.0]
  def change
    add_column :medical_appeals, :employer_consented_at, :datetime
    add_index :medical_appeals, :employer_consented_at
  end
end
