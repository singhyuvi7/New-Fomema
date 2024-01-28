-- need to complete migrate/all.sql first

/*
select 'drop table if exists public.' || tablename || ';' from pg_tables where schemaname = 'public';
SELECT 'drop sequence if exists ' || c.relname || ';' FROM pg_class c WHERE (c.relkind = 'S');

select pg_size_pretty(sum(pg_total_relation_size(quote_ident(schemaname) || '.' || quote_ident(tablename)))::bigint) from pg_tables where schemaname = 'public';
*/

create or replace view v_migration_logs as
select *, coalesce(end_at, clock_timestamp()) - start_at as duration from migration_logs;

create or replace function start_migration_log(v_description varchar, v_comment text = null) returns bigint as $$
declare
    v_id bigint;
begin
    insert into migration_logs (description, comment, start_at) values (v_description, v_comment, clock_timestamp()) returning id into v_id;
	return v_id;
end;
$$ language plpgsql;

create or replace function end_migration_log(v_id bigint) returns void as $$
declare
begin
    update migration_logs set end_at = clock_timestamp() where id = v_id;
end;
$$ language plpgsql;

create or replace function rebuild_index_prepare(v_table varchar, v_schema varchar = 'public') returns void as $$
declare
rec record;
begin
    create table if not exists tmp_indexes as select * from pg_indexes where 1 = 0;
	insert into tmp_indexes select * from pg_indexes where schemaname = v_schema and tablename = v_table and indexdef not like '%UNIQUE INDEX%';
	for rec in (select * from tmp_indexes where schemaname = v_schema and tablename = v_table) loop
		execute 'drop index if exists ' || rec.indexname;
	end loop;
end;
$$ language plpgsql;

create or replace function rebuild_index(v_table varchar, v_schema varchar = 'public') returns void as $$
declare
    rec record;
begin
for rec in (select * from tmp_indexes where schemaname = v_schema and tablename = v_table) loop
	execute replace(rec.indexdef, ' ON ONLY ', ' ON ');
end loop;
delete from tmp_indexes where schemaname = v_schema and tablename = v_table;
end;
$$ language plpgsql;

insert into migration_logs (description, start_at) values ('start migration main.sql process', clock_timestamp());

-- base
\i job_type.sql;
\i bank.sql;
\i zone.sql;
\i monitor_reason.sql;
\i retake_reason.sql;
\i organization.sql;
\i role.sql;
\i user_nios.sql;
\i district_health_office.sql;
\i service_provider_group.sql;
\i xray_facility.sql;
\i radiologist.sql;
\i favourite_radiologist.sql;
\i radiologist_user.sql;
\i laboratory.sql;
\i doctor.sql;
\i user_sp.sql;
\i employer.sql;
\i user_portal.sql;
\i foreign_worker.sql;
\i fw_monitor_log.sql;
\i fw_block_log.sql;
\i transaction.sql;
\i transaction_comment.sql;
\i xqcc_transaction_comment.sql;
\i sequence.sql;
-- /base

-- foreign worker amendment
-- \i fw_critical_info.sql -- takes long time, better do after migration
-- /foreign worker amendment

-- XQCC review
\i xqcc_pool.sql;
\i xray_review.sql;
\i xray_review_detail.sql;
\i xqcc_review_identical.sql;
\i pcr_pool.sql;
\i pcr_review.sql;
\i pcr_review_detail.sql;
\i pcr_review_comment.sql;
\i xray_pending_review.sql;
\i xray_pending_decision.sql;
\i xqcc_transaction.sql;
\i xqcc_quarantine_reason.sql;
-- xray_dispatches
\i xray_dispatch_list.sql;
-- xray_dispatch_items
\i xray_dispatch_list_details.sql;
-- digital_xray_movements
\i xray_film_movement.sql;
-- digital_xray_movements
\i dxfilm_movement.sql;
-- /XQCC review

\i call_log.sql;
\i call_log_follow_up.sql;

\i status_schedule.sql;

--
\i update_transaction_bypass.sql;

\i allocates.sql;

\i insurance_purchases.sql;

\i biodata_requests.sql;
\i biodata_responses.sql;
\i biodata_transactions.sql;

-- service provider payment and manual payment
\i sp_transactions_payments.sql;
-- end

-- bank drafts/orders/order payments/order items for employers
\i bank_drafts_from_draft_master.sql;
\i orders_from_draft_master.sql;
\i order_payments_from_draft_master.sql;
\i order_items_from_draft_master.sql;
-- end

-- bank drafts/orders/order payments/order items for mspd
\i bank_drafts_from_receipt_doctor.sql;
\i bank_drafts_from_receipt_lab.sql;
\i bank_drafts_from_receipt_xray.sql;
\i bank_drafts_from_receipt_radiologist.sql;
\i bank_drafts_from_receipt_change_address.sql;
\i orders_from_receipt.sql;
\i order_items_from_receipt.sql;
\i bank_draft_allocations.sql;
-- end

\i update_transaction_order_item.sql;

\i employer_account.sql;

\i refunds.sql;

-- myimms
\i myimms.sql;
\i myimms_transactions.sql;
-- end

