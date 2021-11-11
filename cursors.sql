declare

today varchar2(20) := to_char(sysdate, 'fmDay');
--курсор городов
cursor c_town is
        select t.NAME, r.name
        from PEROV_VL.TOWNS t
            join PEROV_VL.REGIONS r
                on r.ID_REGION = t.ID_REGION ;
type rec_town is record(

    name_t varchar2(100),
    name_r varchar2(100)
);
v_town rec_town;
v_c_town sys_refcursor;

-- курсор специализации
cursor c_specialization is
        select
        s.name as special,
        count(d.id_doctor) as count_doctors
    from PEROV_VL.SPECIALIZATIONS s
    inner join PEROV_VL.DOCTORS_SPECIALIZATIONS ds
        on s.ID_SPECIALIZATION = ds.ID_SPECIALIZATION
    inner join PEROV_VL.DOCTORS d
        on ds.ID_DOCTOR = d.ID_DOCTOR
    inner join PEROV_VL.HOSPITALS h
        on h.ID_HOSPITAL = d.ID_HOSPITAL
    where s.DATE_DELETE is null
          and d.DATE_DELETE is null
              and h.DATE_DELETE is null
    group by s.name
    having count(d.ID_DOCTOR)>0;

type rec_special is record(
    special_n varchar2(100),
    count_s int
);

v_special rec_special;
v_c_specialization sys_refcursor;

--курсор по больницам по кокретной специальности
cursor c_hospital(p_id_special in integer) is
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
left join PEROV_VL.DOCTORS_SPECIALIZATIONS ds
    on ds.ID_DOCTOR = d.ID_DOCTOR
left join PEROV_VL.SPECIALIZATIONS s
    on s.ID_SPECIALIZATION = ds.ID_SPECIALIZATION
left join  PEROV_VL.WORK_DAYS wd
    on h.ID_HOSPITAL = wd.ID_HOSPITAL
where
    h.DATE_DELETE is null
      and s.ID_SPECIALIZATION = p_id_special
         and to_char(sysdate, 'fmDay') = wd.DAY
            and p_id_special is not null
group by h.name, hs.NAME, ht.NAME, wd.BEGIN_TIME, wd.END_TIME, h.ID_HOSPITAL_TYPE
order by
    case
        when to_char(sysdate,'HH24:mi') < to_char(wd.END_TIME,'HH24:mi') then 1
        when count(d.ID_DOCTOR) > 0 then 2
        when h.ID_HOSPITAL_TYPE = 3 then 3
    else 0
end;

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

cursor c_doctor(p_id_doctor integer, p_number_area integer) is
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
         and (p_id_doctor is not null and p_number_area is not null)
          and H.ID_HOSPITAL = p_id_doctor

    order by
        case
            when d.NUMBER_AREA = p_number_area then 0
            when d.ID_QUALIFICATION is not null then 1
        else 2
        end;

type rec_doctor is record(
    name_d varchar2(50),
    name_h varchar2(100),
    name_q varchar2(20),
    number_a int
    );
v_doctor rec_doctor;
v_c_doctor sys_refcursor;

cursor c_ticket(p_id_doctor in integer) is
    select
    t.id_ticket as number_ticket,
    d.last_name as doctor,
    t.START_DATE as time_start
from PEROV_VL.TICKETS t
    left join PEROV_VL.doctors d
        on d.ID_DOCTOR = t.ID_DOCTOR
where p_id_doctor is not null
    and   d.ID_DOCTOR = p_id_doctor
        and t.START_DATE > sysdate;

type rec_ticket is record(
    ticket_id int,
    last_name_d varchar2(50),
    start_t TIMESTAMP
);
v_ticket rec_ticket;
v_c_ticket sys_refcursor;

