class CreateMvImmBlockedTransactions < ActiveRecord::Migration[6.0]
    def up
        execute "drop materialized view if exists mv_imm_blocked_transactions"

        execute "create materialized view if not exists mv_imm_blocked_transactions as
        select transactions.id, transactions.code, transactions.foreign_worker_id, transactions.employer_id, 
        transactions.transaction_date, transactions.created_at, transactions.final_result, transactions.certification_date, 
        transactions.fw_name, transactions.fw_code, transactions.fw_passport_number, 
        transactions.fw_country_id, countries.name fw_country_name, foreign_workers.employer_id worker_employer_id
        from transactions left join countries on transactions.fw_country_id = countries.id 
        left join foreign_workers on transactions.foreign_worker_id = foreign_workers.id 
        where transactions.is_imm_blocked is true"

        add_index :mv_imm_blocked_transactions, :id
        add_index :mv_imm_blocked_transactions, :code
        add_index :mv_imm_blocked_transactions, :transaction_date
    end

    def down
        execute "drop materialized view if exists mv_imm_blocked_transactions"
    end
end
