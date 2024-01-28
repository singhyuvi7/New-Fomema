class CreateFwVerificationCriterions < ActiveRecord::Migration[6.0]
  def change
    create_table :fw_verification_criterions do |t|
            t.string    :code
            t.string    :name
            t.string    :status
            t.timestamps
            t.bigint    :created_by
            t.bigint    :updated_by
    end
  end
end
