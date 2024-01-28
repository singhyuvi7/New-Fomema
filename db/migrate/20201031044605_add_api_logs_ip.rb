class AddApiLogsIp < ActiveRecord::Migration[6.0]
    def change
        add_column :api_logs, :ip_address, :string
    end
end
