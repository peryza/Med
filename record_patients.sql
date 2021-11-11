--для выбора данных врача
create or replace function PEROV_VL.get_doctor_by_id(
p_doctor_id in int
)
return
PEROV_VL.DOCTORS%rowtype
AS
v_doctor PEROV_VL.DOCTORS%rowtype;
begin
    select * into v_doctor from DOCTORS d
        where d.ID_DOCTOR = p_doctor_id;
    return v_doctor;
end;
-- для выбора данных пациента
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
--для подсчета возраста пациента
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
--для проверки полиса у пациета
-- create or replace function PEROV_VL.chek_oms_patient(
-- p_id_patient int
-- )
-- return boolean
-- as
--     v_patient PEROV_VL.PATIENT%rowtype;
--     oms_is boolean;
-- begin
--     select * into v_patient from PEROV_VL.PATIENT p
--         join NUMBER_DOCUMENTS nd on p_id_patient = nd.ID_PATIENT
--             where nd.ID_DOCUMENT = 6;
--     if v_patient is null then
--         oms_is := true;
--     else oms_is:=false;
--     return oms_is;
--     end if;
-- end;
--для проверки подходит ли по взрасту к специальности
create or replace function check_age_special(
p_id_patient int,
p_id_special int
)
return boolean
as
v_patient PEROV_VL.PATIENT%rowtype;
v_age int;
begin
v_patient :=PEROV_VL.get_patient_by_id(p_id_patient);
v_age :=PEROV_VL.calck_age_human(v_patient.BIRTH_DATE);


end;

declare
v_doctor PEROV_VL.DOCTORS%rowtype;
v_patient PEROV_VL.PATIENT%rowtype;
v_age int;

id_doctor int := 1;
id_patient int := 23;


--основной блок для записи
begin

v_patient:=PEROV_VL.get_patient_by_id(id_patient);
DBMS_OUTPUT.put_line(v_patient.NAME||v_patient.LAST_NAME||v_patient.BIRTH_DATE);
v_age:=PEROV_VL.calck_age_human(v_patient.BIRTH_DATE);
DBMS_OUTPUT.PUT_LINE(v_age);
if PEROV_VL.chek_oms_patient(23) then
    DBMS_OUTPUT.PUT_LINE('есть полис');
    else DBMS_OUTPUT.PUT_LINE('нет полиса');
end if;
end;