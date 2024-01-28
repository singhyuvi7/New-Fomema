class AddPhysicalExamNotDoneToTransactions < ActiveRecord::Migration[6.0]
    def change
        add_column :transactions, :physical_exam_not_done,  :boolean,   index: true
        add_column :transactions, :not_done_officer_id,     :integer,   index: true
        add_column :transactions, :not_done_set_at,         :datetime,  index: true
        add_column :transactions, :tcupi_date,         		:datetime,  index: true
    end
end