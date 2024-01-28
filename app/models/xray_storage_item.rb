class XrayStorageItem < ApplicationRecord
  belongs_to :xray_storage
  belongs_to :transactionz, foreign_key: "transaction_id", class_name: "Transaction"
end
