class CreateBiodataRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :biodata_requests do |t|
      t.belongs_to :foreign_worker, foreign_key: true

      t.string :app_transaction_id
      t.string :app_user_id
      t.string :reference_id
      t.string :client_mac
      t.string :client_ip
      t.string :client_computer_name
      t.datetime :request_datetime

      # request body
      t.string :gender
      t.string :passport_no
      t.string :nationality
      t.string :date_of_birth

      t.timestamps
    end
  end
end
