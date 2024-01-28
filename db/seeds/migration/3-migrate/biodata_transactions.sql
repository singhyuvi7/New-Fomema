\echo "biodata_transactions.sql loaded"

do $$
declare
    v_log_id bigint;
begin
    select start_migration_log('biodata_transactions.sql') into v_log_id;
    commit;

    insert into biodata_transactions (
        transaction_id,
        status,
        afis_id,
        created_at, 
        updated_at
    ) 
    SELECT trans.id,
        case when (temp_biodata.afis_id is null and temp_biodata.passport_no is null) then null 
        when (temp_biodata.afis_id is null and temp_biodata.passport_no is not null) then 'SUCCESS' 
        when temp_biodata.afis_id is not null then 'SUCCESS'
        else null end,
        temp_biodata.afis_id,
        temp_biodata.creation_date,
        case when temp_biodata.reenrolment_insertdate between trans.transaction_date and trans.certification_date then trans.transaction_date else coalesce(temp_biodata.reenrolment_insertdate, temp_biodata.creation_date, clock_timestamp()) end
    FROM 
    (SELECT  distinct b.WORKER_CODE, 
        b.NATIONALITY, 
        b.DATE_OF_BIRTH, 
        b.GENDER, 
        b.WORKER_NAME, 
        b.DOC_EXPIRY_DATE, 
        b.DOC_ISSUE_AUTHORITY, 
        b.APPLICATION_NUMBER, 
        case when b.afis_id is null then (case when c.insertdate between d.transdate and d.certify_date then c.afis_id else null end) else b.afis_id end AFIS_ID, 
        b.NERS_REASON_CODE, 
        b.DATE_OF_ARRIVAL, 
        b.EMPLOYER_NAME, 
        b.EMPLOYER_ID, 
        b.EMPLOYER_TYPE, 
        b.EMPLOYER_ADDRESS1, 
        b.EMPLOYER_ADDRESS2, 
        b.EMPLOYER_ADDRESS3, 
        b.EMPLOYER_ADDRESS4, 
        b.EMPLOYER_POSTCODE, 
        b.EMPLOYER_CITY, 
        b.EMPLOYER_STATE, 
        b.EMPLOYER_EMAIL, 
        b.EMPLOYER_PHONE_NO, 
        b.NERS_STATUS, 
        b.NERS_MESSAGE, 
        b.TRANSACTION_ID, 
        b.UUID, 
        b.CREATION_DATE, 
        b.SURNAME, 
        b.PASSPORT_NO, 
        b.FP_BIOSL, 
        b.TRANS_ID, 
        b.FP_AVAILABILITY_STATUS, 
        b.FP_AVAIL, 
        b.RENEW_COUNT_YEAR, 
        b.PRA_CREATE_ID, 
        b.VERIFY_IND, 
        b.ERROR_DESC, 
        b.ERROR_IND,
        c.INSERTDATE as reenrolment_insertdate 
    FROM fomema_backup_nios.foreign_worker_biodata b
    left join fomema_backup_nios.fw_biodata_reenrolment c on b.worker_code=c.worker_code
    join fomema_backup_nios.fw_transaction d on d.trans_id=b.trans_id) AS temp_biodata
    join transactions trans on temp_biodata.trans_id = trans.code;

    perform end_migration_log(v_log_id);
end
$$;


\echo "biodata_transactions.sql ended"