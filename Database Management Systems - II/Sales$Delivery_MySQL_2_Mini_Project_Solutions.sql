CREATE DATABASE mini_project_case_study_sql_2_sales_and_delivery;
USE mini_project_case_study_sql_2_sales_and_delivery;

SELECT * FROM CUST_DIMEN;
SELECT * FROM MARKET_FACT;
SELECT * FROM ORDERS_DIMEN;
SELECT * FROM PROD_DIMEN;
SELECT * FROM SHIPPING_DIMEN;

#1. Join all the tables and create a new table called combined_table.
#(market_fact, cust_dimen, orders_dimen, prod_dimen, shipping_dimen)

DROP TABLE COMBINED_TABLE;
CREATE TABLE COMBINED_TABLE AS
SELECT MF.*, Customer_Name,Province,Region,Customer_Segment,
Product_Category,Product_Sub_Category,
OD.Order_ID,Order_Date,Order_Priority,
Ship_Mode,Ship_Date
FROM MARKET_FACT AS MF INNER JOIN CUST_DIMEN AS CD INNER JOIN 
PROD_DIMEN AS PD INNER JOIN ORDERS_DIMEN AS OD INNER JOIN SHIPPING_DIMEN AS SD
ON MF.CUST_ID = CD.CUST_ID AND MF.ORD_ID = OD.ORD_ID AND MF.PROD_ID = PD.PROD_ID AND MF.SHIP_ID = SD.SHIP_ID;

SELECT * FROM COMBINED_TABLE;

#2. Find the top 3 customers who have the maximum number of orders
WITH ORDERS AS
(
SELECT *,DENSE_RANK() OVER(ORDER BY ORDER_COUNT DESC) AS RANK_ORD FROM 
(
SELECT CUST_ID,COUNT(DISTINCT ORD_ID) AS ORDER_COUNT FROM COMBINED_TABLE GROUP BY CUST_ID ORDER BY COUNT(DISTINCT ORD_ID) DESC
) AS ORD
)
SELECT CUST_ID, ORDER_COUNT FROM ORDERS WHERE RANK_ORD IN (1,2,3);
#3. Create a new column DaysTakenForDelivery that contains the date difference
#of Order_Date and Ship_Date.
ALTER TABLE COMBINED_TABLE ADD COLUMN DAYSTAKENFORDELIVERY INT;
UPDATE COMBINED_TABLE SET DAYSTAKENFORDELIVERY =
DATEDIFF(STR_TO_DATE(SHIP_DATE,'%d-%m-%Y'),STR_TO_DATE(ORDER_DATE,'%d-%m-%Y'));
#4. Find the customer whose order took the maximum time to get delivered.
SELECT * FROM COMBINED_TABLE WHERE DAYSTAKENFORDELIVERY = (SELECT MAX(DAYSTAKENFORDELIVERY) FROM COMBINED_TABLE);
#5. Retrieve total sales made by each product from the data (use Windows
#function)
SELECT DISTINCT PROD_ID,FORMAT(SUM(SALES) OVER(PARTITION BY PROD_ID),2) AS TOTAL_SALES FROM COMBINED_TABLE;
#6. Retrieve total profit made from each product from the data (use windows
#function)
SELECT DISTINCT PROD_ID,FORMAT(SUM(PROFIT) OVER(PARTITION BY PROD_ID),2) AS TOTAL_PROFIT FROM COMBINED_TABLE;
#7. Count the total number of unique customers in January and how many of them
#came back every month over the entire year in 2011
#unique customer count in January:
SELECT COUNT(DISTINCT CUST_ID) AS UNIQUE_CUSTOMER_COUNT 
FROM COMBINED_TABLE WHERE MONTHNAME(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) = 'JANUARY' ;
#Customers who come every month in year 2011 who also visited in January: 
SELECT DISTINCT CUST_ID 
FROM COMBINED_TABLE WHERE MONTHNAME(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) = 'JANUARY' 
AND CUST_ID IN 
(SELECT DISTINCT CUST_ID FROM COMBINED_TABLE WHERE MONTH(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) = 2 AND YEAR(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) = 2011) 
AND CUST_ID IN 
(SELECT DISTINCT CUST_ID FROM COMBINED_TABLE WHERE MONTH(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) = 3 AND YEAR(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) = 2011)
AND CUST_ID IN 
(SELECT DISTINCT CUST_ID FROM COMBINED_TABLE WHERE MONTH(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) = 4 AND YEAR(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) = 2011)
AND CUST_ID IN 
(SELECT DISTINCT CUST_ID FROM COMBINED_TABLE WHERE MONTH(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) = 5 AND YEAR(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) = 2011)
AND CUST_ID IN 
(SELECT DISTINCT CUST_ID FROM COMBINED_TABLE WHERE MONTH(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) = 6 AND YEAR(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) = 2011)
AND CUST_ID IN 
(SELECT DISTINCT CUST_ID FROM COMBINED_TABLE WHERE MONTH(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) = 7 AND YEAR(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) = 2011)
AND CUST_ID IN 
(SELECT DISTINCT CUST_ID FROM COMBINED_TABLE WHERE MONTH(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) = 8 AND YEAR(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) = 2011)
AND CUST_ID IN 
(SELECT DISTINCT CUST_ID FROM COMBINED_TABLE WHERE MONTH(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) = 9 AND YEAR(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) = 2011)
AND CUST_ID IN 
(SELECT DISTINCT CUST_ID FROM COMBINED_TABLE WHERE MONTH(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) = 10 AND YEAR(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) = 2011)
AND CUST_ID IN 
(SELECT DISTINCT CUST_ID FROM COMBINED_TABLE WHERE MONTH(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) = 11 AND YEAR(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) = 2011)
AND CUST_ID IN 
(SELECT DISTINCT CUST_ID FROM COMBINED_TABLE WHERE MONTH(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) = 12 AND YEAR(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) = 2011);

