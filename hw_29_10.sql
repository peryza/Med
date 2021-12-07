--##############################ФУНКЦИИ##################################
create or replace function PEROV_VL.get_town_by_regions_func

return sys_refcursor
as
v_c_town sys_refcursor;
begin
     open v_c_town for
        select t.NAME, r.name
        from PEROV_VL.TOWNS t
            join PEROV_VL.REGIONS r
                on r.ID_REGION = t.ID_REGION ;

     return v_c_town;
end;

create or replace function PEROV_VL.get_specializations_func

return sys_refcursor
as
v_c_specialization sys_refcursor;
begin
    open v_c_specialization for
         select
        s.name as special,
        count(d.id_doctor) as count_doctors
    from PEROV_VL.SPECIALIZATIONS s
    inner join PEROV_VL.DOCTOR_SPECIALIZATIONS ds
        on s.ID_SPECIALIZATION = ds.ID_SPECIALIZATIONS
    inner join PEROV_VL.DOCTORS d
        on ds.ID_DOCTORS = d.ID_DOCTOR
    inner join PEROV_VL.HOSPITALS h
        on h.ID_HOSPITAL = d.ID_HOSPITAL
    where s.DATE_DELETE is null
          and d.DATE_DELETE is null
              and h.DATE_DELETE is null
    group by s.name
    having count(d.ID_DOCTOR)>0;

    return v_c_specialization;
end;

create or replace function PEROV_VL.get_hospitas_by_special_func(
p_in_special in int
)

return sys_refcursor
as
v_c_hospital sys_refcursor;
    begin
        open v_c_hospital for
            select
            h.name as hospital,
            count(d.ID_DOCTOR) as doctor,
            hs.NAME as status,
            ht.NAME as type,
            to_char(wd.BEGIN_TIME, 'hh24:mi') as start_time,
            to_char(wd.END_TIME , 'hh24:mi') as end_time
            from PEROV_VL.HOSPITALS h
            left join doctors d
                on h.ID_HOSPITAL = d.ID_HOSPITAL
            left join PEROV_VL.HOSPITAL_TYPES ht
                on ht.ID_HOSPITAL_TYPE = h.ID_HOSPITAL_TYPE
            left join PEROV_VL.HOSPITAL_STATUS hs
                on hs.ID_STATUS = h.ID_STATUS
            left join PEROV_VL.DOCTOR_SPECIALIZATIONS ds
                on ds.ID_DOCTORS = d.ID_DOCTOR
            left join PEROV_VL.SPECIALIZATIONS s
                on s.ID_SPECIALIZATION = ds.ID_SPECIALIZATIONS
            left join  PEROV_VL.WORK_DAYS wd
                on h.ID_HOSPITAL = wd.ID_HOSPITAL
            where
                h.DATE_DELETE is null and
                  p_in_special is not null and
                    s.ID_SPECIALIZATION = p_in_special and
                        to_char(sysdate, 'fmDay') = wd.DAY
            group by h.name, hs.NAME, ht.NAME, wd.BEGIN_TIME, wd.END_TIME, h.ID_HOSPITAL_TYPE
            order by
            case
                when to_char(sysdate,'HH24:mi') < to_char(wd.END_TIME,'HH24:mi') then 1
                when count(d.ID_DOCTOR) > 0 then 2
                when h.ID_HOSPITAL_TYPE = 3 then 3
            else 0
    end;
return v_c_hospital;
end;

create or replace function PEROV_VL.get_doctors_by_hospital_func(
p_id_hospital in int,
p_number_area in int
)

return sys_refcursor
as
v_c_doctor sys_refcursor;
    begin
        open v_c_doctor for
        select
        d.last_name as doctor,
        H.name as hospital,
        q.name as qual,
        d.number_area as are
    from PEROV_VL.doctors d
        left join PEROV_VL.hospitals H
            on d.ID_HOSPITAL = H.ID_HOSPITAL
        left join PEROV_VL.QUALIFICATIONS q
            on d.ID_QUALIFICATION = q.ID_QUALIFICATION
    where d.DATE_DELETE is null
          and p_id_hospital is not null
            and H.ID_HOSPITAL = p_id_hospital
    order by
        case
            when d.NUMBER_AREA = p_number_area then 0
            when d.ID_QUALIFICATION is not null then 1
        else 2
        end;
        return v_c_doctor;
    end;
