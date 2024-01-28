class AddColumnsToMyimmsResponses < ActiveRecord::Migration[6.0]
  def change
    add_column :myimms_responses, :status, :string, after: :myimms_request_id
  end
end
