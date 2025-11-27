drop database employee;
create database employee;
use employee;
create table dept(
deptno int,
dname varchar(30),
dloc varchar(30),
primary key(deptno)
);
create table project(
pno int,
pname varchar(30),
ploc varchar(30),
primary key(pno)
);
create table employee(
empno int,
empname char(30),
mgr_no int,
hire_date date,
sal int,
deptno int,
primary key(empno),
foreign key(deptno) references dept(deptno)
ON DELETE CASCADE ON UPDATE CASCADE
);
create table incentives(
empno int,
incentive_date date,
incentive_amount int,
foreign key(empno) references employee(empno)
ON DELETE CASCADE ON UPDATE CASCADE
);
create table assignedto(
empno int,
pno int,
job_role char(30),
foreign key(empno) references employee(empno),
foreign key(pno) references project(pno)
ON DELETE CASCADE ON UPDATE CASCADE
);
insert into dept(deptno,dname,dloc)
values
(1,'sales','Bengaluru'),
(2,'testing','Bengaluru'),
(3,'design','Hyderabad'),
(4,'effects','Mysuru'),
(5,'coding','Bengaluru');
insert into project(pno,pname,ploc)
values
(1,'FPS game','Bengaluru'),
(2,'AAA game','Hyderabad'),
(3,'Indie game','Hyderabad'),
(4,'MMORPG','Bengaluru'),
(5,'Horror','Mysuru');
insert into employee(empno,empname,mgr_no,hire_date,sal,deptno)
values
(1,'Ankit',3,'2015-01-05',1000,1),
(2,'Avinash',4,'2018-07-15',20000,3),
(3,'Paras',5,'2010-05-24',30000,4),
(4,'Nikil',1,'2017-10-13',15000,5),
(5,'Dinesh',3,'2020-02-08',10000,2);
insert into assignedto(empno,pno,job_role)
values
(1,1,'Head of sales'),
(2,4,'Lead Designer'),
(3,1,'Effects manager'),
(4,2,'Lead Coder'),
(5,2,'Finalized Product Testing');
insert into incentives(empno,incentive_date,incentive_amount)
values
(2,'2019-01-25',5000),
(4,'2018-06-20',8000),
(5,'2020-05-10',2000),
(5,'2020-12-17',4000),
(4,'2018-12-30',7000);
select * from incentives;

select a.empno,p.ploc 
from assignedto a
join project p
on p.pno=a.pno
group by p.ploc,a.empno;

select e.empno
from employee e
where not exists(select i.empno from incentives i where i.empno=e.empno);

-- select e.empname,e.empno,d.dname,a.job_role,d.dloc,p.ploc
-- from dept d
-- join project p
-- on p.ploc=d.dloc
-- join employee e
-- on e.empno;




select distinct mgr_no from employee group by mgr_no having count(empno) = (select max(temp) from (select count(empno) as temp from employee group by mgr_no) as byebye);

