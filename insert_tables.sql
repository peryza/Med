--типы больниц
insert into HOSPITAL_TYPES(name)
values ('частная');
insert into HOSPITAL_TYPES(name)
values ('государственная');

--статусы госпиталя
insert into HOSPITAL_STATUS(name)
values ('доступна');
insert into HOSPITAL_STATUS(name)
values ('недоступна');

--регионы
insert into REGIONS(name)
values ('Кемеровская область');
insert into REGIONS(name)
values ('Новосибирская область');
insert into REGIONS(name)
values ('Краснаярский край');
insert into REGIONS(name)
values ('Томская область');
insert into REGIONS(name)
values ('Алтайский край');

--города
insert into TOWNS(NAME , ID_REGION)
values ('Кемерово', 7);
insert into TOWNS(name , id_region)
values ('Новокузнецк', 7);
insert into TOWNS(name , id_region)
values ('Мариинск', 7);
insert into TOWNS(name , id_region)
values ('Новосибирск', 8);
insert into TOWNS(name , id_region)
values ('Бердск', 8);
insert into TOWNS(name , id_region)
values ('Искитимск', 8);
insert into TOWNS(name , id_region)
values ('Красноярск', 9);
insert into TOWNS(name , id_region)
values ('Ачинск', 9);
insert into TOWNS(name , id_region)
values ('Боготол', 9);
insert into TOWNS(name , id_region)
values ('Томск', 10);
insert into TOWNS(name , id_region)
values ('Северск', 10);
insert into TOWNS(name , id_region)
values ('Асино', 10);
insert into TOWNS(name , id_region)
values ('Барнаул', 11);
insert into TOWNS(name , id_region)
values ('Бийск', 11);
insert into TOWNS(name , id_region)
values ('Рубцовск', 11);

--кемеровская область
insert into MEDICAL_ORGANIZATIONS(name, ID_TOWN)
values ('Государственное автономное учреждение здравоохранения', 9);
insert into MEDICAL_ORGANIZATIONS(name, ID_TOWN)
values ('Государственное автономное учреждение здравоохранения', 10);
insert into MEDICAL_ORGANIZATIONS(name, ID_TOWN)
values ('Государственное бюджетное учреждение здравоохранения', 10);
insert into MEDICAL_ORGANIZATIONS(name, ID_TOWN)
values ('Государственное бюджетное учреждение здравоохранения', 11);
--новосибирская область
insert into MEDICAL_ORGANIZATIONS(name, ID_TOWN)
values ('Государственное автономное учреждение здравоохранения', 12);
insert into MEDICAL_ORGANIZATIONS(name, ID_TOWN)
values ('Государственное автономное учреждение здравоохранения', 13);
insert into MEDICAL_ORGANIZATIONS(name, ID_TOWN)
values ('Государственное автономное учреждение здравоохранения', 14);
insert into MEDICAL_ORGANIZATIONS(name, ID_TOWN)
values ('Государственное бюджетное учреждение здравоохранения', 14);
--красноярский край
insert into MEDICAL_ORGANIZATIONS(name, ID_TOWN)
values ('Государственное автономное учреждение здравоохранения', 15);
insert into MEDICAL_ORGANIZATIONS(name, ID_TOWN)
values ('Государственное автономное учреждение здравоохранения', 16);
insert into MEDICAL_ORGANIZATIONS(name, ID_TOWN)
values ('Государственное автономное учреждение здравоохранения', 17);
insert into MEDICAL_ORGANIZATIONS(name, ID_TOWN)
values ('Государственное бюджетное учреждение здравоохранения', 17);
--томская область
insert into MEDICAL_ORGANIZATIONS(name, ID_TOWN)
values ('Государственное автономное учреждение здравоохранения', 18);
insert into MEDICAL_ORGANIZATIONS(name, ID_TOWN)
values ('Государственное автономное учреждение здравоохранения', 19);
insert into MEDICAL_ORGANIZATIONS(name, ID_TOWN)
values ('Государственное автономное учреждение здравоохранения', 20);
insert into MEDICAL_ORGANIZATIONS(name, ID_TOWN)
values ('Государственное бюджетное учреждение здравоохранения', 18);
--алтайский край
insert into MEDICAL_ORGANIZATIONS(name, ID_TOWN)
values ('Государственное автономное учреждение здравоохранения', 21);
insert into MEDICAL_ORGANIZATIONS(name, ID_TOWN)
values ('Государственное автономное учреждение здравоохранения', 22);
insert into MEDICAL_ORGANIZATIONS(name, ID_TOWN)
values ('Государственное автономное учреждение здравоохранения', 23);
insert into MEDICAL_ORGANIZATIONS(name, ID_TOWN)
values ('Государственное бюджетное учреждение здравоохранения', 21);

