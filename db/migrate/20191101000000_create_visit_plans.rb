class CreateVisitPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_plans do |t|
      t.string :code
      t.string :visitable_type, index: true
      t.date :inspect_from, index: true
      t.date :inspect_to, index: true
      t.string :status, index: true
      t.text :comment

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
