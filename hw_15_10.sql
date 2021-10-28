declare
    v_int integer;
    v_str varchar2(4000);
    v_doctor_id int := 3;
    v_hospital_id int;
    v_bool boolean := false;
    c_start_date date := '01.01.1998';
    c_end_date date := '01.01.2000';
    c_today date := sysdate;
    с_week_back date := sysdate - 7;
    c_date_char varchar2(10) := '01.01.1980';
    v_row PEROV_VL.regions%rowtype;
--объявление типа массив
    type arr_type is table of PEROV_VL.doctors%rowtype
    index by binary_integer;
    a_doctors arr_type;
    i binary_integer :=1;


begin
--#1
    select count( d.id_doctor)  into v_int from PEROV_VL.DOCTORS d ;
    dbms_output.put_line( v_int);
--#2
    select d.NAME into v_str from PEROV_VL.DOCTORS d where d.ID_DOCTOR = 2;
    dbms_output.put_line(v_str);
--#3
    select d.LAST_NAME into v_str from perov_vl.doctors d where d.Id_doctor = v_doctor_id;
    dbms_output.put_line(v_str);
--#4
    if v_bool then
        v_hospital_id :=1;
    else
        v_hospital_id :=3;
    end if;
    select h.name into v_str from perov_vl.hospitals h where h.ID_HOSPITAL = v_hospital_id ;
    dbms_output.put_line(v_str);
--#5.1
    select count(p.ID_PATIENT) into v_int
        from perov_vl.patient p where p.birth_date between c_start_date and c_end_date;
    dbms_output.put_line('количество пациентов: '|| v_int);
--#5.2
    select count(r.ID_RECORD) into v_int
        from perov_vl.RECORDS r where trunc(r.DATE_RECORD) = trunc(c_today);
    DBMS_OUTPUT.PUT_LINE('количество записей сделанных сегодня: '|| v_int);
--#5.3
    select count(r.ID_RECORD) into v_int
        from perov_vl.RECORDS r where trunc(r.DATE_RECORD) = trunc(с_week_back);
    DBMS_OUTPUT.PUT_LINE('количество записей сделанных неделю назад: '|| v_int);
--№5.4 (дальше смысла нет так как понятно как преобразовывать дату из строки)
     select count(p.ID_PATIENT) into v_int
        from perov_vl.patient p where p.birth_date > to_date(c_date_char);
    dbms_output.put_line('количество пациентов родившихся позже 1980: '|| v_int);
--№6
    select * into v_row
        from PEROV_VL.REGIONS r where ID_REGION = 7 ;
    dbms_output.put_line(v_row.ID_REGION || v_row.NAME );
--#7
    select * bulk collect into a_doctors
        from PEROV_VL.DOCTORS d;
    i:= a_doctors.FIRST;
    while i is not null loop
        declare
            v_doc_str PEROV_VL.DOCTORS%rowtype;
        begin
            v_doc_str := a_doctors(i);
            DBMS_OUTPUT.put_line(v_doc_str.LAST_NAME ||' '|| v_doc_str.NAME ||' '|| v_doc_str.PATRONYMIC);
            i:= a_doctors.NEXT(i);
        end;
        end loop;
end;

