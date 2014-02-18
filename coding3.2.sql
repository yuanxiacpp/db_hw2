/*
person(license_number, name, address)
car(car_regnum, model, year)
accident(report_number, date, location)
owns(license_number, car_regnum)
participated(license_number, car_regnum, report_number, damage_amount)
*/

--1. Number of accidents in which cars belonging to ‘Debayan Gupta’ were involved (I really need to know this). (1)
select count(P1.report_number)
from participated as P1
inner join owns as O on O.car_regnum = P1.car_regnum
inner join person as P2 on O.license_number = P2.license_number
where P2.name = 'Debayan Gupta';


--2. Average damage amount for each car model for all accidents that occurred since Jan 1, 2014 sorted from highest to lowest. (3)
select T.model, avg_damage_amount
from (
     select avg(P1.damage_amount) as avg_damage_amount, C.model
     from participated P1
     inner join car as C on C.car_regnum = P1.car_regnum
     where P1.report_number in (select report_number from accident where date > '20140101')
     group by C.model
     order by avg_damage_amount desc
     ) as T;

--3. Drivers who were not involved in any accidents since Jan 1, 2014. (2)
select name 
from person
where name not in (
     select person.name
     from person, participated, accident
     where person.license_number = participated.license_number and
     	   participated.report_number = accident.report_number and 
     	   accident.date > '20140101');

--4. Number of accidents per car model since Jan 1, 2014 (show models with 0 accidents). (4)
select distinct T1.model, coalesce(T2.accidents_count, 0)
from car as T1
left outer join (
     select C.model, count(P.report_number) as accidents_count
     from participated as P
     inner join car as C on C.car_regnum = P.car_regnum
     inner join accident as A on A.report_number = P.report_number
     where A.date > '20140101'
     group by C.model
     ) as T2 on T2.model = T1.model;