#8. Retrieve month-by-month customer retention rate since the start of the
#business.(using views)
SELECT CUST_ID,MONTH,CUSTOMER_TYPE AS RETENTION_RATE FROM RETENTION_MONTH_WISE;
#####################################################################################################
#Tips:
#1: Create a view where each user???s visits are logged by month, allowing for
#the possibility that these will have occurred over multiple # years since
#whenever business started operations
CREATE VIEW CUSTOMER_VISIT AS
(SELECT DISTINCT CUST_ID,STR_TO_DATE(ORDER_DATE,'%d-%m-%Y') AS ORDER_DATE,
MONTH(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) AS 'MONTH',
YEAR(STR_TO_DATE(ORDER_DATE,'%d-%m-%Y')) AS 'YEAR'
FROM COMBINED_TABLE);
# 2: Identify the time lapse between each visit. So, for each person and for each
#month, we see when the next visit is.
CREATE VIEW TIME_LAPSE AS
WITH CUST_DATE_SORT AS
(
SELECT *,CAST(SUBSTR(CUST_ID,6) AS REAL) AS INT_CUSTOMER FROM CUSTOMER_VISIT ORDER BY INT_CUSTOMER,ORDER_DATE 
)
SELECT *,#LEAD(ORDER_DATE) OVER(PARTITION BY CUST_ID ORDER BY INT_CUSTOMER,ORDER_DATE) AS NEXT_VISIT_DATE,
DATEDIFF(LEAD(ORDER_DATE) OVER(PARTITION BY CUST_ID ORDER BY INT_CUSTOMER,ORDER_DATE),ORDER_DATE) AS NEXT_VISIT_AFTER_DAYS,
#LEAD(MONTH) OVER(PARTITION BY CUST_ID ORDER BY INT_CUSTOMER,ORDER_DATE) AS NEXT_VISIT_MONTH,
CASE WHEN 
YEAR < LEAD(YEAR) OVER(PARTITION BY CUST_ID ORDER BY INT_CUSTOMER,ORDER_DATE) 
THEN 
( (LEAD(YEAR) OVER(PARTITION BY CUST_ID ORDER BY INT_CUSTOMER,ORDER_DATE) - YEAR) * 12 - LEAD(MONTH) OVER(PARTITION BY CUST_ID ORDER BY INT_CUSTOMER,ORDER_DATE) + MONTH)
ELSE
(LEAD(MONTH) OVER(PARTITION BY CUST_ID ORDER BY INT_CUSTOMER,ORDER_DATE) - MONTH)  END AS NEXT_VISIT_AFTER_MONTH
FROM CUST_DATE_SORT;
# 3: Calculate the time gaps between visits
CREATE VIEW TIME_GAPS AS
(
SELECT CUST_ID,ORDER_DATE,MONTH,YEAR,INT_CUSTOMER,
NEXT_VISIT_AFTER_DAYS AS 'TIME_LAPSE(in DAYS)' ,NEXT_VISIT_AFTER_MONTH AS 'TIME_LAPSE(in MONTHS)'
FROM TIME_LAPSE
);
# 4: categorise the customer with time gap 1 as retained, >1 as irregular and
#NULL as churned
SELECT DISTINCT CUST_ID, 
LAST_VALUE(`TIME_LAPSE(in MONTHS)`) OVER(PARTITION BY INT_CUSTOMER) AS 'LAST_VISIT_GAP(in MONTH)',
CASE WHEN LAST_VALUE(`TIME_LAPSE(in MONTHS)`) OVER(PARTITION BY INT_CUSTOMER) IS NULL THEN 'Churned'
WHEN LAST_VALUE(`TIME_LAPSE(in MONTHS)`) OVER(PARTITION BY INT_CUSTOMER) IN (1,0) THEN 'Retained'
WHEN LAST_VALUE(`TIME_LAPSE(in MONTHS)`) OVER(PARTITION BY INT_CUSTOMER) > 1 THEN 'Irregular'
END AS CUSTOMER_TYPE
FROM TIME_GAPS
WHERE `TIME_LAPSE(in MONTHS)` IS NOT NULL;
# 5: calculate the retention month wise
CREATE VIEW RETENTION_MONTH_WISE AS
SELECT *,
CASE WHEN `TIME_LAPSE(in MONTHS)` IS NULL THEN 'Churned'
WHEN `TIME_LAPSE(in MONTHS)` = 1 THEN 'Retained'
WHEN `TIME_LAPSE(in MONTHS)` > 1 THEN 'Irregular'
END AS CUSTOMER_TYPE
FROM TIME_GAPS;

#####################################################################################################
