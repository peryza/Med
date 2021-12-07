create or replace package PEROV_VL.pkg_hospitals
as
    c_id_private_hospital constant number := 3;
    c_id_state_hospital constant number := 4;

    function get_hospital_by_id(
    p_id_hospital in number
    )
    return PEROV_VL.HOSPITALS%rowtype;

    function get_hospitas_by_special_func(
    p_in_special in int
    )
    return sys_refcursor;

    type rec_hospital is record(
        name_h varchar2(100),
        count_d number,
        hs varchar2(20),
        ht varchar2(20),
        start_d varchar2(20),
        end_d varchar2(20)
    );

end;

create or replace package body PEROV_VL.pkg_hospitals
as
    function get_hospital_by_id(
    p_id_hospital in number
    )
    return PEROV_VL.HOSPITALS%rowtype
    as
    v_hospital PEROV_VL.HOSPITALS%rowtype;
    begin
        select * into v_hospital from HOSPITALS h
            where h.ID_HOSPITAL = p_id_hospital
                and h.DATE_DELETE is null;
        return v_hospital;
    end;

    function get_hospitas_by_special_func(
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
                ht.NAME as type_hospital,
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
                    when h.ID_HOSPITAL_TYPE = PEROV_VL.PKG_HOSPITALS.c_id_private_hospital then 3
                else 0
        end;
    return v_c_hospital;
    end;
end;

create or replace package PEROV_VL.pkg_doctors
as
    function
end;
create or replace package body PEROV_VL.pkg_doctors
as
end;

declare
    v_hospital PEROV_VL.HOSPITALS%rowtype;
    v_hospital_record PEROV_VL.PKG_HOSPITALS.rec_hospital;
    v_c_hospital sys_refcursor;
begin

    v_hospital:=PEROV_VL.PKG_HOSPITALS.GET_HOSPITAL_BY_ID(1);
    DBMS_OUTPUT.PUT_LINE(v_hospital.NAME);


    v_c_hospital:=PEROV_VL.PKG_HOSPITALS.get_hospitas_by_special_func(22);
    loop
        fetch v_c_hospital into v_hospital_record;
        exit when v_c_hospital%notfound;
        DBMS_OUTPUT.PUT_LINE(v_hospital_record.name_h||
                             '__кол-во врачей :'||v_hospital_record.count_d||
                             '__статус: '||v_hospital_record.hs||
                             '__тип: '||v_hospital_record.ht||
                             '__'||v_hospital_record.start_d||
                             '-'||v_hospital_record.end_d);
    end loop;
    DBMS_OUTPUT.PUT_LINE(v_hospital_record.name_h||' '||v_hospital_record.count_d);
end;