--графики работы
-- insert into WORK_TIME(start_mon, end_mon, start_tues, end_tues, start_wed, end_wed, start_thurs, end_thurs, start_fri, end_fri, start_sat, end_sat, start_sun, end_sun)
-- values ('9:00','17:00','9:00','17:00','9:00','17:00','9:00','17:00','9:00','15:00',default,default,default,default);
-- insert into WORK_TIME(start_mon, end_mon, start_tues, end_tues, start_wed, end_wed, start_thurs, end_thurs, start_fri, end_fri, start_sat, end_sat, start_sun, end_sun)
-- values ('9:00','17:00','9:00','17:00','9:00','17:00','9:00','17:00','9:00','15:00','9:00','12:00','9:00','12:00');
-- insert into WORK_TIME(start_mon, end_mon, start_tues, end_tues, start_wed, end_wed, start_thurs, end_thurs, start_fri, end_fri, start_sat, end_sat, start_sun, end_sun)
-- values ('9:00','17:00',default,default,'9:00','17:00','9:00','17:00','9:00','15:00',default,default,default,default);

--больницы
insert into HOSPITALS( name, id_medical_organization, id_hospital_type, id_status, date_delete)
values ('Мариинская городская больница имени В.М. Богониса', 5,3,7,default);
insert into HOSPITALS( name, id_medical_organization, id_hospital_type, id_status, date_delete)
values ('Кемеровская стоматологическая поликлиника №3', 2,3,8,default);
insert into HOSPITALS( name, id_medical_organization, id_hospital_type, id_status, date_delete)
values ('Кемеровская городская клиническая больница № 4', 2,3,7,default);
insert into HOSPITALS( name, id_medical_organization, id_hospital_type, id_status, date_delete)
values ('Кемеровская городская детская больница № 1', 2,3,7,default);

--квалификация
insert into QUALIFICATIONS(NAME)
values ('Вторая');
insert into QUALIFICATIONS(NAME)
values ('Первая');
insert into QUALIFICATIONS(NAME)
values ('Высшая');

--возраста
insert into AGES(name, min_age, max_age)
values ('Младенцы',0,1);
insert into AGES(name, min_age, max_age)
values ('Ясельный',1,3);
insert into AGES(name, min_age, max_age)
values ('Ранний дошкольный',3,5);
insert into AGES(name, min_age, max_age)
values ('Школьно-дошколный',6,12);
insert into AGES(name, min_age, max_age)
values ('Подрастковый',12,18);
insert into AGES(name, min_age, max_age)
values ('Взрослый',18,60);
insert into AGES(name, min_age, max_age)
values ('Пожилой',60,90);
insert into AGES(name, min_age, max_age)
values ('Долгожители',90,120);

--пол
insert into GENDERS(NAME)
values ('Мужской');
insert into GENDERS(NAME)
values ('Жениский');
insert into GENDERS(NAME)
values ('Любой');

--специализация
insert into PEROV_VL.SPECIALIZATIONS(name, id_age, date_delete)
values ('Детский хирург',9, default);
insert into PEROV_VL.SPECIALIZATIONS(name, id_age, date_delete)
values ('Взрослый хирург',14, default);
insert into PEROV_VL.SPECIALIZATIONS(name, id_age, date_delete)
values ('Гениколог',14, default);
insert into PEROV_VL.SPECIALIZATIONS(name, id_age, date_delete)
values ('Уролог',14, default);
insert into PEROV_VL.SPECIALIZATIONS(name, id_age, date_delete)
values ('Ноонтолог',9, default);
insert into PEROV_VL.SPECIALIZATIONS(name, id_age, date_delete)
values ('Окулист',14, '20/10/2021');

--специальность и полы
insert into SPECIALIZATIONS_GENDERS(ID_SPECIALIZATION, ID_GENDER)
values (19,1);
insert into PEROV_VL.SPECIALIZATIONS_GENDERS(ID_SPECIALIZATION, ID_GENDER)
values (19,2);
insert into PEROV_VL.SPECIALIZATIONS_GENDERS(ID_SPECIALIZATION, ID_GENDER)
values (20,1);
insert into PEROV_VL.SPECIALIZATIONS_GENDERS(ID_SPECIALIZATION, ID_GENDER)
values (20,2);
insert into PEROV_VL.SPECIALIZATIONS_GENDERS(ID_SPECIALIZATION, ID_GENDER)
values (21,2);
insert into PEROV_VL.SPECIALIZATIONS_GENDERS(ID_SPECIALIZATION, ID_GENDER)
values (22,1);
insert into PEROV_VL.SPECIALIZATIONS_GENDERS(ID_SPECIALIZATION, ID_GENDER)
values (23,1);
insert into PEROV_VL.SPECIALIZATIONS_GENDERS(ID_SPECIALIZATION, ID_GENDER)
values (23,2);
insert into PEROV_VL.SPECIALIZATIONS_GENDERS(ID_SPECIALIZATION, ID_GENDER)
values (24,1);
insert into PEROV_VL.SPECIALIZATIONS_GENDERS(ID_SPECIALIZATION, ID_GENDER)
values (24,2);

