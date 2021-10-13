insert into HOSPITAL_TYPES(name)
values ('частная');
insert into HOSPITAL_TYPES(name)
values ('государственная');

insert into HOSPITAL_STATUS(name)
values ('доступна');
insert into HOSPITAL_STATUS(name)
values ('недоступна');

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