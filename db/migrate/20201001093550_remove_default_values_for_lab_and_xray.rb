class RemoveDefaultValuesForLabAndXray < ActiveRecord::Migration[6.0]
    def change
        change_column_default(:laboratory_examinations, :laboratory_test_not_done, nil)
    end
end