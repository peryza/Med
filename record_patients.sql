--для выбора данных больницы по айдишнику(работает)
create or replace function PEROV_VL.get_hospital_by_id(
p_id_hospital in int
)
return
PEROV_VL.HOSPITALS%rowtype
AS
v_hospital PEROV_VL.HOSPITALS%rowtype;
begin
    select * into v_hospital from HOSPITALS h
        where h.ID_HOSPITAL = p_id_hospital
            and h.DATE_DELETE is null;
    return v_hospital;
end;

--для выбора данных врача по айдишнику(работает)
create or replace function PEROV_VL.get_doctor_by_id(
p_doctor_id in number
)
return
PEROV_VL.DOCTORS%rowtype
AS
v_doctor PEROV_VL.DOCTORS%rowtype;
begin
    select * into v_doctor from DOCTORS d
        where d.ID_DOCTOR = p_doctor_id
            and d.DATE_DELETE is null;
    return v_doctor;
end;

-- для выбора данных пациента по айдишнику(работает)
create or replace function  PEROV_VL.get_patient_by_id(
p_patient_id in int
)
return
    PEROV_VL.PATIENT%rowtype
as
v_patient PEROV_VL.PATIENT%rowtype;
begin
    select * into v_patient from PATIENT p
        where p.ID_PATIENT = p_patient_id;
    return v_patient;
end;
--для подсчета возраста пациента(работает)
create or replace function PEROV_VL.calck_age_human(
p_date date
)
return int
as
    v_age int;
begin
    v_age:= months_between(sysdate,p_date)/12;
    return v_age;
end;

--функция для выбора данных специализации по айдишнику(работает)
create or replace function PEROV_VL.get_specialization_by_id(
p_id_special in number
)
return
    PEROV_VL.SPECIALIZATIONS%rowtype
as
    v_special PEROV_VL.SPECIALIZATIONS%rowtype;
begin
    select * into v_special from PEROV_VL.SPECIALIZATIONS s
        where p_id_special = s.ID_SPECIALIZATION
            and s.DATE_DELETE is null;
    return v_special;
end;

--функция для проверки полиса у пациента
create or replace function PEROV_VL.check_oms_patient(
p_id_patient in number
)
return boolean
as
is_accord boolean default false;
v_count number;
begin
    select count(*) into v_count
        from PEROV_VL.NUMBER_DOCUMENTS nd
            where nd.ID_PATIENT = p_id_patient
                and nd.ID_DOCUMENT = 6;
    if v_count>0 then
        is_accord:=true;
    end if;
    return is_accord ;
end;

--функция для проверки соответсвия пола пациента с полом специальности (работает)
create or replace function PEROV_VL.check_accord_patient_spec_gender(
p_id_patient number,
p_id_special number
)
return boolean
as
is_accord boolean default false;
v_count number;
v_patient PEROV_VL.PATIENT%rowtype;
begin
    v_patient:=get_patient_by_id(p_id_patient);
    select count(*) into v_count
        from SPECIALIZATIONS_GENDERS sg
            where sg.ID_SPECIALIZATION = p_id_special
                and sg.ID_GENDER = v_patient.ID_GENDER;
    if v_count>0 then
        is_accord:=true;
    end if;
    return is_accord;
end;

--функция для проверки соответствия возраста пациента к специальности (работает)
create or replace function PEROV_VL.check_accord_patient_age_spec(
p_id_patient number,
p_id_special number
)
return boolean
as
v_age number;
is_accord boolean default false;
v_count number;
v_patient PEROV_VL.PATIENT%rowtype;
begin
    v_patient:=PEROV_VL.get_patient_by_id(p_id_patient);
    v_age:=PEROV_VL.calck_age_human(v_patient.BIRTH_DATE);
    select count(*) into v_count
        from PEROV_VL.SPECIALIZATIONS s
            join PEROV_VL.AGES a on s.ID_AGE = a.ID_AGE
                where s.ID_SPECIALIZATION = p_id_special
                  and v_age >= a.MIN_AGE
                  and v_age <= a.MAX_AGE;
     if v_count>0 then
        is_accord:=true;
    end if;
    return is_accord;
end;

