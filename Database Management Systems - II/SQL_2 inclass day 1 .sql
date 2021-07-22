# Dataset used: titanic_ds.csv
# Use subqueries for every question
use titanic;
#Q1. Display the first_name, last_name, passenger_no , fare of the passenger who paid less than the  maximum fare. (20 Row)
select first_name, last_name, passenger_no , fare  from download where fare < (select max(fare) from download) ;

#Q2. Retrieve the first_name, last_name and fare details of those passengers who paid fare greater than average fare. (11 Rows)
select first_name, last_name , fare from download where fare > (select avg(fare) from download);

#Q3. Display the first_name ,sex, age, fare and deck_number of the passenger equals to passenger number 7 but exclude passenger number 7.(3 Rows)
select first_name ,sex, age, fare , deck_number from download where (SEX,deck_number) IN (select sex,deck_number from download where passenger_no=7) and passenger_no<>7;

select * from download;
#Q4. Display first_name,embark_town where deck is equals to the deck of embark town ends with word 'town' (7 Rows)
select first_name,embark_town from download where deck in (select deck from download where embark_town like '%town' );

select deck_number from download where embark_town like '%town';
# Dataset used: youtube_11.csv
use youtube__;


#Q5. Display the video Id and the number of likes of the video that has got less likes than maximum likes(10 Rows)
select Video_id,Likes from youtube where likes < (select max(likes) from youtube );

#Q6. Write a query to print video_id and channel_title where trending_date is equals to the trending_date of  category_id 1(5 Rows)
select video_id , channel_title from youtube where trending_date = (select trending_date from youtube where category_id =1);


#Q7. Write a query to display the publish date, trending date ,views and description where views are more than views of Channel 'vox'.(7 Rows))
select publish_date, trending_date ,views , Description from youtube where views >(select views from youtube where Channel_title = 'vox');


#Q8. Write a query to display the channel_title, publish_date and the trending_date having category id in between 9 to Maximum category id .
# Do not use Max function(3 Rows)
select channel_title, publish_date,trending_date 
from youtube where category_id between 9 and (select * from youtube where category_id > 9 );

select * from youtube where category_id > 9 , order by category_id,  limit 1 ;
#Q9. Write a query to display channel_title, video_id and number of view of the video that has received more than  mininum views. (10 Rows)


# Database used: db1 (db1.sql file provided)
use Inclass;

#Q10. Get those order details whose amount is greater than 100,000 and got cancelled(1 Row))
select * from ;


#Q11. Get employee details who shipped an order within a time span of two days from order date (15 Rows)
select * from orders where status = 'cancelled' and customer

#Q12. Get product name , product line , product vendor of products that got cancelled(53 Rows)
select productname , productline , productvendor 
from products 
where productcode =
any(select productNumber from orderdeatails where ordernumber =
any(select orderNumber from orders where status = 'Cancelled'));

#Q13. Get customer full name along with phone number ,address , state, country, who's order was resolved(4 Rows)
select concat(contactfirstname,'',contactlastname) name ,addressline1, coalesce(addressline1,city,state) , state,country, phone from customers where customernumber = any(select customernumber from orders where status = 'resolved');
select * from customers;


#Q14. Display those customers who ordered product of price greater than average price of all products(98 Rows)
select customernumber from customers where customernumber in (select customernumber from orders where ordernumber = any 
(select productcode from products where buyprice > 
(select avg(buyprice) from products)));
 
 

select * from customers where customernumber in 
(select customernumber from orders where ordernumber in 
(select ordernumber from orderdetails where productCode in 
(select produtcode from products where buyprice > 
(select avg(buyprice) from products))));


#Q15. Get office deatils of employees who work in the same city where their customers reside(5 Rows)
select * from offices where city = any(select city from customers);

