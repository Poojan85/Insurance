create database bank;
use bank;
create table branch(
branch_name varchar(30),
branch_city char(20) NOT NULL,
assets real NOT NULL,
primary key(branch_name)
);
create table BankAccount(
accno int,
branch_name varchar(30) NOT NULL,
balance real NOT NULL,
primary key(accno),
foreign key(branch_name) references branch(branch_name)
ON DELETE CASCADE ON UPDATE CASCADE
);
create table BankCustomer(
customer_name varchar(30),
customer_street varchar(30) NOT NULL,
customer_city varchar(30) NOT NULL,
primary key(customer_name)
);
create table depositer(
customer_name varchar(30),
accno int NOT NULL,
primary key(accno),
foreign key(customer_name) references BankCustomer(customer_name),
foreign key(accno) references BankAccount(accno)
ON DELETE CASCADE ON UPDATE CASCADE
);
create table loan(
loan_number int,
branch_name varchar(30) NOT NULL,
amount real NOT NULL,
primary key(branch_name),
foreign key(branch_name) references branch(branch_name)
ON DELETE CASCADE ON UPDATE CASCADE
);
insert into branch(branch_name,branch_city,assets)
values
('SBI_Chamrajpet','Bangalore',50000),
('SBI_RecidencyRoad','Bangalore',10000),
('SBI_ShivajiRoad','Bombay',20000),
('SBI_ParlimentRoad','Delhi',10000),
('SBI_Jantarmantar','Delhi',20000);
insert into bankaccount(accno,branch_name,balance)
values
(1,'SBI_Chamrajpet',2000),
(2,'SBI_RecidencyRoad',5000),
(3,'SBI_ShivajiRoad',6000),
(4,'SBI_ParlimentRoad',9000),
(5,'SBI_Jantarmantar',8000),
(6,'SBI_ShivajiRoad',4000),
(8,'SBI_RecidencyRoad',4000),
(9,'SBI_ParlimentRoad',3000),
(10,'SBI_RecidencyRoad',5000),
(11,'SBI_Jantarmantar',2000);
insert into bankcustomer(customer_name,customer_street,customer_city)
values
('Avinash','Bull_Temple_Road','Bangalore'),
('Dinesh','Bannergatta_Road','Bangalore'),
('Mohan','NationalCollege_Road','Bangalore'),
('Nikil','Akbar_Road','Delhi'),
('Ravi','Prithviraj_Road','Delhi');
insert into depositer(customer_name,accno)
values
('Avinash',1),
('Dinesh',2),
('Nikil',4),
('Ravi',5),
('Avinash',8),
('Nikil',9),
('Dinesh',10),
('Nikil',11);
insert into loan(loan_number,branch_name,amount)
values
(1,'SBI_Chamrajpet',1000),
(2,'SBI_RecidencyRoad',2000),
(3,'SBI_ShivajiRoad',3000),
(4,'SBI_ParlimentRoad',4000),
(5,'SBI_Jantarmantar',5000);
select branch_name,assets as assets_in_lakhs from branch;
SELECT
    d.customer_name,
    b.branch_name,
    COUNT(d.accno) AS total_accounts
FROM depositer d
JOIN bankaccount b
    ON d.accno = b.accno
GROUP BY
    d.customer_name,
    b.branch_name
HAVING
    COUNT(d.accno) >= 2;
create view total_loan
as select branch_name,sum(amount) as total_loan from loan group by branch_name;
select * from total_loan;