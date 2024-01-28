class AddDefaultValueToIgnoreExpiry < ActiveRecord::Migration[6.0]
    def up
        change_column_default :transactions, :ignore_expiry, false
    end

    def down
        change_column_default :transactions, :ignore_expiry, nil
    end
end