-- bulletins
\i bulletins.sql;
\i bulletin_audiences.sql;
-- end

-- To be run after migrating transactions and service providers.
-- To be run after rails seed.
-- inserting records for each transaction
    \i fw_details_doctor_examination.sql;
    \i fw_details_laboratory_examinations.sql;
    \i fw_details_xray_examinations.sql;
    \i xray_radio_assignment_comparison_seed.sql;

-- Must run transaction_cancelled after inserting the exams. Because there are no exams in cancelled transactions.
\i transaction_cancelled.sql;
\i transaction_created_by.sql;

-- updating examinations from records in fw_detail & fw_comment
    \i fw_details_update_doctor_examinations_history.sql;
    \i fw_details_update_doctor_examinations_physical.sql;
    \i fw_details_update_doctor_examinations_system.sql;
    \i fw_details_update_doctor_examinations_condition.sql;
    \i fw_details_update_doctor_examinations_follow_up.sql;
    \i fw_details_update_doctor_examinations_result.sql;
    \i fw_details_update_laboratory_examinations.sql;
    \i fw_details_update_laboratory_examinations_web_service.sql;
    \i fw_details_update_xray_examinations.sql;
    \i fw_comments_update_doctor_examinations_condition.sql;
    \i fw_details_and_comments_old_unused_conditions.sql;

-- inserting misc tables and xray assignment
    \i transaction_quarantine_reasons.sql;
    \i transaction_quarantine_reasons_fw_doc_10008.sql;
    \i xray_radiologist_assignment.sql;
    \i transactions_various_statuses.sql;

-- Pending review, medical examinations table.
    \i quarantine_fw_doc_medical_examinations.sql;
    \i quarantine_fw_doc_copy_over_details_and_comments.sql;
    \i quarantine_fw_doc_doctor_examinations_snapshots.sql;

-- Delete first, then reinsert, because logic to find the difference will be more process intensive.
    \i quarantine_fw_doc_delete_details_and_comments_from_doc_exam.sql;

-- Their data is not well maintained or the flow is different. Some of the fw_transaction do not have height, weight, pulse, bp. However, it seems to be recorded in the quarantine_fw_doc, so after running  quarantine_fw_doc_doctor_examinations_snapshots.sql, we can fix the missing data in medical_examinations.
    \i medical_examination_physical_measurements_fix.sql;

-- Reinsert doctor_examination details & comments.
    \i quarantine_fw_doc_de_history_and_follow_up.sql;
    \i quarantine_fw_doc_de_conditions.sql;
    \i quarantine_fw_doc_de_physicals.sql;
    \i quarantine_fw_doc_de_systems.sql;
    \i quarantine_fw_doc_de_comments.sql;

-- For medical pr cases that have not been completed, will have to migrate differently. It is assumed that when certified, it will follow what is in quarantine_fw_doc.
    \i quarantine_fw_doc_migration_for_unreleased_cases.sql;

--  Unsuitable reason seeding, must be after all fw_detail has been inserted.
    \i transaction_unsuitable_reasons.sql;

-- Pending review
    \i medical_reviews.sql;
    \i tcupi_reviews.sql;
    \i transaction_tcupi_todos.sql;
    \i tcupi_letters.sql;

-- Medical appeals
    \i medical_appeals.sql;
    \i medical_appeal_comments.sql;
    \i medical_appeal_todos.sql;
    \i medical_appeal_approvals.sql;
    \i medical_appeal_approvals_for_cancelled.sql;
    \i fwt_shadow.sql;
    \i shadow_xray_radio_assignment.sql;

-- Wrong Transmission & Status Change
    \i wrong_transmission.sql;
    \i status_change_history.sql;
    \i status_change_pending.sql;
    \i transaction_amendments_comment_update.sql;

-- MOH Database
    \i fw_transaction_static.sql;
    \i fw_detail_static.sql;
    \i moh_notifications.sql;
    \i moh_notification_checks.sql;

-- Setting sequences after proper migration
    \i set_various_sequences.sql;

-- Report Diff Bloodgroup
    -- \i report_diff_bloodgroup.sql;

-- First Transactions
    -- \i first_transactions.sql;

\i transaction_details.sql;

-- update foreign worker plks (run after biodata response), and latest transaction id
\i update_foreign_worker_plks.sql;
-- end

-- need to complete db/seeds/migration/main.sql first

-- *** Notes from HweeLeng ***
-- For production migration, last batch to be processed in current NIOS is 20201003.
-- Transactions starting from 19/10/2020 (batch 20201004) will be processed in new NIOS and Sage.
-- *** please double confirm again before live migration ***

\i fin_batches.sql;
\i sp_fin_batches.sql;
\i sp_fin_batch_items.sql;

-- update_foreign_worker_afis_id needs to be run after update_foreign_worker_plks has been run
\i update_foreign_worker_afis_id.sql;

\i update_service_provider_status_details.sql;

update users set code = 'NOREPLY'
where code = 'ADMIN_RADIOLOGIST';

with tbl as (select *, max(id) over () max_id from migration_logs where description = 'start migration main.sql process')
update migration_logs set end_at = clock_timestamp()
from tbl
where migration_logs.id = tbl.max_id;
