class CreateVisitReports < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_reports do |t|
      t.string :code
      t.belongs_to :visit_plan
      t.belongs_to :visit_plan_item
      t.belongs_to :visitable, polymorphic: true

      t.date :visit_date
      t.time :visit_time_from
      t.time :visit_time_to
      t.string :visit_category

      t.text :comment
      t.text :follow_up

      t.bigint :prepare_by
      t.datetime :prepare_at

      t.string :status, index: true

      t.string :level_1_approval_decision
      t.text :level_1_approval_comment
      t.bigint :level_1_approval_by
      t.datetime :level_1_approval_at

      t.string :level_2_approval_decision
      t.text :level_2_approval_comment
      t.bigint :level_2_approval_by
      t.datetime :level_2_approval_at

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
