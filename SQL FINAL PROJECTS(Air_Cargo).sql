USE air_cargo;
show tables

-- Q1) Write a query to create route_details table using suitable data types for the fields, 
-- such as route_id, flight_num, origin_airport, destination_airport, aircraft_id, and distance_miles. 
-- Implement the check constraint for the flight number and unique constraint for the route_id fields. Also, make sure 
-- that the distance miles field is greater than 0.


SELECT * FROM routes;
DESCRIBE routes

ALTER TABLE routes
MODIFY flight_num int NOT NULL;

ALTER TABLE routes
ADD CHECK (flight_num > 1),
ADD CHECK (distance_miles > 0);

SELECT *
FROM routes
WHERE distance_miles <0;

-- Q2) Write a query to display all the passengers (customers) who have travelled
-- in routes 01 to 25. Take data  from the passengers_on_flights table.

SELECT first_name,last_name,route_id,travel_date
FROM passengers_on_flights p 
JOIN customer c 
ON p.customer_id = c.customer_id
WHERE route_id BETWEEN 01 AND 25 ;

-- Q3) Write a query to identify the number of passengers and total revenue in business 
-- class from the ticket_details table.

SELECT SUM(no_of_tickets) AS no_of_passangers,
SUM(Price_per_ticket * no_of_tickets) AS total_revenue
FROM ticket_details
WHERE class_id LIKE 'Bussiness';

-- Q4) Write a query to display the full name of the customer by extracting the 
-- first name and last name from the customer table.

SELECT customer_id,
CONCAT(first_name ," ",last_name) AS customer_full_name
FROM customer;

-- Q5) Write a query to extract the customers who have registered and booked a ticket.
-- Use data from the customer and ticket_details tables.

SELECT first_name , last_name , no_of_tickets
FROM customer c 
JOIN ticket_details t 
ON c.customer_id = t.customer_id 
WHERE p_date != 0 AND no_of_tickets != 0 ;

-- Q6) Write a query to identify the customer’s first name and last name based on 
-- their customer ID and brand (Emirates) from the ticket_details table.

SELECT first_name , last_name , t.customer_id
FROM ticket_details t 
JOIN customer c 
ON t.customer_id = c.customer_id
WHERE brand LIKE 'Emirates';


-- Q7) Write a query to identify the customers who have travelled by Economy Plus 
-- class using Group By and Having clause on the passengers_on_flights table.

SELECT  c.customer_id, first_name , last_name , class_id
FROM passengers_on_flights p 
JOIN customer c 
ON p.customer_id = c.customer_id 
GROUP BY first_name , last_name , c.customer_id, class_id
HAVING class_id LIKE 'Economy Plus';


-- Q8) Write a query to identify whether the revenue has crossed 10000 
-- using the IF clause on the ticket_details table 

SELECT SUM(Price_per_ticket * no_of_tickets) AS total_revenue,
IF(SUM(Price_per_ticket * no_of_tickets) >10000 ,'Crossed','Not Crossed') AS Status
FROM ticket_details;


-- Q9) Write a query to create and grant access to a new user to 
-- perform operations on a database.

CREATE USER 'new_user'@'localhost' IDENTIFIED BY 'password';
GRANT SELECT, INSERT, UPDATE, DELETE ON customer TO 'new_user'@'localhost';

-- Q10) Write a query to find the maximum ticket price for each class using window functions 
-- on the ticket_details table.

WITH cte1 AS (
     SELECT brand , class_id , Price_per_ticket,
     RANK() OVER(PARTITION BY class_id ORDER BY Price_per_ticket DESC) AS 'ticket_rank'
	 FROM ticket_details
)

SELECT * 
FROM cte1
WHERE ticket_rank = 1

-- Q11) Write a query to extract the passengers whose route ID is 4 by improving 
-- the speed and performance of the passengers_on_flights table

SELECT c.customer_id , first_name , last_name , route_id
FROM passengers_on_flights p
JOIN customer c
ON c.customer_id = p.customer_id 
WHERE route_id = 4

-- Q12)  For the route ID 4, write a query to view the execution plan of 
-- the passengers_on_flights table.

SELECT aircraft_id , depart , arrival , travel_date , flight_num
FROM passengers_on_flights
WHERE route_id = 4

-- Q13) Write a query to calculate the total price of all tickets booked by
--  a customer across different aircraft IDs using rollup function.

SELECT aircraft_id , brand, SUM(Price_per_ticket) AS total_revenue
FROM ticket_details
GROUP BY brand ,aircraft_id with rollup

-- Q14) Write a query to create a view with only business class customers 
-- along with the brand of airlines.

SELECT c.first_name , c.last_name ,t.brand 
FROM ticket_details t
JOIN customer c 
ON c.customer_id = t.customer_id
WHERE class_id LIKE 'Bussiness'

-- Q15) Write a query to create a stored procedure to get the details of all passengers flying 
-- between a range of routes defined in run time. Also, return an error message if the table doesn't exist.

CALL find_routes(30 , 40)

-- Q16) Write a query to create a stored procedure that extracts all the details from the routes table
--  where the travelled distance is more than 2000 miles.

CALL more_than_2000
     
-- Q17) Write a query to create a stored procedure that groups the distance travelled by each flight into three categories. The categories are, 
-- short distance travel (SDT) for >=0 AND <= 2000 miles, intermediate distance travel (IDT) for >2000 AND <=6500,
-- and long-distance travel (LDT) for >6500.

CALL distance_groups

-- Q18) Write a query to extract ticket purchase date, customer ID, class ID and specify if the complimentary services are provided
-- for the specific class using a stored function in stored procedure on the ticket_details table.

-- UPDATE ticket_details
-- SET p_date = DATE_FORMAT(STR_TO_DATE(p_date, '%d-%m-%Y'),'%Y-%m-%d')

CALL compliment 










