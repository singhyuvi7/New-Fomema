do $$
declare
    rec_source record;
    rec_emp record;
begin

    for rec_source in (
        select email, count(*) from employers 
        where email is not null and email != ''
        group by email having count(*) > 1
    ) loop
        raise notice 'email: %', rec_source.email;
        for rec_emp in (
            select e.id, e.code, e.email, u.id user_id, u.username, u.email as user_email, u.userable_type, u.userable_id
            from employers e 
            left join users u on e.id = u.userable_id and u.userable_type = 'Employer'
            where e.email = rec_source.email
        ) loop
            raise notice 'emp.id: %, emp.code: %, u.id: %, u.type: %, u.emp_id: %', 
            rec_emp.id, rec_emp.code, rec_emp.user_id, rec_emp.userable_type, rec_emp.userable_id;
            
            update users set email = '' where id = rec_emp.user_id;
            update employers set email = '' where code = rec_emp.code;
        end loop;
    end loop;

    for rec_source in (
        select email from employers 
        where email in (
            '3-2928757', 
            'venus 99', 
            '''', 
            'maryam', 
            'uulsb@po', 
            '038369788', 
            '074151236', 
            'nil', 
            '037755460', 
            '038861993', 
            '45468423', 
            '+22+', 
            '623743277', 
            '-55107482', 
            'n/a', 
            'seccolor', 
            'cch', 
            'wdt 140', 
            '15455832', 
            'm-rim-69',
            '#'
        )
    ) loop
        raise notice 'email: %', rec_source.email;
        for rec_emp in (
            select e.id, e.code, e.email, u.id user_id, u.username, u.email as user_email, u.userable_type, u.userable_id
            from employers e 
            left join users u on e.id = u.userable_id and u.userable_type = 'Employer'
            where e.email = rec_source.email
        ) loop
            raise notice 'emp.id: %, emp.code: %, u.id: %, u.type: %, u.emp_id: %', 
            rec_emp.id, rec_emp.code, rec_emp.user_id, rec_emp.userable_type, rec_emp.userable_id;
            
            update users set email = '' where id = rec_emp.user_id;
            update employers set email = '' where code = rec_emp.code;
        end loop;
    end loop;

end;
$$;