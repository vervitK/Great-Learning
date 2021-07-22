create database inclass3;
use inclass3;
# Datasets used: AirlineDetails.csv, passengers.csv and senior_citizen.csv
-- -----------------------------------------------------
-- Schema Airlines
-- -----------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------------------------------------
-- 1. Create a table Airline_Details. Follow the instructions given below: 
-- -- Q1. Values in the columns Flight_ID should not be null.
create Table Airline_Details
(Flight_ID int NOT NUll);
-- -- Q2. Each name of the airline should be unique.
Alter Table Airline_Details add column Airline_Name varchar(50) unique not Null; 
-- -- Q3. No country other than United Kingdom, USA, India, Canada and Singapore should be accepted
Alter Table Airline_Details add column Country_Name varchar(20) check (Country_Name in ('United Kingdom', 'USA', 'India', 'Canada','Singapore'));
-- -- Q4. Assign primary key to Flight_ID
Alter Table Airline_details add constraint primary key (Flight_ID);
desc Airline_details;
-- ---------------------------------------------------------------------------------------------------------------------------------------------------

-- 2. Create a table Passengers. Follow the instructions given below: 
-- -- Q1. Values in the columns Traveller_ID and PNR should not be null.
Create Table Passenger_Details
(Traveller_ID varchar(5),
PNR char(6) NOT Null);
-- -- Q2. Only passengers having age greater than 18 are allowed.
Alter table Passenger_Details add column Age int check (age>18);
-- -- Q3. Assign primary key to Traveller_ID
Alter Table Passenger_Details add constraint primary key (Traveller_ID);


-- Questions for table Passengers:  
-- -- Q3. PNR status should be unique and should not be null.
Alter table Passenger_Details modify PNR char(6) unique NOT NULL;
-- -- Q4. Flight Id should not be null.
Alter Table Passenger_Details add column Flight_ID int NOT NULL;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
-- 5. Create a table Senior_Citizen_Details. Follow the instructions given below: 
-- -- Q1. Column Traveller_ID should not contain any null value.
Create Table Senior_Citizen_Details(Traveller_ID varChar(5) NOT NULL);
-- -- Q2. Assign primary key to Traveller_ID
Alter Table Senior_Citizen_Details add constraint primary key (Traveller_ID);
-- -- Q3. Assign foreign key constraint on Traveller_ID such that if any row from passenger table is updated, 
-- -- --  then the Senior_Citizen_Details table should also get updated.
-- -- --  Also deletion of any row from passenger table should not be allowed.

Alter Table Senior_Citizen_Details add foreign key (Traveller_ID) references Passenger_Details(Traveller_ID);

-- ---------------------------------------------------------------------------------------------------------------------------------------------------

-- -----------------------------------------------------
-- Table Senior_Citizen_Details
-- -- Q6. Create a new column Age in Passengers table that takes values greater than 18. 
 Alter Table Senior_Citizen_Details add column Age int check (Age > 18);
 desc Senior_Citizen_Details;
-- ---------------------------------------------------------------------------------------------------------------------------------------------------
-- 7. Create a table books. Follow the instructions given below: 
-- -- Columns: books_no, description, author_name, cost
Create Table Books(
Book_NO int,
Descriptions varchar(50),
Author_Name Varchar(15),
cost int
);
-- -- Qa. The cost should not be less than or equal to 0.
Alter Table Books Modify Cost int check(Cost >0);
-- -- Qb. The cost column should not be null.
Alter Table Books Modify Cost int check(Cost > 0) NOT NULL;
-- -- Qc. Assign a primary key to the column books_no.
Alter Table Books Add Constraint primary Key (Book_NO);
 desc Books;
-- ---------------------------------------------------------------------------------------------------------------------------------------------------
# Q8. Update the table 'books' such that the values in the columns 'description' and author' must be unique.
Alter Table Books modify Descriptions varchar(50) Unique;
Alter Table Books modify Author_Name varchar(15) Unique;

Desc Books;

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
-- 9. Create a table bike_sales. Follow the instructions given below: 
-- -- Columns: id, product, quantity, release_year, release_month
Create Table Bike_Sales(
id  int, 
product varchar(20), 
quantity int, 
release_year int, 
release_month int
);
-- -- Q1. Assign a primary key to ID. Also the id should auto increment.

Alter Table Bike_Sales add constraint primary key (ID);

-- -- Q2. None of the columns should be left null.

Alter Table Bike_Sales Modify id  int NOT NUll;
Alter Table Bike_Sales Modify Product varchar(20) NOT NUll;
Alter Table Bike_Sales Modify quantity int NOT NULL;
Alter Table Bike_Sales Modify release_year int NOT NULL; 
Alter Table Bike_Sales Modify release_month int NOT NULL;

-- -- Q3. The release_month should be between 1 and 12 (including the boundries i.e. 1 and 12).

Alter Table Bike_Sales Modify release_month int check(Release_Month between 1 and 12) NOT NULL;

-- -- Q4. The release_year should be between 2000 and 2010.

Alter Table Bike_Sales Modify release_Year int check(Release_Year between 2000 and 2010) NOT NULL;

-- -- Q5. The quantity should be greater than 0.

Alter Table Bike_Sales Modify Quantity int check(Quantity > 0) NOT NULL;

-- --------------------------------------------------------------------------
-- Use the following comands to insert the values in the table bike_sales
/*('1','Pulsar','1','2001','7');
('2','yamaha','3','2002','3');
('3','Splender','2','2004','5');
('4','KTM','2','2003','1');
('5','Hero','1','2005','9');
('6','Royal Enfield','2','2001','3');
('7','Bullet','1','2005','7');
('8','Revolt RV400','2','2010','7');
('9','Jawa 42','1','2011','5');*/

Insert into Bike_Sales values ('1','Pulsar','1','2001','7');
Insert into Bike_Sales values ('2','yamaha','3','2002','3');
Insert into Bike_Sales values ('3','Splender','2','2004','5');
Insert into Bike_Sales values ('4','KTM','2','2003','1');
Insert into Bike_Sales values ('5','Hero','1','2005','9');
Insert into Bike_Sales values ('6','Royal Enfield','2','2001','3');
Insert into Bike_Sales values ('7','Bullet','1','2005','7');
Insert into Bike_Sales values ('8','Revolt RV400','2','2010','7');
Insert into Bike_Sales values ('9','Jawa 42','1','2011','5');

Select * from Bike_Sales;
-- --------------------------------------------------------------------------