--доктора
insert into DOCTORS(name, last_name, patronymic, id_hospital, id_qualification, number_area, date_delete)
values ('Владислав','Петров','Владимирович',1,3,101,default);
insert into DOCTORS(name, last_name, patronymic, id_hospital, id_qualification, number_area, date_delete)
values ('Игнат','Иванов','Владимирович',1,2,101,default);
insert into DOCTORS(name, last_name, patronymic, id_hospital, id_qualification, number_area, date_delete)
values ('Игорь','Ананьев','Иванович',1,1,101,default);

insert into DOCTORS(name, last_name, patronymic, id_hospital, id_qualification, number_area, date_delete)
values ('Иван','Смирнов','Иванович',4,1,202,default);
insert into DOCTORS(name, last_name, patronymic, id_hospital, id_qualification, number_area, date_delete)
values ('Дмитрий','Петров','Степанович',4,2,202,default);
insert into DOCTORS(name, last_name, patronymic, id_hospital, id_qualification, number_area, date_delete)
values ('Максим','Лапин','Петрович',5,2,300,default);

insert into DOCTORS(name, last_name, patronymic, id_hospital, id_qualification, number_area, date_delete)
values ('Марина','Иванова','Викторовна',5,3,300,default);
insert into DOCTORS(name, last_name, patronymic, id_hospital, id_qualification, number_area, date_delete)
values ('Ольга','Богаева',default,5,3,300,default);
insert into DOCTORS(name, last_name, patronymic, id_hospital, id_qualification, number_area, date_delete)
values ('Алина','Еськина',default,5,default,300,default);
insert into DOCTORS(name, last_name, patronymic, id_hospital, id_qualification, number_area, date_delete)
values ('Иван','Абрамов',default,1,default,300,default);

--докто и специальности
insert into DOCTORS_SPECIALIZATIONS(id_doctor, id_specialization)
values (1,19);
insert into DOCTORS_SPECIALIZATIONS(id_doctor, id_specialization)
values (1,20);
insert into DOCTORS_SPECIALIZATIONS(id_doctor, id_specialization)
values (2,20);
insert into DOCTORS_SPECIALIZATIONS(id_doctor, id_specialization)
values (3,20);
insert into DOCTORS_SPECIALIZATIONS(id_doctor, id_specialization)
values (4,21);
insert into DOCTORS_SPECIALIZATIONS(id_doctor, id_specialization)
values (4,22);
insert into DOCTORS_SPECIALIZATIONS(id_doctor, id_specialization)
values (5,22);
insert into DOCTORS_SPECIALIZATIONS(id_doctor, id_specialization)
values (6,22);
insert into DOCTORS_SPECIALIZATIONS(id_doctor, id_specialization)
values (7,23);
insert into DOCTORS_SPECIALIZATIONS(id_doctor, id_specialization)
values (8,24);



--аккаунты
insert into ACCOUNTS(login, password)
values ('peruza','12345678');
insert into ACCOUNTS(login, password)
values ('admin','admin');
insert into ACCOUNTS(login, password)
values ('user123','12345678');

--пациенты
insert into PATIENT(name, last_name, patronymic, birth_date, number_area, id_gender, id_account, number_phone)
values ('Иванов','Иван','Иванович','13/12/1999',101,2,4,'+79994313467');
insert into PATIENT(name, last_name, patronymic, birth_date, number_area, id_gender, id_account, number_phone)
values ('Петр','Петров','Петрович','11/12/1982',101,1,4,'+79955584467');
insert into PATIENT(name, last_name, patronymic, birth_date, number_area, id_gender, id_account, number_phone)
values ('Владимир','Смирнов','Иванович','22/10/1993',101,1,6,'+79666313467');
insert into PATIENT(name, last_name, patronymic, birth_date, number_area, id_gender, id_account, number_phone)
values ('Николай','Николаев','Николаевич','15/09/1965',202,1,6,'+79994333467');
insert into PATIENT(name, last_name, patronymic, birth_date, number_area, id_gender, id_account, number_phone)
values ('Мария','Смирнова','Владировна','17/12/1994',202,2,5,'+79994313457');