--функции для забора данных талона (работает)
create or replace function PEROV_VL.get_ticket_by_id(
p_id_ticket number
)
return PEROV_VL.TICKETS%rowtype
as
v_ticket PEROV_VL.TICKETS%rowtype;
begin
    select * into v_ticket
        from PEROV_VL.TICKETS t
            where t.ID_TICKET = p_id_ticket;
    return v_ticket;
end;

--Проверка записан ли пациент на этот талон
create or replace function PEROV_VL.chek_record_patient_by_ticket(
p_id_patient in number,
p_id_ticket in number
)
return boolean
as
    is_exist boolean default false;
    v_count number;
begin
    select count(*) into v_count
        from PEROV_VL.RECORDS r
            where r.ID_PATIENT = p_id_patient
                and r.ID_TICKET = p_id_ticket;
    if v_count>0 then
        is_exist:=true;
    end if;
    return is_exist;
end;
--функция для расчета часов между двумя датами


--функция для записи пациента в журнал на талон!
create or replace function PEROV_VL.write_in_record(
p_id_patient in number,
p_id_ticket in number
)
return varchar2
as
v_massage varchar2(100);
begin
    insert into PEROV_VL.RECORDS(DATE_RECORD, ID_PATIENT, DATE_CANCELLATION, ID_STATUS, ID_TICKET)
    values(sysdate, p_id_patient, default, 4, p_id_ticket);
    commit ;
    v_massage:='пациет успешно записан на прием';
    return v_massage;
end;

create or replace function PEROV_VL.check_recording_possible(
    p_id_patient in number,
    p_id_ticket in number
)
return varchar2
as
    massage varchar2(100);
    v_doctor PEROV_VL.DOCTORS%rowtype;
    v_patient PEROV_VL.PATIENT%rowtype;
    v_special PEROV_VL.SPECIALIZATIONS%rowtype;
    v_ticket PEROV_VL.TICKETS%rowtype;
    v_hospital PEROV_VL.HOSPITALS%rowtype;
    v_age number;
    v_error_count number;
begin
    v_patient:=PEROV_VL.get_patient_by_id(p_id_patient);--забираем данные пациента
    v_age:=PEROV_VL.calck_age_human(v_patient.BIRTH_DATE);--считаем возраст пациента

    v_ticket:=PEROV_VL.get_ticket_by_id(p_id_ticket);--забираем даннык талона
    v_special:=PEROV_VL.get_specialization_by_id(v_ticket.ID_SPECIALIZATIONS);-- забираем даннык специальности через талон
    v_doctor:=PEROV_VL.get_doctor_by_id(v_ticket.ID_DOCTORS);--забираем данные врача через талон
    v_hospital:=PEROV_VL.get_hospital_by_id(v_doctor.ID_HOSPITAL);--забираем данные больницы через талон

    if PEROV_VL.chek_record_patient_by_ticket(p_id_patient,p_id_ticket) then
        return 'пациент уже записан на этот талон';
    end if;
    if PEROV_VL.check_accord_patient_spec_gender(p_id_patient,v_ticket.ID_SPECIALIZATIONS) = false then
        return 'пол пациента не соответствует полу специальности!';
    end if;
    if PEROV_VL.check_accord_patient_age_spec(p_id_patient,v_ticket.ID_SPECIALIZATIONS) = false then
        return 'возраст пациента не соответствует специальности!';
    end if;
    if v_ticket.ID_STATUS != 1 then
        return 'талон уже закрыт!';
    end if;
    if to_char(v_ticket.START_DATE,'hh24:mi')<to_char(sysdate,'hh24:mi') then
        return 'время начала талона уже прошло, попробуйте другой талон!';
    end if;
    if PEROV_VL.check_oms_patient(p_id_patient) = false then
        return 'у пациента нет полиса!';
    end if;

    return massage;
end;

--замента статуса талона после записи
create or replace function PEROV_VL.update_ticket_status_close(
    p_id_ticket in number
    )
return boolean
as
    is_update boolean default false;
    v_ticket PEROV_VL.TICKETS%rowtype;
begin
    update PEROV_VL.TICKETS t
        set t.ID_STATUS = 2
            where t.ID_TICKET = p_id_ticket;
    commit ;
    v_ticket:=PEROV_VL.get_ticket_by_id(p_id_ticket);
    if v_ticket.ID_STATUS = 2 then
        is_update:=true;
    end if;
    return is_update;
