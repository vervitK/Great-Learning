# Datasets used: employee.csv and membership.csv

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
-- Schema EmpMemb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS EmpMemb;
USE EmpMemb;

-- 1. Create a table Employee by refering the data file given. 
-- -- Follow the instructions given below: 
-- -- Q1. Values in the columns Emp_id and Members_Exclusive_Offers should not be null.
Create Table Employee(
Emp_ID Char(2) NOT NULL,
Members_Exclusive_Offers varchar(3) NOT NULL
);
-- -- Q2. Column Age should contain values greater than or equal to 18.
Alter Table Employee add column Age int check(Age>18);
-- -- Q3. When inserting values in Employee table, if the value of salary column is left null, 
-- --     then a value 20000 should be assigned at that position.
Alter Table Employee add column Salary int default 20000 ; 
-- -- Q4. Assign primary key to Emp_ID
Alter Table Employee add constraint primary key (EMP_ID);
-- -- Q5. All the email ids should not be same.
Alter Table Employee add column Email_ID varchar(50) unique ;
desc Employee;
-- 2. Create a table Membership by refering the data file given. 
-- -- Follow the instructions given below: 
-- -- Q6. Values in the columns Prime_Membership_Active_Status and Employee_Emp_ID should not be null.
Create Table Membership(
Employee_Emp_ID Char(2) ,
Prime_Membership_Active_Status varchar(3)
);

-- -- Q7. Assign a foreign key constraint on Employee_Emp_ID.


Alter Table Membership add foreign key (Employee_EMP_ID) references employee(Emp_ID) ;

-- -- Q8. If any row from employee table is deleted, then the corresponding row from the Membership table should also get deleted.

