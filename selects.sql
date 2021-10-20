---	Выдать все города по регионам
select
    TOWNS.NAME as town,
    REGIONS.NAME as region
from TOWNS
join REGIONS
    on TOWNS.ID_REGION = REGIONS.ID_REGION;

--Выдать все специальности (неудаленные),
-- в которых есть хотя бы один доктор (неудаленный),
-- которые работают в больницах (неудаленных)

select
    SPECIALIZATIONS.name as special,
    count(DOCTORS.id_doctor) as count_doctors
from SPECIALIZATIONS
inner join DOCTORS_SPECIALIZATIONS
    on SPECIALIZATIONS.ID_SPECIALIZATION = DOCTORS_SPECIALIZATIONS.ID_SPECIALIZATION
inner join DOCTORS
    on DOCTORS_SPECIALIZATIONS.ID_DOCTOR = DOCTORS.ID_DOCTOR
inner join HOSPITALS
    on HOSPITALS.ID_HOSPITAL = DOCTORS.ID_HOSPITAL
where SPECIALIZATIONS.DATE_DELETE is null
      and DOCTORS.DATE_DELETE is null
          and HOSPITALS.DATE_DELETE is null
group by SPECIALIZATIONS.name
having count(DOCTORS.ID_DOCTOR)>0;

--Выдать все больницы (неудаленные) конкретной специальности с пометками о доступности,
--кол-ве врачей; отсортировать по типу: частные выше, по кол-ву докторов: где больше выше,
--по времени работы: которые еще работают выше

select
    hospitals.name as hospital,
    count(DOCTORS.id_doctor) as count_doctors,
    hs.NAME as status,
    ht.NAME as tupe
from HOSPITALS
    left join DOCTORS
        on HOSPITALS.ID_HOSPITAL = DOCTORS.ID_HOSPITAL
    left join WORK_DAYS
        on HOSPITALS.ID_HOSPITAL = WORK_DAYS.ID_HOSPITAL
    left join HOSPITAL_STATUS HS
        on HOSPITALS.ID_STATUS = HS.ID_STATUS
    left join HOSPITAL_TYPES HT
        on HOSPITALS.ID_HOSPITAL_TYPE = HT.ID_HOSPITAL_TYPE
where HOSPITALS.DATE_DELETE is null
group by hospitals.name, hs.NAME, ht.NAME
order by ht.NAME desc , count_doctors desc ;

--	Выдать всех врачей (неудаленных) конкретной больницы,
--	отсортировать по квалификации: у кого есть выше,
--	по участку: если участок совпадает с участком пациента, то такие выше

select
    DOCTORS.last_name as doctor,
    H.NAME as hospital,
    QUALIFICATIONS.NAME as qual
from DOCTORS
    left join HOSPITALS H
        on DOCTORS.ID_HOSPITAL = H.ID_HOSPITAL
    left join QUALIFICATIONS
        on DOCTORS.ID_QUALIFICATION = QUALIFICATIONS.ID_QUALIFICATION
where DOCTORS.DATE_DELETE is null
      and H.ID_HOSPITAL = 1
group by DOCTORS.last_name, H.NAME, QUALIFICATIONS.NAME
order by QUALIFICATIONS.NAME;

--	Выдать все талоны конкретного врача,
--	не показывать талоны которые начались раньше текущего времени

select
    TICKETS.id_ticket as number_ticket,
    DOCTORS.last_name as doctor,
    TICKETS.START_DATE as time_start
from TICKETS
    left join DOCTORS
        on DOCTORS.ID_DOCTOR = TICKETS.ID_DOCTOR
where DOCTORS.ID_DOCTOR = 1
    and TICKETS.START_DATE > CURRENT_DATE
group by TICKETS.id_ticket, DOCTORS.last_name, TICKETS.START_DATE

