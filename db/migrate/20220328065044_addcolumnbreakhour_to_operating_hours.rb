class AddcolumnbreakhourToOperatingHours < ActiveRecord::Migration[6.0]
  def change
    add_column :operating_hours, :monday_break_start, :time
    add_column :operating_hours, :monday_break_end, :time
    add_column :operating_hours, :tuesday_break_start, :time
    add_column :operating_hours, :tuesday_break_end, :time
    add_column :operating_hours, :wednesday_break_start, :time
    add_column :operating_hours, :wednesday_break_end, :time
    add_column :operating_hours, :thursday_break_start, :time
    add_column :operating_hours, :thursday_break_end, :time
    add_column :operating_hours, :friday_break_start, :time
    add_column :operating_hours, :friday_break_end, :time
    add_column :operating_hours, :saturday_break_start, :time
    add_column :operating_hours, :saturday_break_end, :time
    add_column :operating_hours, :sunday_break_start, :time
    add_column :operating_hours, :sunday_break_end, :time
    add_column :operating_hours, :public_holiday_break_start, :time
    add_column :operating_hours, :public_holiday_break_end, :time
  end
end