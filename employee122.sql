create database if not exists employee69;
use employee69;
create table dept(dept_no int primary key,dep_name varchar(30),de_loc varchar(20));
cREATE TABLE employee (
    emp_no INT PRIMARY KEY,
    emp_n VARCHAR(20),
    mgr_no INT,
    hiredate DATE,
    salary INT,
    dep_no INT,
    FOREIGN KEY (dep_no) REFERENCES dept(dept_no)
);
CREATE TABLE incentives1 (
    emp_no INT,
    incentive_date DATE,
    incentive_amount INT,
    PRIMARY KEY (emp_no, incentive_date),
    FOREIGN KEY (emp_no) REFERENCES employee(emp_no)
);
CREATE TABLE project (
    pno INT PRIMARY KEY,
    ploc VARCHAR(20),
    pname VARCHAR(20)
);
CREATE TABLE Assigned_to (
    emp_no INT,
    pno INT,
    job_role VARCHAR(20),
    PRIMARY KEY (emp_no, pno),
    FOREIGN KEY (emp_no) REFERENCES employee(emp_no),
    FOREIGN KEY (pno) REFERENCES project(pno)
);
INSERT INTO dept VALUES
(1, 'CSE', 'DELHI'),
(2, 'ECE', 'MUMBAI'),
(3, 'MECH', 'BANGLORE'),
(4, 'CIVIL', 'MYSORE'),
(5, 'IT', 'BIHAR');
insert into employee values
(101, 'Arun', NULL, '2021-03-15', 60000, 1),
(102, 'kashyap', 101, '2022-01-10', 55000, 2),
(103, 'Aryan', 101, '2020-07-22', 65000, 3),
(104, 'David', 102, '2023-05-12', 48000, 4),
(105, 'uday', 103, '2024-09-30', 72000, 5);

INSERT INTO incentives1 VALUES
(101, '2024-01-15', 5000),
(102, '2024-02-10', 3000),
(103, '2024-03-05', 4000),
(104, '2024-04-12', 2500),
(105, '2024-05-20', 6000);

insert into project values
(10, 'Bangalore', 'CyberSecurity'),
(20, 'Hyderabad', 'AI Research'),
(30, 'Chennai', 'Robotics'),
(40, 'Pune', 'WebDev'),
(50, 'Delhi', 'Networking');

INSERT INTO Assigned_to VALUES
(101, 10, 'Manager'),
(102, 20, 'Engineer'),
(103, 30, 'Analyst'),
(104, 40, 'Developer'),
(105, 50, 'Lead');
SELECT a.emp_no
FROM Assigned_to a
JOIN project p ON a.pno = p.pno
WHERE p.ploc IN ('Bangalore', 'Hyderabad', 'Mysuru');

SELECT e.emp_no
FROM employee e
LEFT JOIN incentives1 i ON e.emp_no = i.emp_no
WHERE i.emp_no IS NULL;

SELECT 
    e.emp_no,
    e.emp_n,
    d.dep_name,
    a.job_role,
    d.de_loc AS department_location,
    p.ploc AS project_location
FROM employee e
JOIN dept d ON e.dep_no = d.dept_no
JOIN Assigned_to a ON e.emp_no = a.emp_no
JOIN project p ON a.pno = p.pno
WHERE d.de_loc = p.ploc;

SELECT e.emp_n AS Manager_Name, COUNT(m.emp_no) AS No_of_Employees
FROM employee e
JOIN employee m ON e.emp_no = m.mgr_no
GROUP BY e.emp_no, e.emp_n
HAVING COUNT(m.emp_no) = (
    SELECT MAX(emp_count)
    FROM (
        SELECT COUNT(m1.emp_no) AS emp_count
        FROM employee e1
        JOIN employee m1 ON e1.emp_no = m1.mgr_no
        GROUP BY e1.emp_no
    ) AS sub
);

SELECT 
    m.emp_n AS Manager_Name,
    m.salary AS Manager_Salary,
    AVG(e.salary) AS Avg_Employee_Salary
FROM employee m
JOIN employee e ON m.emp_no = e.mgr_no
GROUP BY m.emp_no, m.emp_n, m.salary
HAVING m.salary > AVG(e.salary);



SELECT 
    d.dep_name,
    e.emp_n AS Second_Level_Manager
FROM employee e
JOIN dept d ON e.dep_no = d.dept_no
WHERE e.mgr_no IN (
    SELECT emp_no FROM employee WHERE mgr_no IS NULL
);



SELECT e.*
FROM employee e
JOIN incentives1 i ON e.emp_no = i.emp_no
WHERE MONTH(i.incentive_date) = 1 AND YEAR(i.incentive_date) = 2019
AND i.incentive_amount = (
    SELECT MAX(incentive_amount)
    FROM incentives1
    WHERE MONTH(incentive_date) = 1 AND YEAR(incentive_date) = 2019
    AND incentive_amount < (
        SELECT MAX(incentive_amount)
        FROM incentives1
        WHERE MONTH(incentive_date) = 1 AND YEAR(incentive_date) = 2019
    )
);


SELECT 
    e.emp_no,
    e.emp_n,
    e.dep_no,
    d.dep_name
FROM employee e
JOIN employee m ON e.mgr_no = m.emp_no
JOIN dept d ON e.dep_no = d.dept_no
WHERE e.dep_no = m.dep_no;




