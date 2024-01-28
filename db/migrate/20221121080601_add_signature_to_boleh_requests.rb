class AddSignatureToBolehRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :boleh_requests, :signature_type, :string
    add_column :boleh_requests, :signature, :string
  end
end
