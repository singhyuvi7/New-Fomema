class AddTransactionsFwInfo < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :fw_code, :string, index: true
    add_column :transactions, :fw_name, :string, index: true
    add_column :transactions, :fw_gender, :string
    add_column :transactions, :fw_date_of_birth, :date
    add_column :transactions, :fw_passport_number, :string, index: true
    add_column :transactions, :fw_country_id, :bigint
    add_column :transactions, :fw_maid_online, :string
    add_column :transactions, :fw_plks_number, :string
  end
end

=begin
do $$
declare
rec record;
begin
for rec in (select * from foreign_workers where length(code) > 0) loop
	update transactions set fw_code = rec.code, fw_name = rec.name,
	fw_gender = rec.gender, fw_date_of_birth = rec.date_of_birth,
	fw_passport_number = rec.passport_number, fw_country_id = rec.country_id,
	fw_maid_online = rec.maid_online, fw_plks_number = rec.plks_number
	where foreign_worker_id = rec.id;
end loop;
end;
$$;
end
=end