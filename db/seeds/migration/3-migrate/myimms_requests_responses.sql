\echo "myimms_requests_responses.sql loaded"

-- myimms_queue
DO $$
    DECLARE
        temp_row RECORD;
		myimms_status text;
		response text;
		myimms_queue_id bigint;
		created_updated_date date;
		v_log_id bigint;
    begin
		select start_migration_log('myimms_requests_responses.sql') into v_log_id;
		commit;

        FOR temp_row IN
           SELECT mq.*, my.id as myimm_id, mt.id as myimms_transaction_id, tr.id as transaction_id
            FROM fomema_backup_nios.myimms_queue mq 
            join myimms my on mq.batch_num::varchar = my.batch_code
			join transactions tr on mq.trans_id = tr.code 
			join myimms_transactions mt on tr.id = mt.transaction_id
        LOOP
			created_updated_date = case when temp_row.reply_date is NULL then NOW() else temp_row.reply_date end;

			INSERT INTO myimms_requests (
				myimms_transaction_id, myimm_id,txn_id, doc_no, nat, dob, name, sex, med_sts, med_dt, modify_dt, src_ind, sts_ind, st_ind, created_at, updated_at
			) 
			VALUES (
				temp_row.myimms_transaction_id,temp_row.myimm_id, temp_row.trans_id, temp_row.passport_no, temp_row.nationality, temp_row.date_of_birth, temp_row.name, temp_row.sex, temp_row.medical_status, temp_row.exam_date, temp_row.modify_date, 'F', temp_row.queue_op, case when temp_row.is_labuan = 'N' then 'O' else 'L' end, created_updated_date, created_updated_date
			)
			RETURNING id INTO myimms_queue_id;

			IF temp_row.reply_date IS NOT NULL THEN
				IF temp_row.myimms_reply = '1' THEN
					myimms_status = temp_row.myimms_reply;
					response = concat('{"txn_id"=>"',temp_row.trans_id,'", "result"=>"1"}');
				ELSE
					myimms_status = '0';
					response = temp_row.myimms_error;
				END IF;
			ELSE
				myimms_status = '97';
				response = 'YET TO PROCEED';
			END IF;

			-- myimms_responses table
			INSERT INTO myimms_responses (
				myimms_request_id, response, status, created_at, updated_at
			)
			VALUES (
				myimms_queue_id, response, myimms_status, created_updated_date, created_updated_date
			);

        END LOOP;

		perform end_migration_log(v_log_id);
    END
$$;

\echo "myimms_requests_responses.sql ended"
