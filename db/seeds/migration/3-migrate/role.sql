\echo "role.sql loaded"

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('role.sql') into v_log_id;
    commit;

drop table if exists z_role_mappings;

create table if not exists z_role_mappings (
    oldcode character varying,
    newcode character varying
);

create index if not exists idx_z_role_mappings_on_oldcode on z_role_mappings(oldcode);
create index if not exists idx_z_role_mappings_on_newcode on z_role_mappings(newcode);

insert into z_role_mappings (oldcode, newcode) values ('ALL BUT NO ADMIN', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('BRANCH_DATA_ENTRY', 'BRANCH_DEC');
insert into z_role_mappings (oldcode, newcode) values ('BRANCH_EXECUTIVE', 'BRANCH_EXECUTIVE');
insert into z_role_mappings (oldcode, newcode) values ('BRANCH_MANAGER', 'BRANCH_MANAGER');
insert into z_role_mappings (oldcode, newcode) values ('BRANCH_OIC', 'BRANCH_OIC');
insert into z_role_mappings (oldcode, newcode) values ('BRANCH_PERLIS', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('BRANCH_PUTRAJAYA', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('BR_FW_AMENDMENT', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('CEO', 'CEO ');
insert into z_role_mappings (oldcode, newcode) values ('CHIEF MEDICAL OFFICER', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('CREATE USER ONLY', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('CUST_SERVICE', 'CS_EXECUTIVE');
insert into z_role_mappings (oldcode, newcode) values ('EWP_APPROVAL_1', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('EWP_APPROVAL_2', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('EXT_AUDITOR', 'FINANCE_EXTERNAL_AUDITOR');
insert into z_role_mappings (oldcode, newcode) values ('FINANCE_ADMIN', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('FINANCE_CLERK', 'FINANCE_CLERK');
insert into z_role_mappings (oldcode, newcode) values ('FINANCE_EXEC', 'FINANCE_EXECUTIVE');
insert into z_role_mappings (oldcode, newcode) values ('FINANCE_MANAGER', 'FINANCE_MANAGER');
insert into z_role_mappings (oldcode, newcode) values ('FINANCE_TEMP_STAFF', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('FOREIGN_CLINIC', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('HCM', 'HCM_EXECUTIVE');
insert into z_role_mappings (oldcode, newcode) values ('INSP', 'INSPECTORATE_EXECUTIVE');
insert into z_role_mappings (oldcode, newcode) values ('INSP & XQCC', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('IT_ADMINISTRATOR', 'IT_ADMIN');
insert into z_role_mappings (oldcode, newcode) values ('IT_SUPPORT', 'IT_SUPPORT');
insert into z_role_mappings (oldcode, newcode) values ('MED_CLERK', 'MEDICAL_CLERK');
insert into z_role_mappings (oldcode, newcode) values ('MED_COUNTER', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('MED_MLE', 'MEDICAL_MLE');
insert into z_role_mappings (oldcode, newcode) values ('MED_OFFICER', 'MEDICAL_MO');
insert into z_role_mappings (oldcode, newcode) values ('MED_SR_MLE', 'MEDICAL_SENIOR_MLE');
insert into z_role_mappings (oldcode, newcode) values ('MSPD MONITORING EXECUTIVE', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('MSPD_ASST_MANAGER', 'MSPD_ASSISTANT_MANAGER');
insert into z_role_mappings (oldcode, newcode) values ('MSPD_CLERK', 'MSPD_CLERK');
insert into z_role_mappings (oldcode, newcode) values ('MSPD_EXEC', 'MSPD_EXECUTIVE');
insert into z_role_mappings (oldcode, newcode) values ('MSPD_MANAGER', 'MSPD_MANAGER');
insert into z_role_mappings (oldcode, newcode) values ('MSPD_STATISTIC', 'MSPD_STATISTICIAN');
insert into z_role_mappings (oldcode, newcode) values ('OPERATION_MANAGER', 'OPERATION_MANAGER');
insert into z_role_mappings (oldcode, newcode) values ('OPERATION_SVP', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('PANTAI_SUPREME_DATA', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('PCR', 'PCR');
insert into z_role_mappings (oldcode, newcode) values ('PEOPLE DISABLE LOGIN', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('PIC', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('REGIONAL_MANAGER', 'BRANCH_RM');
insert into z_role_mappings (oldcode, newcode) values ('REPORTS_ONLY', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('TYLTESTING', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('UMSB_CEO', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('UMSB_CUST_SERVICE', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('UMSB_INSPECTORATE', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('UMSB_RADIOGRAPHER', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('VIEW_WORKER_DETAIL', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('XQCC_ASST_MANAGER', 'XQCC_ASSISTANT_MANAGER');
insert into z_role_mappings (oldcode, newcode) values ('XQCC_ASST_RADIOGRAPHER', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('XQCC_EXEC', 'XQCC_EXECUTIVE');
insert into z_role_mappings (oldcode, newcode) values ('XQCC_GEN_CLERK', 'OBSOLETE');
insert into z_role_mappings (oldcode, newcode) values ('XQCC_MANAGER', 'XQCC_MO');
insert into z_role_mappings (oldcode, newcode) values ('XQCC_MLE', 'XQCC_MLE');
insert into z_role_mappings (oldcode, newcode) values ('XQCC_RADIOGRAPHER', 'XQCC_RADIOGRAPHER');

    perform end_migration_log(v_log_id);
end
$$;

\echo "role.sql ended"
