class RenameChangeDoctorReasons < ActiveRecord::Migration[6.0]
  def change
    rename_table :change_doctor_reasons, :change_sp_reasons
  end
end