create or replace function PEROV_VL.get_ticket_by_doctor_func(
p_id_doctor in integer
)
return sys_refcursor
as
v_c_ticket sys_refcursor;
begin
    open v_c_ticket for
    select
        t.id_ticket as number_ticket,
        d.last_name as doctor,
        t.START_DATE as time_start
    from PEROV_VL.TICKETS t
        left join PEROV_VL.doctors d
            on d.ID_DOCTOR = t.ID_DOCTORS
    where p_id_doctor is not null
          and d.ID_DOCTOR = p_id_doctor
            and t.START_DATE > sysdate;
    return v_c_ticket;
end;
-- #############################ПРОЦЕДУРЫ########################################

create or replace procedure PEROV_VL.get_town_by_regions_proc
as
v_c_town sys_refcursor;
type rec_town is record(
    t_name varchar2(20),
    r_name varchar2(50));
v_town rec_town;
begin
    open v_c_town for
        select t.NAME, r.name
        from PEROV_VL.TOWNS t
            join PEROV_VL.REGIONS r
                on r.ID_REGION = t.ID_REGION ;
    loop
        fetch v_c_town into v_town;
        exit when v_c_town%notfound;
        DBMS_OUTPUT.PUT_LINE(v_town.t_name||'---'||v_town.r_name);
    end loop;
    close v_c_town;
end;

create or replace procedure PEROV_VL.get_specializations_proc
as
v_c_specialization sys_refcursor;
type rec_special is record(
    special_n varchar2(100),
    count_s int
    );
v_special rec_special;
begin
    open v_c_specialization for
         select
        s.name as special,
        count(d.id_doctor) as count_doctors
    from PEROV_VL.SPECIALIZATIONS s
    inner join PEROV_VL.DOCTOR_SPECIALIZATIONS ds
        on s.ID_SPECIALIZATION = ds.ID_SPECIALIZATIONS
    inner join PEROV_VL.DOCTORS d
        on ds.ID_DOCTORS = d.ID_DOCTOR
    inner join PEROV_VL.HOSPITALS h
        on h.ID_HOSPITAL = d.ID_HOSPITAL
    where s.DATE_DELETE is null
          and d.DATE_DELETE is null
              and h.DATE_DELETE is null
    group by s.name
    having count(d.ID_DOCTOR)>0;
    loop
    fetch v_c_specialization into v_special;
    exit when v_c_specialization%notfound;
    DBMS_OUTPUT.PUT_LINE(v_special.special_n||'______кол-во врачей: '||v_special.count_s);
    end loop;
    close v_c_specialization;
end;

