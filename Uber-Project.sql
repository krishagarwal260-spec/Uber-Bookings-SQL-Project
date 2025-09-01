create database uber;
use uber;
alter table booking rename to bookings;
select * from bookings;

-- Q.1 Retrieve all successful bookings -
create view Successful_ride as
select * from bookings
where Booking_Status = "Success";
select * from Successful_ride;


-- Q.2 Find the average ride distance for each vehicle type  -
create view avg_ride_distance as
select Vehicle_type , avg(Ride_Distance)
from bookings
group by Vehicle_type;
 select * from avg_ride_distance;



-- Q.3 Get the total number of cancelled rides by customer -
create view cancelled_rides_by_customer as 
select count(*) from bookings
where Booking_Status = "Cancelled by Customer";
select * from cancelled_rides_by_customer;

-- Q.4 list the top 5 customers who booked the highest number of ride -
create view Customers_highest_number_of_ride as
select Customer_ID , count(BookingID) as total_rides
from bookings
group by Customer_ID
order by total_rides desc 
limit 5;
select * from Customers_highest_number_of_ride;

-- Q.5 Get the number of rides cancelled by drivers due to personal and car-related issues -
create view rides_cancelled_by_drivers as
select count(*) from bookings
where Reason_for_canceling_by_Driver = "Personal & Car related issue";
select * from rides_cancelled_by_drivers;

-- Q.6 find the maximum and minimum driver ratings for prime sedan bookings;
create view max_min_driver_ratings as
select max(Driver_Ratings) , min(Driver_Ratings)
from bookings
where Vehicle_Type = 'Prime Sedan';
select * from max_min_driver_ratings;

-- Q.7 Retrieve all rides where payment was made using upi -
create view All_UPI_RIDES as
select BookingID from bookings
where Payment_Method = 'upi';
select * from All_UPI_RIDES;


-- Q.8 find the average customer rating per vehicle type -
create view avg_cust_rating_per_vehicle_type as 
select Vehicle_type, avg(CustomerRating) as C_Rating
from bookings
group by Vehicle_type;
select * from avg_cust_rating_per_vehicle_type;

-- Q.9 calculate the total booking value of rides completed successfully -
create view Total_booking_value_of_successful_rides as
select count(Booking_Value)
from bookings
where Booking_Status = "Success";
select * from Total_booking_value_of_successful_rides;

-- Q.10 list all incomplete rides along with the reason-  
create view all_incomplete_rides as
select BookingID, Reason_for_canceling_by_Customer,Reason_for_canceling_by_Driver
from bookings 
where Booking_Status = "incomplete";
select * from all_incomplete_rides; 


-- Q.11  Rank Customers by Total Booking Value (Window Function)
create view Rank_Customers_by_Total_Booking_Value as
SELECT 
    Customer_ID,
    SUM(Booking_Value) AS Total_Value,
    RANK() OVER (ORDER BY SUM(Booking_Value) DESC) AS Customer_Rank
FROM bookings
WHERE Booking_Status = 'Success'
GROUP BY Customer_ID;
select * from Rank_Customers_by_Total_Booking_Value;

-- Q.12 Find Top 5 Longest Rides for Each Vehicle Type (Window Function)
create view top_5_longest_rides_for_each_vehicle_type as 
SELECT *
FROM (
    SELECT 
        Vehicle_Type,
        BookingID,
        Ride_Distance,
        ROW_NUMBER() OVER (PARTITION BY Vehicle_Type ORDER BY Ride_Distance DESC) AS RideRank
    FROM bookings
    WHERE Booking_Status = 'Success'
) AS t
WHERE RideRank <= 5;
select * from top_5_longest_rides_for_each_vehicle_type;

--  Q.13 Find Average Driver Rating per Vehicle Type (Subquery)
create view Find_average_driver_rating_per_vehicle_type as
SELECT Vehicle_Type, Avg_Rating
FROM (
    SELECT Vehicle_Type, AVG(Driver_Ratings) AS Avg_Rating
    FROM bookings
    WHERE Booking_Status = 'Success'
    GROUP BY Vehicle_Type
) AS t
ORDER BY Avg_Rating DESC;
select * from Find_average_driver_rating_per_vehicle_type;

-- Q.14 Find Customers Who Have Above-Average Rating (Subquery)
create view Customers_Who_Have_Above_Average_Rating as 
SELECT Customer_ID, AVG(CustomerRating) AS Cust_Avg_Rating
FROM bookings
WHERE CustomerRating IS NOT NULL
GROUP BY Customer_ID
HAVING AVG(CustomerRating) > (
    SELECT AVG(CustomerRating) FROM bookings WHERE CustomerRating IS NOT NULL);
select * from  Customers_Who_Have_Above_Average_Rating ;


 


   











