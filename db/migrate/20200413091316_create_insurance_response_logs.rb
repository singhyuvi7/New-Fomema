class CreateInsuranceResponseLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :insurance_response_logs do |t|
      t.text :response
      t.timestamps
    end
  end
end
