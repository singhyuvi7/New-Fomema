class CreateVisitPlanRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :visit_plan_requests do |t|
      t.date :date_of_request
      t.string :is_urgent
      t.date :date_of_presentation
      t.date :date_of_visit
      t.string :satisfactory
      t.string :report_by
      t.text :insp_type_of_visit
      t.text :mspd_type_of_visit

      t.bigint :spable_id, comment: 'service providerable id'
      t.string :spable_type, comment: 'service providerable type'

      t.string :registered_person
      t.string :facility_name

      t.string :address1
      t.string :address2
      t.string :address3
      t.string :address4
      t.belongs_to :state, optional: true, index: true
      t.belongs_to :town, optional: true, index: true
      t.string :postcode

      t.string :prepared_by
      t.date :date_of_meeting

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true
    end

    add_index :visit_plan_requests, [:spable_id, :spable_type]
  end
end
