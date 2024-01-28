class CreateMyimmsResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :myimms_responses do |t|

      t.belongs_to :myimms_request
      t.text :response, limit: 16.megabytes - 1

      t.timestamps
    end
  end
end
