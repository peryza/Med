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