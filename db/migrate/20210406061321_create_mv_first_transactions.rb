class CreateMvFirstTransactions < ActiveRecord::Migration[6.0]
    def up
        # execute "drop materialized view if exists mv_first_transactions"

        # execute "create materialized view if not exists mv_first_transactions as
        #     select t.fw_passport_number passport_number, t.fw_date_of_birth date_of_birth,
        #     t.fw_gender gender, t.fw_country_id country_id, min(t.id) transaction_id
        #     from transactions t
        #     where t.status not in ('CANCELLED', 'REJECTED')
        #     group by t.fw_passport_number, t.fw_date_of_birth, t.fw_gender, t.fw_country_id;"

        # add_index :mv_first_transactions, :passport_number
        # add_index :mv_first_transactions, :date_of_birth
        # add_index :mv_first_transactions, :gender
        # add_index :mv_first_transactions, :country_id
        # add_index :mv_first_transactions, :transaction_id
    end

    def down
        execute "drop materialized view if exists mv_first_transactions"
    end
end