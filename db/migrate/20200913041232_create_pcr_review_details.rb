class CreatePcrReviewDetails < ActiveRecord::Migration[6.0]
    def change
        create_table :pcr_review_details do |t|
            t.bigint :pcr_review_id, index: true
            t.bigint :condition_id, index: true
            t.string :text_value
            t.timestamps
            t.bigint :created_by
            t.bigint :updated_by
        end

        execute "create or replace view v_pcr_review_details as 
        select prd.id, prd.pcr_review_id, prd.condition_id, c.code as condition_code, c.description as condition_description, 
        prd.text_value, prd.created_at, prd.updated_at, prd.created_by, prd.updated_by
        from pcr_review_details prd left join conditions c on prd.condition_id = c.id"
    end
end
