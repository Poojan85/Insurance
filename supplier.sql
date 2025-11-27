drop database supplier;
create database supplier; 
use supplier;
create table Supplier( 
sid int primary 
key, sname 
varchar(35),
city varchar(35)
);
create table parts(
pid int primary key, pname 
varchar(35), 
color varchar(35)
);
create table catalog( 
sid int,
pid int, 
cost float,
primary key(sid,pid),
foreign key(sid) references Supplier(sid), 
foreign key(pid) references parts(pid)
);
desc supplier;
desc parts;
desc catalog;
insert into Supplier values (10001,"Acme
Widget","Bangalore"), (10002,"Johns","Kolkata"), (10003,"Vimal","Mumbai"), 
(10004,"Reliance","Delhi" );
Select * from Supplier;
insert into parts values (20001,"Book","Red"), (20002,"Pen","Red"), (20003,"Pencil","Green"),
(20004,"Mobile","Green"), (20005,"Charger","Black");
Select * from parts;
insert into catalog values 
(10001,20001,10), (10001,20002,10), (10001,20003,30), (10001,20004,10),
(10001,20005,10), (10002,20001,10), (10002,20002,20), (10003,20003,30), (10004,20003,40);
Select * from catalog;

select distinct pname from parts p,catalog c where p.pid=c.pid;

select sname from Supplier where sid in(select sid from catalog c group by sid having 
count(pid)=(select count(pid) from parts));

select distinct sname from Supplier s,catalog c where s.sid=c.sid and pid in(select pid from
parts where color="red"); 

select pname from parts p,supplier s where pid in(select pid from catalog group by pid having 
count(pid)=1) and s.sname="Acme Widget";

create view c as select c.pid,p.pname,avg(cost) as co from catalog c,parts p where c.pid=p.pid 
group by c.pid; select ca.sid from catalog ca,c where ca.pid=c.pid and ca.cost>c.co and 
c.pid=ca.pid; 

select sname,co.pid,pname,cost from Supplier s,parts po,catalog co where co.pid=po.pid and 
s.sid=co.sid and co.cost = (select max(cost) from catalog where pid=po.pid) ;

-- additional queries

SELECT p.pid, p.pname, c.sid, s.sname, c.cost
FROM parts p
JOIN catalog c ON p.pid = c.pid
JOIN supplier s ON c.sid = s.sid
WHERE c.cost = (
    SELECT MAX(cost) FROM catalog
);

SELECT s.sid, s.sname
FROM supplier s
WHERE s.sid NOT IN (
    SELECT c.sid
    FROM catalog c
    JOIN parts p ON c.pid = p.pid
    WHERE p.color = 'Red'
);

SELECT s.sid, s.sname, SUM(c.cost) AS total_value
FROM supplier s
JOIN catalog c ON c.sid = s.sid
GROUP BY s.sid, s.sname;

SELECT s.sid, s.sname
FROM supplier s
JOIN catalog c ON c.sid = s.sid
WHERE c.cost < 20
GROUP BY s.sid, s.sname
HAVING COUNT(DISTINCT c.pid) >= 2;

SELECT p.pid, p.pname, s.sid, s.sname, c.cost
FROM catalog c
JOIN parts p ON p.pid = c.pid
JOIN supplier s ON s.sid = c.sid
JOIN (
    SELECT pid, MIN(cost) AS min_cost
    FROM catalog
    GROUP BY pid
) m ON m.pid = c.pid AND m.min_cost = c.cost
ORDER BY p.pid, c.cost, s.sid;

CREATE OR REPLACE VIEW supplier_part_count AS
SELECT s.sid, s.sname, COUNT(DISTINCT c.pid) AS part_count
FROM supplier s
JOIN catalog c ON c.sid = s.sid
GROUP BY s.sid, s.sname; SELECT * from supplier_part_count;

CREATE OR REPLACE VIEW most_expensive_supplier_per_part AS
SELECT p.pid, p.pname, s.sid, s.sname, c.cost
FROM catalog c
JOIN parts p ON p.pid = c.pid
JOIN supplier s ON s.sid = c.sid
JOIN (
    SELECT pid, MAX(cost) AS max_cost
    FROM catalog
    GROUP BY pid
) mx ON mx.pid = c.pid AND mx.max_cost = c.cost
ORDER BY p.pid, c.cost DESC, s.sid; SELECT * FROM most_expensive_supplier_per_part;

DELIMITER //

CREATE TRIGGER trg_catalog_prevent_low_cost
BEFORE INSERT ON catalog
FOR EACH ROW
BEGIN
    IF NEW.cost < 1 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cost must be at least 1';
    END IF;
END//

DELIMITER ;

DELIMITER //

CREATE TRIGGER trg_catalog_default_cost
BEFORE INSERT ON catalog
FOR EACH ROW
BEGIN
    IF NEW.cost IS NULL THEN
        SET NEW.cost = 100; -- choose any default you prefer
    END IF;
END//

DELIMITER ;