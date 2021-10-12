create table regions (
    id_region number generated by default as identity
                     (start with 1 maxvalue 9999 minvalue 1 nocycle nocache noorder ) primary key,
    name varchar2(30)
);

create table towns(
    id_town number generated by default as identity
                  (start with 1 maxvalue 9999 minvalue 1 nocycle nocache noorder ) primary key,
    name varchar2(30),
    id_region number references regions(id_region)
);

create table medical_organizations(
    id_medical_organization number generated by default as identity
                  (start with 1 maxvalue 9999 minvalue 1 nocycle nocache noorder ) primary key,
    name varchar2(30),
    id_town number references towns(id_town)
);

create table ages(
    id_age number generated by default as identity
                  (start with 1 maxvalue 99 minvalue 1 nocycle nocache noorder ) primary key,
    name varchar2(20),
    min_age int,
    max_age int
);

create table genders(
    id_gender number generated by default as identity
                  (start with 1 maxvalue 9 minvalue 1 nocycle nocache noorder ) primary key,
    name varchar2(10)
);

create table work_time(
    id_work_time number generated by default as identity
                  (start with 1 maxvalue 9999999 minvalue 1 nocycle nocache noorder ) primary key,
    start_mon date,
    end_mon date,
    start_tues date,
    end_tues date,
    start_wed date,
    end_wed date,
    start_thurs date,
    end_thurs date,
    start_fri date,
    end_fri date,
    start_sat date,
    end_sat date,
    start_sun date,
    end_sun date
);

create table hospital_types(
    id_hospital_type number generated by default as identity
                  (start with 1 maxvalue 99 minvalue 1 nocycle nocache noorder ) primary key,
    name varchar2(20)
);

create table hospital_status(
     id_status number generated by default as identity
                  (start with 1 maxvalue 99 minvalue 1 nocycle nocache noorder ) primary key,
     name varchar2(20)
);

create table hospitals(
    id_hospital number generated by default as identity
                  (start with 1 maxvalue 9999999 minvalue 1 nocycle nocache noorder ) primary key,
    name varchar2(50),
    id_medical_organization number references medical_organizations(id_medical_organization),
    id_hospital_type number references hospital_types(id_hospital_type),
    id_status number references hospital_status(id_status),
    id_work_time number references work_time(id_work_time),
    date_delete date
);

create table qualifications(
    id_qualification number generated by default as identity
                  (start with 1 maxvalue 9999999 minvalue 1 nocycle nocache noorder ) primary key,
    name varchar2(20)
);

create table ticket_status(
    id_ticket_status number generated by default as identity
                  (start with 1 maxvalue 9999999 minvalue 1 nocycle nocache noorder ) primary key,
    name varchar2(10)
);

create table specializations(
    id_specialization number generated by default as identity
                 (start with 1 maxvalue 9999999 minvalue 1 nocycle nocache noorder ) primary key,
    name varchar2(30),
    id_age number references ages(id_age),
    id_gender number references genders(id_gender),
    date_delete date
);

create table doctors(
    id_doctor number generated by default as identity
                 (start with 1 maxvalue 9999999 minvalue 1 nocycle nocache noorder ) primary key,
    name varchar2(30),
    last_name varchar2(30),
    patronymic varchar2(30) null,
    id_hospital number references hospitals(id_hospital),
    id_qualification number references qualifications(id_qualification),
    number_area int,
    date_delete date
);

create table doctors_specializations(
    id_doctor number references doctors(id_doctor),
    id_specialization number references specializations(id_specialization)
);

create table accounts(
    id_account number generated by default as identity
                 (start with 1 maxvalue 9999999 minvalue 1 nocycle nocache noorder ) primary key,
    login varchar2(50),
    password varchar2(100)
);

create table patient(
    id_patient number generated by default as identity
                    (start with 1 maxvalue 9999999 minvalue 1 nocycle nocache noorder ) primary key,
    name varchar2(30),
    last_name varchar2(30),
    patronymic varchar2(30) null,
    birth_date date,
    number_area int,
    id_gender number references genders(id_gender),
    id_account number references accounts(id_account),
    number_phone varchar2(15),
    documents varchar2(255)
)


