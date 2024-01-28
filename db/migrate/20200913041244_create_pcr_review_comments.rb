class CreatePcrReviewComments < ActiveRecord::Migration[6.0]
    def change
        create_table :pcr_review_comments do |t|
            t.bigint :pcr_review_id, index: true
            t.bigint :condition_id, index: true
            t.text :comment
            t.timestamps
            t.bigint :created_by
            t.bigint :updated_by
        end
    end
end
