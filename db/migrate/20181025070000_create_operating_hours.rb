class CreateOperatingHours < ActiveRecord::Migration[5.2]
  def change
    create_table :operating_hours do |t|
      t.references :operating_hourable, polymorphic: true, index: {name: "index_operating_hours_on_operating_hourable"}
      
      t.boolean :monday_is_close, default: false
      t.boolean :monday_is_24_hour, default: false
      t.time :monday_start
      t.time :monday_end
      t.string :monday_break
      
      t.boolean :tuesday_is_close, default: false
      t.boolean :tuesday_is_24_hour, default: false
      t.time :tuesday_start
      t.time :tuesday_end
      t.string :tuesday_break
      
      t.boolean :wednesday_is_close, default: false
      t.boolean :wednesday_is_24_hour, default: false
      t.time :wednesday_start
      t.time :wednesday_end
      t.string :wednesday_break
      
      t.boolean :thursday_is_close, default: false
      t.boolean :thursday_is_24_hour, default: false
      t.time :thursday_start
      t.time :thursday_end
      t.string :thursday_break
      
      t.boolean :friday_is_close, default: false
      t.boolean :friday_is_24_hour, default: false
      t.time :friday_start
      t.time :friday_end
      t.string :friday_break
      
      t.boolean :saturday_is_close, default: false
      t.boolean :saturday_is_24_hour, default: false
      t.time :saturday_start
      t.time :saturday_end
      t.string :saturday_break
      
      t.boolean :sunday_is_close, default: false
      t.boolean :sunday_is_24_hour, default: false
      t.time :sunday_start
      t.time :sunday_end
      t.string :sunday_break
      
      t.boolean :public_holiday_is_close, default: false
      t.boolean :public_holiday_is_24_hour, default: false
      t.time :public_holiday_start
      t.time :public_holiday_end
      t.string :public_holiday_break

      t.text :close_remark

      t.timestamps
      t.bigint :created_by, index: true
      t.bigint :updated_by, index: true

    end
  end
end
