class CreateSequenceForMedicalPrQa < ActiveRecord::Migration[6.0]
  def change
    create_table :sequence_for_medical_pr_qas do |t|
       sql = "create sequence medical_pr_qa_seq
            increment 1
            minvalue 1
            maxvalue 999999999999
            cycle
            start with 1"
            execute sql
    end
  end
end
