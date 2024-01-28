class CreateBiometricLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :biometric_logs do |t|

      t.belongs_to :transaction, index: true
      t.json :params
      t.text :response
      t.text :remarks

      t.timestamps
    end
  end
end