end;

create or replace function PEROV_VL.update_ticket_status_open(
    p_id_ticket in number
    )
return boolean
as
    is_update boolean default false;
    v_ticket PEROV_VL.TICKETS%rowtype;
begin
    update PEROV_VL.TICKETS t
        set t.ID_STATUS = 1
            where t.ID_TICKET = p_id_ticket;
    commit ;
    v_ticket:=PEROV_VL.get_ticket_by_id(p_id_ticket);
    if v_ticket.ID_STATUS = 1 then
        is_update:=true;
    end if;
    return is_update;
end;

--функция для получения часов между двумя датами
create or replace function PEROV_VL.get_hour_between_two_date(
p_in_firs_date in date,
p_in_second_date in date
)
return number
as
    v_hour number;
begin
    select
           round((p_in_firs_date-p_in_second_date) * 24) into v_hour
    from dual;
    return v_hour;
end;

--функция для получения данных записи
create or replace function PEROV_VL.get_record_by_id(
    p_id_record number
)
return
    PEROV_VL.RECORDS%rowtype
as
    v_record  PEROV_VL.RECORDS%rowtype;
begin
    select * into v_record
        from RECORDS r
            where r.ID_RECORD = p_id_record;
    return v_record;
end;

--функция отмены записи
create or replace function PEROV_VL.cancel_recording(
    p_id_record number
)
return boolean
as
    is_cancel boolean default true;
    v_ticket PEROV_VL.TICKETS%rowtype;
    v_record PEROV_VL.RECORDS%rowtype;
    v_end_time date;
begin
    v_record:=PEROV_VL.get_record_by_id(p_id_record);
    v_ticket:=PEROV_VL.get_ticket_by_id(v_record.ID_TICKET);
    v_end_time := PEROV_VL.get_time_work_hospital_by_ticket(v_ticket.ID_DOCTORS);
    if v_ticket.START_DATE < sysdate then
        is_cancel := false;
    end if;
    if PEROV_VL.get_hour_between_two_date(v_end_time, sysdate)<2 then
        is_cancel := false;
    end if;
    update PEROV_VL.RECORDS r
        set r.ID_STATUS = 5
            where r.ID_RECORD = p_id_record;
    commit ;
    PEROV_VL.update_ticket_status_open(v_ticket.ID_TICKET);
    return is_cancel;
end;

--функция которая заберает время конца работы больницы по талону
create or replace function PEROV_VL.get_time_work_hospital_by_ticket(
p_id_ticket number
)
return date
as
    v_id_doctor number;
    v_id_hospital number;
    v_end_time date;
begin
    select t.ID_DOCTORS into v_id_doctor from PEROV_VL.TICKETS t
        where t.ID_TICKET = p_id_ticket;
    select d.ID_HOSPITAL into v_id_hospital from PEROV_VL.DOCTORS d
        where d.ID_DOCTOR = v_id_doctor;
    select wd.END_TIMe into v_end_time from PEROV_VL.WORK_DAYS wd
        where to_char(sysdate, 'fmDay') = wd.DAY
            and wd.ID_HOSPITAL = v_id_hospital;
    return v_end_time;
end;


declare
    id_patient number :=25;
    id_ticket number :=4;
    v_massage varchar2(100);
    id_record number:=(21);
--основной блок для записи
begin
    v_massage := PEROV_VL.CHECK_RECORDING_POSSIBLE(id_patient,id_ticket);
    if v_massage is null then
        DBMS_OUTPUT.PUT_LINE('ошибок не обнаруженно, можно записывать');
        DBMS_OUTPUT.PUT_LINE(PEROV_VL.write_in_record(id_patient,id_ticket));
        PEROV_VL.update_ticket_status_close(id_ticket);
    else
        DBMS_OUTPUT.PUT_LINE(v_massage);
    end if;
--для отмены записи
    if (PEROV_VL.cancel_recording(id_record)) then
        DBMS_OUTPUT.PUT_LINE('запись успешно удалена!');
    else
        DBMS_OUTPUT.PUT_LINE('ошибка при удалении');
    end if;
end

