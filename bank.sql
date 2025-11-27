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