--статусы толонов
insert into TICKET_STATUS(NAME)
values ('открыт');
insert into TICKET_STATUS(NAME)
values ('закрыт');

--талоны
insert into TICKETS(id_doctor, id_status, start_date, end_date)
values (1,1,'14/10/2021 13:00:00','14/10/2021 13:30:00');
insert into TICKETS(id_doctor, id_status, start_date, end_date)
values (1,1,'14/10/2021 14:00:00','14/10/2021 14:30:00');
insert into TICKETS(id_doctor, id_status, start_date, end_date)
values (1,1,'14/10/2021 15:00:00','14/10/2021 15:30:00');

insert into TICKETS(id_doctor, id_status, start_date, end_date)
values (2,1,'14/10/2021 13:00:00','14/10/2021 13:30:00');
insert into TICKETS(id_doctor, id_status, start_date, end_date)
values (2,1,'14/10/2021 14:00:00','14/10/2021 14:30:00');
insert into TICKETS(id_doctor, id_status, start_date, end_date)
values (2,1,'14/10/2021 15:00:00','14/10/2021 15:30:00');

insert into TICKETS(id_doctor, id_status, start_date, end_date)
values (3,1,'14/10/2021 13:00:00','14/10/2021 13:30:00');
insert into TICKETS(id_doctor, id_status, start_date, end_date)
values (3,1,'14/10/2021 14:00:00','14/10/2021 14:30:00');
insert into TICKETS(id_doctor, id_status, start_date, end_date)
values (3,1,'14/10/2021 15:00:00','14/10/2021 15:30:00');

insert into TICKETS(id_doctor, id_status, start_date, end_date)
values (4,1,'14/10/2021 13:00:00','14/10/2021 13:30:00');
insert into TICKETS(id_doctor, id_status, start_date, end_date)
values (4,1,'14/10/2021 14:00:00','14/10/2021 14:30:00');
insert into TICKETS(id_doctor, id_status, start_date, end_date)
values (4,1,'14/10/2021 15:00:00','14/10/2021 15:30:00');

insert into RECORD_STATUS(NAME)
values ('действительна');
insert into RECORD_STATUS(NAME)
values ('не действительна');

insert into RECORDS(date_record, id_patient, date_cancellation, id_status, id_ticket)
values ('13/10/2021',17,default,4,10);
insert into RECORDS(date_record, id_patient, date_cancellation, id_status, id_ticket)
values ('13/10/2021',18,default,4,11);
insert into RECORDS(date_record, id_patient, date_cancellation, id_status, id_ticket)
values ('11/10/2021',20,default,4,12);
insert into RECORDS(date_record, id_patient, date_cancellation, id_status, id_ticket)
values ('10/10/2021',21,default,5,13);
insert into RECORDS(date_record, id_patient, date_cancellation, id_status, id_ticket)
values ('10/10/2021',22,default,5,14);

insert into WORK_DAYS(day, begin_time, end_time, id_hospital)
values ('Понедельник',to_date('08:00', 'hh:mi'),to_date('18:00', 'hh24:mi'),4);
insert into WORK_DAYS(day, begin_time, end_time, id_hospital)
values ('Вторник',to_date('08:00', 'hh:mi'),to_date('18:00', 'hh24:mi'),4);
insert into WORK_DAYS(day, begin_time, end_time, id_hospital)
values ('Среда',to_date('08:00', 'hh:mi'),to_date('18:00', 'hh24:mi'),4);
insert into WORK_DAYS(day, begin_time, end_time, id_hospital)
values ('Четверг',to_date('08:00', 'hh:mi'),to_date('18:00', 'hh24:mi'),4);
insert into WORK_DAYS(day, begin_time, end_time, id_hospital)
values ('Пятница',to_date('08:00', 'hh:mi'),to_date('15:00', 'hh24:mi'),4);
insert into WORK_DAYS(day, begin_time, end_time, id_hospital)
values ('Суббота',to_date('01:00', 'hh:mi'),to_date('23:59', 'hh24:mi'),4);
insert into WORK_DAYS(day, begin_time, end_time, id_hospital)
values ('Воскресенье',to_date('01:00', 'hh:mi'),to_date('23:59', 'hh24:mi'),4);

insert into WORK_DAYS(day, begin_time, end_time, id_hospital)
values ('Воскресенье',to_date('01:00', 'hh:mi'),to_date('23:59', 'hh24:mi'),5);


insert into PEROV_VL.RECORDS(DATE_RECORD, ID_PATIENT, DATE_CANCELLATION, ID_STATUS, ID_TICKET)
values