create or replace procedure get_hospitas_by_special_proc(
p_in_special in int
)
as
v_c_hospital sys_refcursor;
type rec_hospital is record(
name_h varchar2(100),
count_d int,
hs varchar2(20),
ht varchar2(20),
start_d varchar2(20),
end_d varchar2(20)
);
v_hospital rec_hospital;
begin
    open v_c_hospital for
            select
            h.name as hospital,
            count(d.ID_DOCTOR) as doctor,
            hs.NAME as status,
            ht.NAME as type_h,
            to_char(wd.BEGIN_TIME, 'hh24:mi') as start_time,
            to_char(wd.END_TIME , 'hh24:mi') as end_time
            from PEROV_VL.HOSPITALS h
            left join doctors d
                on h.ID_HOSPITAL = d.ID_HOSPITAL
            left join PEROV_VL.HOSPITAL_TYPES ht
                on ht.ID_HOSPITAL_TYPE = h.ID_HOSPITAL_TYPE
            left join PEROV_VL.HOSPITAL_STATUS hs
                on hs.ID_STATUS = h.ID_STATUS
            left join PEROV_VL.DOCTOR_SPECIALIZATIONS ds
                on ds.ID_DOCTORS = d.ID_DOCTOR
            left join PEROV_VL.SPECIALIZATIONS s
                on s.ID_SPECIALIZATION = ds.ID_SPECIALIZATIONS
            left join  PEROV_VL.WORK_DAYS wd
                on h.ID_HOSPITAL = wd.ID_HOSPITAL
            where
                h.DATE_DELETE is null and
                  p_in_special is not null and
                    s.ID_SPECIALIZATION = p_in_special and
                        to_char(sysdate, 'fmDay') = wd.DAY
            group by h.name, hs.NAME, ht.NAME, wd.BEGIN_TIME, wd.END_TIME, h.ID_HOSPITAL_TYPE
            order by
            case
                when to_char(sysdate,'HH24:mi') < to_char(wd.END_TIME,'HH24:mi') then 1
                when count(d.ID_DOCTOR) > 0 then 2
                when h.ID_HOSPITAL_TYPE = 3 then 3
            else 0
    end ;
    loop
        fetch v_c_hospital into v_hospital;
        exit when v_c_hospital%notfound;
        DBMS_OUTPUT.PUT_LINE(v_hospital.name_h||
                             '__кол-во врачей :'||v_hospital.count_d||
                             '__статус: '||v_hospital.hs||
                             '__тип: '||v_hospital.ht||
                             '__'||v_hospital.start_d||
                             '-'||v_hospital.end_d);
    end loop;
    close v_c_hospital;

end;
create or replace procedure PEROV_VL.get_doctors_by_hospital_proc(
p_id_hospital in int,
p_number_area in int
)
as
type rec_doctor is record(
    name_d varchar2(50),
    name_h varchar2(100),
    name_q varchar2(20),
    number_a int
    );
v_doctor rec_doctor;
v_c_doctor sys_refcursor;
begin
    open v_c_doctor for
        select
        d.last_name as doctor,
        H.name as hospital,
        q.name as qual,
        d.number_area as are
    from PEROV_VL.doctors d
        left join PEROV_VL.hospitals H
            on d.ID_HOSPITAL = H.ID_HOSPITAL
        left join PEROV_VL.QUALIFICATIONS q
            on d.ID_QUALIFICATION = q.ID_QUALIFICATION
    where d.DATE_DELETE is null
          and p_id_hospital is not null
            and H.ID_HOSPITAL = p_id_hospital
    order by
        case
            when d.NUMBER_AREA = p_number_area then 0
            when d.ID_QUALIFICATION is not null then 1
        else 2
        end;
    loop
        fetch v_c_doctor into v_doctor;
        exit when v_c_doctor%notfound;
        DBMS_OUTPUT.PUT_LINE(v_doctor.name_d||'___'||v_doctor.name_h||'___'||v_doctor.name_q||'___'||v_doctor.number_a);
    end loop;
end;

create or replace procedure PEROV_VL.get_ticket_by_doctor_proc(
p_id_doctor in integer
)
as
type rec_ticket is record(
ticket_id int,
last_name_d varchar2(50),
start_t TIMESTAMP
);
v_ticket rec_ticket;
v_c_ticket sys_refcursor;
begin
     open v_c_ticket for
    select
        t.id_ticket as number_ticket,
        d.last_name as doctor,
        t.START_DATE as time_start
    from PEROV_VL.TICKETS t
        left join PEROV_VL.doctors d
            on d.ID_DOCTOR = t.ID_DOCTORS
    where p_id_doctor is not null
          and d.ID_DOCTOR = p_id_doctor
            and t.START_DATE > sysdate;
    loop
        fetch v_c_ticket into v_ticket;
        exit when v_c_ticket%notfound;
        DBMS_OUTPUT.PUT_LINE(v_ticket.ticket_id||'___'||v_ticket.last_name_d||'___'||to_char(v_ticket.start_t, 'dd.mm.yy hh24:mi'));
    end loop;
end;