begin
    DBMS_OUTPUT.PUT_LINE('#1.1########Статический_курсор#########');
    open c_town;
    loop
        fetch c_town into v_town;
        exit when c_town%notfound;
        DBMS_OUTPUT.PUT_LINE(v_town.name_t||'____'||v_town.name_r);
    end loop;
    close c_town;

    DBMS_OUTPUT.PUT_LINE('#1.2########НЕЯВНЫЙ КУРСОР###########');
    for i in (select t.name as t_name, r.name as r_name
        from PEROV_VL.TOWNS t
            join PEROV_VL.REGIONS r
                on r.ID_REGION = t.ID_REGION)
    loop
        v_town := i;
        DBMS_OUTPUT.PUT_LINE(v_town.name_t||'____'||v_town.name_r);
    end loop ;

    DBMS_OUTPUT.PUT_LINE('#1.3########КУРСОР_С_ПЕРЕМЕННОЙ###########');
    open v_c_town for
        select t.NAME, r.name
        from PEROV_VL.TOWNS t
            join PEROV_VL.REGIONS r
                on r.ID_REGION = t.ID_REGION ;
    loop
        fetch v_c_town into v_town;
        exit when v_c_town%notfound;
        DBMS_OUTPUT.put_line(v_town.name_t||'____'||v_town.name_r);
    end loop;
    close v_c_town;

    DBMS_OUTPUT.PUT_LINE('#2.1########Статический_курсор###########');
    open c_specialization;
    loop
        fetch c_specialization into v_special;
        exit when c_specialization%notfound;
        DBMS_OUTPUT.PUT_LINE(v_special.special_n||'_____кол-во врачей: '||v_special.count_s);
    end loop;
    close c_specialization;
    DBMS_OUTPUT.PUT_LINE('#2.2########Неявный_курсор###########');
    for i in (select
        s.name as special,
        count(d.id_doctor) as count_doctors
        from PEROV_VL.SPECIALIZATIONS s
        inner join PEROV_VL.DOCTORS_SPECIALIZATIONS ds
            on s.ID_SPECIALIZATION = ds.ID_SPECIALIZATION
        inner join PEROV_VL.DOCTORS d
            on ds.ID_DOCTOR = d.ID_DOCTOR
        inner join PEROV_VL.HOSPITALS h
            on h.ID_HOSPITAL = d.ID_HOSPITAL
        where s.DATE_DELETE is null
              and d.DATE_DELETE is null
                  and h.DATE_DELETE is null
        group by s.name
        having count(d.ID_DOCTOR)>0)
    loop
        v_special:= i;
        DBMS_OUTPUT.PUT_LINE(v_special.special_n||'______кол-во врачей: '||v_special.count_s);
    end loop ;

    DBMS_OUTPUT.PUT_LINE('#2.3########Курсор переменная###########');
    open v_c_specialization for select
        s.name as special,
        count(d.id_doctor) as count_doctors
        from PEROV_VL.SPECIALIZATIONS s
        inner join PEROV_VL.DOCTORS_SPECIALIZATIONS ds
            on s.ID_SPECIALIZATION = ds.ID_SPECIALIZATION
        inner join PEROV_VL.DOCTORS d
            on ds.ID_DOCTOR = d.ID_DOCTOR
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
        DBMS_OUTPUT.put_line(v_special.special_n||'______кол-во врачей: '||v_special.count_s);
        end loop;
    close v_c_specialization;

    DBMS_OUTPUT.PUT_LINE('#3.1########Статический_курсор###########');
    open c_hospital(22);
    loop
        fetch c_hospital into v_hospital;
        exit when c_hospital%notfound;
        DBMS_OUTPUT.PUT_LINE(v_hospital.name_h||'__кол-во врачей :'||v_hospital.count_d||'__статус: '
                        ||v_hospital.hs||'__тип: '||v_hospital.ht||'__'||v_hospital.start_d||'-'||v_hospital.end_d);
    end loop;
    close c_hospital;

    DBMS_OUTPUT.PUT_LINE('#3.2########Неявный_курсор###########');
    for i in (select
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
        left join PEROV_VL.DOCTORS_SPECIALIZATIONS ds
            on ds.ID_DOCTOR = d.ID_DOCTOR
        left join PEROV_VL.SPECIALIZATIONS s
            on s.ID_SPECIALIZATION = ds.ID_SPECIALIZATION
        left join  PEROV_VL.WORK_DAYS wd
            on h.ID_HOSPITAL = wd.ID_HOSPITAL
        where
            h.DATE_DELETE is null and
              s.ID_SPECIALIZATION = 22 and
                 today = wd.DAY
        group by h.name, hs.NAME, ht.NAME, wd.BEGIN_TIME, wd.END_TIME, h.ID_HOSPITAL_TYPE
        order by
        case
            when to_char(sysdate,'HH24:mi') < to_char(wd.END_TIME,'HH24:mi') then 1
            when count(d.ID_DOCTOR) > 0 then 2
            when h.ID_HOSPITAL_TYPE = 3 then 3
        else 0
        end )
    loop
        v_hospital:=i;
        DBMS_OUTPUT.PUT_LINE(v_hospital.name_h||'__кол-во врачей :'||v_hospital.count_d||'__статус: '
                            ||v_hospital.hs||'__тип: '||v_hospital.ht||'__'||v_hospital.start_d||'-'||v_hospital.end_d);
    end loop;

    DBMS_OUTPUT.PUT_LINE('#3.3########Курсор_переменной###########');
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
        left join PEROV_VL.DOCTORS_SPECIALIZATIONS ds
            on ds.ID_DOCTOR = d.ID_DOCTOR
        left join PEROV_VL.SPECIALIZATIONS s
            on s.ID_SPECIALIZATION = ds.ID_SPECIALIZATION
        left join  PEROV_VL.WORK_DAYS wd
            on h.ID_HOSPITAL = wd.ID_HOSPITAL
        where
            h.DATE_DELETE is null and
              s.ID_SPECIALIZATION = 22 and
                 today = wd.DAY
        group by h.name, hs.NAME, ht.NAME, wd.BEGIN_TIME, wd.END_TIME, h.ID_HOSPITAL_TYPE
        order by
        case
            when to_char(sysdate,'HH24:mi') < to_char(wd.END_TIME,'HH24:mi') then 1
            when count(d.ID_DOCTOR) > 0 then 2
            when h.ID_HOSPITAL_TYPE = 3 then 3
        else 0
        end;
    loop
        fetch v_c_hospital into v_hospital;
        exit when v_c_hospital%notfound;
        DBMS_OUTPUT.PUT_LINE(v_hospital.name_h||'__кол-во врачей :'||v_hospital.count_d||'__статус: '
                            ||v_hospital.hs||'__тип: '||v_hospital.ht||'__'||v_hospital.start_d||'-'||v_hospital.end_d);
        end loop;
    close v_c_hospital;

    DBMS_OUTPUT.PUT_LINE('#4.1########Статический_курсор###########');
    open c_doctor(5,202);
    loop
        fetch c_doctor into v_doctor;
        exit when c_doctor%notfound;
        DBMS_OUTPUT.PUT_LINE(v_doctor.name_d||'___'||v_doctor.name_h||'___'||v_doctor.name_q||'___'||v_doctor.number_a);
    end loop;
    close c_doctor;

    DBMS_OUTPUT.PUT_LINE('#4.2########Неявный_курсор###########');
    for i in (select
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
         and H.ID_HOSPITAL = 5
    order by
        case
            when d.NUMBER_AREA = 202 then 0
            when d.ID_QUALIFICATION is not null then 1
        else 2
        end)
    loop
        v_doctor:=i;
        DBMS_OUTPUT.PUT_LINE(v_doctor.name_d||'___'||v_doctor.name_h||'___'||v_doctor.name_q||'___'||v_doctor.number_a);
    end loop;

    DBMS_OUTPUT.PUT_LINE('#4.3########Курсор с переменной ##########');
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
         and H.ID_HOSPITAL = 5
    order by
        case
            when d.NUMBER_AREA = 202 then 0
            when d.ID_QUALIFICATION is not null then 1
        else 2
        end;
    loop
        fetch v_c_doctor into v_doctor;
        exit when v_c_doctor%notfound;
        DBMS_OUTPUT.PUT_LINE(v_doctor.name_d||'___'||v_doctor.name_h||'___'||v_doctor.name_q||'___'||v_doctor.number_a);
    end loop;
    close v_c_doctor;

    DBMS_OUTPUT.PUT_LINE('#5.1########Статический_курсор###########');
    open c_ticket(4);
    loop
        fetch c_ticket into v_ticket;
        exit when c_ticket%notfound;
        DBMS_OUTPUT.PUT_LINE(v_ticket.ticket_id||'___'||v_ticket.last_name_d||'___'||to_char(v_ticket.start_t, 'dd.mm.yy hh24:mi'));
    end loop;
    close c_ticket;

    DBMS_OUTPUT.PUT_LINE('#5.2########Неявный_курсор###########');
    for i in (
        select
        t.id_ticket as number_ticket,
        d.last_name as doctor,
        t.START_DATE as time_start
    from PEROV_VL.TICKETS t
        left join PEROV_VL.doctors d
            on d.ID_DOCTOR = t.ID_DOCTOR
    where d.ID_DOCTOR = 4
        and t.START_DATE > sysdate
        )
    loop
        v_ticket:=i;
        DBMS_OUTPUT.PUT_LINE(v_ticket.ticket_id||'___'||v_ticket.last_name_d||'___'||to_char(v_ticket.start_t, 'dd.mm.yy hh24:mi'));
    end loop;

    DBMS_OUTPUT.PUT_LINE('#5.3########Курсор с переменной ##########');
    open v_c_ticket for
            select
        t.id_ticket as number_ticket,
        d.last_name as doctor,
        t.START_DATE as time_start
    from PEROV_VL.TICKETS t
        left join PEROV_VL.doctors d
            on d.ID_DOCTOR = t.ID_DOCTOR
    where d.ID_DOCTOR = 4
        and t.START_DATE > sysdate;
    loop
        fetch v_c_ticket into v_ticket;
        exit when v_c_ticket%notfound;
        DBMS_OUTPUT.PUT_LINE(v_ticket.ticket_id||'___'||v_ticket.last_name_d||'___'||to_char(v_ticket.start_t, 'dd.mm.yy hh24:mi'));
    end loop;
    close v_c_ticket;

end;