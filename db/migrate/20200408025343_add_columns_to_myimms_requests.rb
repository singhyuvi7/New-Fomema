class AddColumnsToMyimmsRequests < ActiveRecord::Migration[6.0]
  def change
    remove_column :myimms_requests, :batch_count
    remove_column :myimms_requests, :batch_list
    remove_column :myimms_requests, :batch_code

    add_reference :myimms_requests, :myimms_transaction
    add_reference :myimms_requests, :myimm

    add_column :myimms_requests, :txn_id, :string
    add_column :myimms_requests, :doc_no, :string
    add_column :myimms_requests, :nat, :string
    add_column :myimms_requests, :dob, :string
    add_column :myimms_requests, :name, :string
    add_column :myimms_requests, :sex, :string
    add_column :myimms_requests, :med_dt, :string
    add_column :myimms_requests, :med_sts, :string
    add_column :myimms_requests, :src_ind, :string
    add_column :myimms_requests, :modify_dt, :string
    add_column :myimms_requests, :sts_ind, :string
    add_column :myimms_requests, :st_ind, :string

  end
end