declare
    v_c_town sys_refcursor;
    type rec_town is record(

        name_t varchar2(100),
        name_r varchar2(100)
    );
    v_town rec_town;

    v_c_specialization sys_refcursor;
    type rec_special is record(
    special_n varchar2(100),
    count_s int
    );
    v_special rec_special;

    type rec_hospital is record(
    name_h varchar2(100),
    count_d int,
    hs varchar2(20),
    ht varchar2(20),
    start_d varchar2(20),
    end_d varchar2(20)
    );
    v_hospital rec_hospital;
    v_c_hospital sys_refcursor;

    type rec_doctor is record(
    name_d varchar2(50),
    name_h varchar2(100),
    name_q varchar2(20),
    number_a int
    );
    v_doctor rec_doctor;
    v_c_doctor sys_refcursor;

    type rec_ticket is record(
    ticket_id int,
    last_name_d varchar2(50),
    start_t TIMESTAMP
    );
    v_ticket rec_ticket;
    v_c_ticket sys_refcursor;

begin
    DBMS_OUTPUT.PUT_LINE('#######################1#################');
    v_c_town:=PEROV_VL.get_town_by_regions_func();
    loop
        fetch v_c_town into v_town;
        exit when v_c_town%notfound;
        DBMS_OUTPUT.PUT_LINE(v_town.name_t||'___'||v_town.name_r);
    end loop;
    close v_c_town;

    DBMS_OUTPUT.PUT_LINE('#######################2#################');
    v_c_specialization:=PEROV_VL.get_specializations_func();
    loop
        fetch v_c_specialization into v_special;
        exit when v_c_specialization%notfound;
        DBMS_OUTPUT.PUT_LINE(v_special.special_n||'______кол-во врачей: '||v_special.count_s);
    end loop;
    close v_c_specialization;

    DBMS_OUTPUT.PUT_LINE('#######################3#################');
    v_c_hospital:=PEROV_VL.get_hospitas_by_special_func(22);
    loop
        fetch v_c_hospital into v_hospital;
        exit when v_c_hospital%notfound;
        DBMS_OUTPUT.PUT_LINE(v_hospital.name_h||
                             '__кол-во врачей :'||v_hospital.count_d||
                             '__статус: '||v_hospital.hs||
                             '__тип: '||v_hospital.ht||
                             '__'||v_hospital.start_d||
                             '-'||v_hospital.end_d);
    end loop;

    DBMS_OUTPUT.PUT_LINE('#######################4#################');
    v_c_doctor:=PEROV_VL.get_doctors_by_hospital_func(5, 202);
    loop
        fetch v_c_doctor into v_doctor;
        exit when v_c_doctor%notfound;
        DBMS_OUTPUT.PUT_LINE(v_doctor.name_d||'___'||v_doctor.name_h||'___'||v_doctor.name_q||'___'||v_doctor.number_a);
    end loop;

    DBMS_OUTPUT.PUT_LINE('#######################5#################');
    v_c_ticket:=PEROV_VL.get_ticket_by_doctor_func(4);
    loop
        fetch v_c_ticket into v_ticket;
        exit when v_c_ticket%notfound;
        DBMS_OUTPUT.PUT_LINE(v_ticket.ticket_id||'___'||v_ticket.last_name_d||'___'||to_char(v_ticket.start_t, 'dd.mm.yy hh24:mi'));
    end loop;

    DBMS_OUTPUT.PUT_LINE('////////////////////////////////////////');
    DBMS_OUTPUT.PUT_LINE('---------------ПРОЦЕДУРЫ-------------------');
    DBMS_OUTPUT.PUT_LINE('-------------------№1----------------------');
    PEROV_VL.get_town_by_regions_proc;
    DBMS_OUTPUT.PUT_LINE('-------------------№2----------------------');
    PEROV_VL.get_specializations_proc;
    DBMS_OUTPUT.PUT_LINE('-------------------№3----------------------');
    PEROV_VL.get_hospitas_by_special_proc(22);
    DBMS_OUTPUT.PUT_LINE('-------------------№4----------------------');
    PEROV_VL.get_doctors_by_hospital_proc(5,220);
    DBMS_OUTPUT.PUT_LINE('-------------------№5----------------------');
    PEROV_VL.get_ticket_by_doctor_proc(4);

end;