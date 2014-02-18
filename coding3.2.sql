/*
person(license_number, name, address)
car(car_regnum, model, year)
accident(report_number, date, location)
owns(license_number, car_regnum)
participated(license_number, car_regnum, report_number, damage_amount)
*/

--1. Number of accidents in which cars belonging to ‘Debayan Gupta’ were involved (I really need to know this). (1)
select count(accident.report_number)
from person, accident, participated
where person.name = 'Debayan Gupta' and 
      person.licens_number = participated.license_number and
      participated.report_number = accident.report_number

--2. Average damage amount for each car model for all accidents that occurred since Jan 1, 2014 sorted from highest to lowest. (3)
select avg_damage_amount
from (
     select avg(t1.damage_amount) as avg_damage_amount, t2.model
     from participated t1
     inner join car t2
     on t2.car_regnum = t1.car_regnum
     where t1.report_number in (select report_number from accident where date > '20140101')
     group by t2.model
     order by avg_damage_amount desc
     )t3

--3. Drivers who were not involved in any accidents since Jan 1, 2014. (2)
select name 
from person
where name not in (
     select person.name
     from person, participated, accident
     where person.license_number = participated.license_number and
     	   participated.report_number = accident.report and 
     	   accident.date > '20140101')

--4. Number of accidents per car model since Jan 1, 2014 (show models with 0 accidents). (4)
select count(t1.report_number) as accidents_per_model, t2.model
from participated t1
join car t2 on t2.car_regnum = t1.car_regnum
join accident t3 on t3.report_number = t1.report_number
where t3.date > '20140101'
group by t2.model
