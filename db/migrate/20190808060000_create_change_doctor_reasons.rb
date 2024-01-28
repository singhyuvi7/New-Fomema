class CreateChangeDoctorReasons < ActiveRecord::Migration[5.2]
  def change
    create_table :change_doctor_reasons do |t|
      t.string :code, index: true
      t.string :description
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
