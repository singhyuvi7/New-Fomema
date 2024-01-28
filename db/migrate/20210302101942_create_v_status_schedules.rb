class CreateVStatusSchedules < ActiveRecord::Migration[6.0]
    def up
        execute <<-SQL
            drop view if exists v_status_schedules
        SQL
        execute <<-SQL
            create or replace view v_status_schedules as
            select id, status_scheduleable_type, status_scheduleable_id, "from" as effective_date, status, status_reason, comment, created_at, updated_at, created_by, updated_by 
            from status_schedules
            union all select id, status_scheduleable_type, status_scheduleable_id, "to" + interval '1 day' as effective_date, previous_status as status, 
            previous_status_reason as status_reason, previous_comment as comment, created_at, updated_at, created_by, updated_by 
            from status_schedules where "to" is not null
        SQL
    end

    def down
        execute <<-SQL
            drop view if exists v_status_schedules
        SQL
    end
end
