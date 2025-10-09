show databases;
create database insuranceA;
create table insuranceA.person(
driver_id varchar(10),
name char(20),
address varchar(30),
primary key(driver_id)
);
create table insuranceA.car(
reg_num varchar(10),
model varchar(10),
year int,
primary key(reg_num)
);
create table insuranceA.accident(
report_num int,
accident_date date,
location varchar(20),
primary key(report_num)
);
create table insuranceA.owns(
driver_id varchar(10),
reg_num varchar(10),
foreign key(driver_id) references person(driver_id),
FOREIGN KEY(reg_num) references car(reg_num)
ON DELETE CASCADE ON UPDATE CASCADE
);
create table insuranceA.participated(
driver_id varchar(10),
reg_num varchar(10),
report_num int,
damage_amount int,
foreign key(driver_id) references person(driver_id),
FOREIGN KEY(reg_num) references car(reg_num),
FOREIGN KEY(report_num) references accident(report_num)
ON DELETE CASCADE ON UPDATE CASCADE
);
insert into insuranceA.person(driver_id , name , address)
values
("A01","Richard","Srinivas nagar"),
("A02","Pradeep","Rajaji nagar"),
("A03","Smith","Ashok nagar"),
("A04","Venu","N R Colony"),
("A05","Jhon","Hanumanth nagar");
insert into insuranceA.car(reg_num , model , year)
values
("KA052250","Indica","1990"),
("KA031181","Lancer","1957"),
("KA095477","Toyota","1998"),
("KA053408","Honda","2008"),
("KA041702","Audi","2005");
insert into insuranceA.accident(report_num , accident_date , location)
values
("11","2003-01-01","Mysore Road"),
("12","2004-02-02","South end Circle"),
("13","2003-01-21","Bull temple Road"),
("14","2008-02-17","Mysore Road"),
("15","2005-03-04","Kanakpura Road");
insert into insuranceA.owns(driver_id,reg_num)
values
("A01","KA052250"),
("A02","KA053408"),
("A03","KA031181"),
("A04","KA095477"), 
("A05","KA041702");
insert into insuranceA.participated(driver_id,reg_num,report_num,damage_amount)
values
("A01","KA052250",11,10000),
("A02","KA053408",12,50000),
("A03","KA095477",13,25000),
("A04","KA031181",14,3000),
("A05","KA041702",15,5000);
select	* from insuranceA.person;
select	* from insuranceA.car;
select	* from insuranceA.accident;
select	* from insuranceA.owns;
select	* from insuranceA.participated;
select accident_date,location from insuranceA.accident;
select driver_id from insuranceA.participated where damage_amount>=25000;
update insuranceA.participated set damage_amount=25000 where reg_num='KA053408' and report_num=12;
insert into insuranceA.accident values (16,'2008-03-08','Domlur');
update insuranceA.participated set damage_amount=50000 where reg_num='KA053408' and report_num=12;
select * from insuranceA.car order by year asc;
select count(*) from insuranceA.car where model='Lancer';
select count(*) total from insuranceA.accident where accident_date like '2008%';
select * from insuranceA.participated order by damage_amount desc;
select avg(damage_amount) from insuranceA.participated;
delete from insuranceA.participated where damage_amount<(select * from(select avg(damage_amount) from insuranceA.participated) as a);
select name from insuranceA.person p1, insuranceA.participated p2 where p1.driver_id=p2.driver_id and damage_amount>(select * from(select avg(damage_amount) from insuranceA.participated) as a);
select max(damage_amount) from insuranceA.participated; 