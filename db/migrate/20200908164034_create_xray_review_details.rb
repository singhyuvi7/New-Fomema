class CreateXrayReviewDetails < ActiveRecord::Migration[6.0]
    def change
        create_table :xray_review_details do |t|
            t.bigint :xray_review_id, index: true
            t.bigint :condition_id, index: true
            t.string :text_value
            t.timestamps
            t.bigint :created_by
            t.bigint :updated_by
        end

        execute "create or replace view v_xray_review_details as 
        select xrd.id, xrd.xray_review_id, xrd.condition_id, c.code as condition_code, c.description as condition_description, 
        xrd.text_value, xrd.created_at, xrd.updated_at, xrd.created_by, xrd.updated_by
        from xray_review_details xrd left join conditions c on xrd.condition_id = c.id"
    end
end
