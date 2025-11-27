create database supplier;
use supplier;
create table supplier(
sid int,
sname char(30),
city char(30),
PRIMARY KEY(sid)
);
create table parts(
pid int,
pname char(30),
color char(10),
PRIMARY KEY(pid)
);
create table catalog(
sid int,
pid int,
cost double,
FOREIGN KEY(sid) REFERENCES supplier(sid),
FOREIGN KEY(pid) REFERENCES parts(pid)
ON DELETE CASCADE ON UPDATE CASCADE
);
insert into supplier(sid,sname,city)
values
(1,'Acme Widget Supplier','Delhi'),
(2,'Best Parts Co','Mumbai'),
(3,'Quality Supplies','Chennai'),
(4,'Global Industrial','Kolkata'),
(5,'Mega Hardware Ltd','Bangalore');
insert into parts(pid,pname,color)
values
(101,'Bolt','Red'),
(102,'Nut','Blue'),
(103,'Screw','Red'),
(104,'Washer','Green'),
(105,'Gear','Red'),
(106,'Bearing','Black');
insert into catalog(sid,pid,cost)
values
(1,101,10.00),
(1,102,15.00),
(1,103,25.00),
(2,101,12.00),
(2,103,22.00),
(2,106,30.00),
(3,101,11.00),
(3,102,14.00),
(3,104,25.00),
(4,102,16.00),
(4,103,26.00),
(4,105,42.00),
(5,101,13.00),
(5,104,19.00),
(5,106,32.00);
select pname from parts where pid in (select distinct pid from catalog);
select sname from supplier where sid in(select distinct sid from catalog group by sid having count(pid)=(select count(*) from parts));
SELECT s.sname
FROM Supplier s
WHERE NOT EXISTS (
  SELECT *
  FROM Parts p
  WHERE p.color = 'Red'
    AND NOT EXISTS (
      SELECT *
      FROM Catalog c
      WHERE c.sid = s.sid AND c.pid = p.pid
    )
); 
SELECT p.pname
FROM Parts p
JOIN Catalog c1 ON c1.pid = p.pid
JOIN Supplier s ON s.sid = c1.sid
WHERE s.sname = 'Acme Widget Suppliers'
  AND NOT EXISTS (
    SELECT *
    FROM Catalog c2
    WHERE c2.pid = p.pid AND c2.sid = c1.sid
  );
SELECT DISTINCT c.sid
FROM Catalog c
WHERE c.cost > (
  SELECT AVG(c2.cost)
  FROM Catalog c2
  WHERE c2.pid = c.pid
);
select distinct p.pname,s.sname from parts p 
join catalog c on p.pid=c.pid
join supplier s on c.sid=s.sid
where c.cost =(select max(c1.cost) from catalog c1 where c1.pid=p.pid); 