declare
cursor cursor_1 is
        select * from PEROV_VL.DOCTORS d;
    cursor cursor_2(p_id_doctor in number) is
       select *
       from PEROV_VL.DOCTORS d
       where p_id_doctor = d.ID_DOCTOR;
    v_doctors PEROV_VL.DOCTORS%rowtype;
    cursor cursor_3(p_id_hospital in number) is
        select *
        from perov_vl.hospitals h
        where h.ID_HOSPITAL = p_id_hospital;
    v_hospital PEROV_VL.HOSPITALS%rowtype;
    v_bool boolean :=true;
    cursor cursor_4(start_date in date, end_date in date ) is
        select *
        from perov_vl.patient p
        where p.birth_date between start_date and end_date;
    v_patient PEROV_VL.PATIENT%rowtype;
    cursor cursor_5 is
        select *  from
        perov_vl.RECORDS r
        where trunc(r.DATE_RECORD) = trunc(sysdate-7);
    v_count int :=0;
    cursor cursor_6(p_date in varchar2) is
        select *
        from perov_vl.patient p
        where p.birth_date > to_date(p_date);
    cursor cursor_7(p_id_region in number) is
        select *
        from PEROV_VL.REGIONS r
        where r.ID_REGION = p_id_region ;
    v_region PEROV_VL.REGIONS%rowtype;
begin
    DBMS_OUTPUT.put_line('№1--------------------------------------------');
    open cursor_1;
    loop
        fetch cursor_1 into v_doctors;
        exit when cursor_1%notfound;
    end loop;
        DBMS_OUTPUT.put_line('количество докторов'||' - '||cursor_1%rowcount);
    close cursor_1;

    DBMS_OUTPUT.put_line('№2--------------------------------------------');
    open cursor_2(3);
    loop
        fetch cursor_2 into v_doctors;
        exit when cursor_2%notfound;
        DBMS_OUTPUT.PUT_LINE('id:'||v_doctors.ID_DOCTOR||' - '||v_doctors.NAME||' '||v_doctors.LAST_NAME );
    end loop;
    close cursor_2;

    DBMS_OUTPUT.put_line('№3-----------------булево---------------------');
    open cursor_3(5);
    loop
        fetch cursor_3 into v_hospital;
        exit when cursor_3%notfound;
        if v_hospital.DATE_DELETE is not null then v_bool := false;
        end if;
        if v_bool = false then
            DBMS_OUTPUT.put_line(v_hospital.NAME || '---' || 'больница удалена!');
        else
            DBMS_OUTPUT.put_line(v_hospital.NAME || '---' || 'больница не удалена!');
        end if;
    end loop;
    close cursor_3;

    DBMS_OUTPUT.put_line('№4----------------------------------------');
    open cursor_4('01.01.1980','01.01.2000');
    loop
        fetch cursor_4 into v_patient;
        exit when cursor_4%notfound;
        DBMS_OUTPUT.PUT_LINE(v_patient.NAME||' '||v_patient.LAST_NAME||' '||trunc(v_patient.BIRTH_DATE));
    end loop;
    DBMS_OUTPUT.PUT_LINE( 'общее количество: '||cursor_4%rowcount);
    close cursor_4;

    DBMS_OUTPUT.put_line('№5.1----------------------------------------');
    for i in (
        select *
        from perov_vl.RECORDS r where trunc(r.DATE_RECORD) = trunc(sysdate)
    )
    loop
        declare
            v_record PEROV_VL.RECORDS%rowtype := i;
        begin
            DBMS_OUTPUT.PUT_LINE(v_record.ID_RECORD||' / '||trunc(v_record.DATE_RECORD));
        end;
    end loop;

    DBMS_OUTPUT.put_line('№5.2----------------------------------------');
    for i in cursor_5 loop
        declare
            v_record Perov_vl.RECORDS%rowtype:=i;
            begin
            v_count:=v_count+1;
            DBMS_OUTPUT.PUT_LINE('номер записи -'||v_record.ID_RECORD||'  дата записи -'||v_record.DATE_RECORD);
            end;
        end loop;

    DBMS_OUTPUT.PUT_LINE('количество записей сделанных неделю в день неделю назад:'||v_count);
    DBMS_OUTPUT.put_line('№5.3----------------------------------------');
    open cursor_6('12.12.1980');
    loop
        fetch cursor_6 into v_patient;
        exit when cursor_6%notfound;
        DBMS_OUTPUT.PUT_LINE(v_patient.LAST_NAME||' - '||v_patient.BIRTH_DATE);
    end loop;
        DBMS_OUTPUT.PUT_LINE( 'Общее количество: '||cursor_6%rowcount);
    close cursor_6;
    DBMS_OUTPUT.put_line('№6-------------------------------------------');
    open cursor_7(7);
    loop
        fetch cursor_7 into v_region;
        exit when cursor_7%notfound;
        DBMS_OUTPUT.PUT_LINE(v_region.ID_REGION||' '||v_region.name);
    end loop;
    close cursor_7;
    DBMS_OUTPUT.put_line('#7---выборка одной строки---');
    open cursor_1;
    fetch cursor_1 into v_doctors;
    DBMS_OUTPUT.PUT_LINE(v_doctors.ID_DOCTOR||' '||v_doctors.name||' '||v_doctors.last_name||' '||v_doctors.ID_HOSPITAL);
    close cursor_1;
end;