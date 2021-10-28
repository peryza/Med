---	Выдать все города по регионам
select
    t.NAME as town,
    r.NAME as region
from PEROV_VL.TOWNS t
join PEROV_VL.REGIONS r
    on t.ID_REGION = r.ID_REGION;

--Выдать все специальности (неудаленные),
-- в которых есть хотя бы один доктор (неудаленный),
-- которые работают в больницах (неудаленных)

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

--Выдать все больницы (неудаленные) конкретной специальности с пометками о доступности,
--кол-ве врачей; отсортировать по типу: частные выше, по кол-ву докторов: где больше выше,
--по времени работы: которые еще работают выше

select
    hospitals.name as hospital,
    count(DOCTORS.id_doctor) as count_doctors,
    hs.NAME as status,
    ht.NAME as type
from PEROV_VL.HOSPITALS
    left join PEROV_VL.DOCTORS
        on HOSPITALS.ID_HOSPITAL = DOCTORS.ID_HOSPITAL
    left join PEROV_VL.WORK_DAYS
        on HOSPITALS.ID_HOSPITAL = WORK_DAYS.ID_HOSPITAL
    left join PEROV_VL.HOSPITAL_STATUS HS
        on HOSPITALS.ID_STATUS = HS.ID_STATUS
    left join PEROV_VL.HOSPITAL_TYPES HT
        on HOSPITALS.ID_HOSPITAL_TYPE = HT.ID_HOSPITAL_TYPE
where HOSPITALS.DATE_DELETE is null
group by hospitals.name, hs.NAME, ht.NAME
order by ht.NAME desc , count_doctors desc ;

--	Выдать всех врачей (неудаленных) конкретной больницы,
--	отсортировать по квалификации: у кого есть выше,
--	по участку: если участок совпадает с участком пациента, то такие выше

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
    end
;

--	Выдать все талоны конкретного врача,
--	не показывать талоны которые начались раньше текущего времени

select
    t.id_ticket as number_ticket,
    d.last_name as doctor,
    t.START_DATE as time_start
from PEROV_VL.TICKETS t
    left join PEROV_VL.doctors d
        on d.ID_DOCTOR = t.ID_DOCTOR
where d.ID_DOCTOR = 1
    and t.START_DATE > sysdate;


--Выдать все больницы (неудаленные) конкретной специальности с пометками о доступности,
--кол-ве врачей; отсортировать по типу: частные выше, по кол-ву докторов: где больше выше,
--по времени работы: которые еще работают выше

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
         to_char(sysdate,'Day') = wd.DAY
group by h.name, hs.NAME, ht.NAME, wd.BEGIN_TIME, wd.END_TIME, h.ID_HOSPITAL_TYPE
order by
    case
        when trunc(sysdate,'HH24:mi') < trunc(wd.END_TIME,'HH24:mi') then 1
        when count(d.ID_DOCTOR) > 0 then 2
        when h.ID_HOSPITAL_TYPE = 3 then 3
    else 0
    end;

