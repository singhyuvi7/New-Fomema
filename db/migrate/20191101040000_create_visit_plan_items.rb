class CreateVisitPlanItems < ActiveRecord::Migration[5.2]
  def change
    create_table :visit_plan_items do |t|
      t.belongs_to :visit_plan
      t.belongs_to :visitable, polymorphic: true
      t.belongs_to :state
      t.belongs_to :town
      
      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end
  end
end
