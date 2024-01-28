class PartitionTableWorker
    include Sidekiq::Worker

    def perform(*args)
        # transactions
        year = Time.now.year + 1
        [1, 7].each do |month|
            partition_name = sprintf("transactions_y%04dm%02d", year, month)
            sql = sprintf("SELECT count(*) from information_schema.tables where table_name = '#{partition_name}'", year, month)
            if ActiveRecord::Base.connection.execute(sql)[0]["count"] == 0
                date = Date.new(year, month, 1)
                # ActiveRecord::Base.connection.create_range_partition_of :transactions, name: sprintf("#{partition_name}", year, month), start_range: date.to_formatted_s("%F"), end_range: (date + 6.month).to_formatted_s("%F")
                ActiveRecord::Base.connection.execute("CREATE TABLE #{partition_name} PARTITION OF transactions (
                    constraint #{partition_name}_pkey primary key (id)
                ) FOR VALUES FROM ('#{date.to_formatted_s("%F")}') TO ('#{(date + 6.month).to_formatted_s("%F")}')")

                ActiveRecord::Base.connection.execute("create unique index #{partition_name+'_order_item_id_t_date_unique'} on #{partition_name} (order_item_id,date(transaction_date))")
            end
        end

        # audits
        year = Time.now.year + 1
        partition_name = sprintf("audits_y%04d", year)
        sql = sprintf("SELECT count(*) from information_schema.tables where table_name = '#{partition_name}'", year)
        if ActiveRecord::Base.connection.execute(sql)[0]["count"] == 0
            date = Date.new(year, 1, 1)
            # ActiveRecord::Base.connection.create_range_partition_of :audits, name: sprintf("#{partition_name}", year), start_range: date.to_formatted_s("%F"), end_range: (date + 1.year).to_formatted_s("%F")
            ActiveRecord::Base.connection.execute("CREATE TABLE #{partition_name} PARTITION OF audits FOR VALUES FROM ('#{date.to_formatted_s("%F")}') TO ('#{(date + 1.year).to_formatted_s("%F")}')")
        end
    end
end
