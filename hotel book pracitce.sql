
use hotel_sales;

select * from hotel_data 
limit 5;

#cancelled bookings
select hotel,count(*) as Total_cancelled_bookings
from hotel_data
where is_canceled = 1
group by hotel ;

#cancelled booking percentage
SELECT
    hotel,
    COUNT(*) AS total_bookings,
    SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) AS cancelled_bookings,
    ROUND(
        SUM(CASE WHEN is_canceled = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate
FROM hotel_data
GROUP BY hotel;

#yearwise total  and cancelled bookings
select hotel ,arrival_date_year, count(*) as total_bookings,
sum(is_canceled) as cancelled_bookings
from hotel_data
group by arrival_date_year,hotel
order by sum(is_canceled) desc;

#Cancellation trend by month
SELECT
    arrival_date_month,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS cancelled_bookings,
    ROUND(SUM(is_canceled)*100.0/COUNT(*),2) AS cancellation_rate
FROM hotel_data
GROUP BY arrival_date_month;

# Do customers who book earlier cancel more?
SELECT
    CASE
        WHEN lead_time <= 30 THEN '0-30 Days'
        WHEN lead_time <= 90 THEN '31-90 Days'
        WHEN lead_time <= 180 THEN '91-180 Days'
        ELSE '180+ Days'
    END AS lead_time_group,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS cancelled_bookings,
    ROUND(SUM(is_canceled)*100.0/COUNT(*),2) AS cancellation_rate
FROM hotel_data
GROUP BY lead_time_group
ORDER BY MIN(lead_time);

#Are repeat guests less likely to cancel?
SELECT
    is_repeated_guest,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS cancelled_bookings,
    ROUND(SUM(is_canceled)*100.0/COUNT(*),2) AS cancellation_rate
FROM hotel_data
GROUP BY is_repeated_guest;

#Which distribution channel has the highest cancellation?
SELECT
    distribution_channel,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS cancelled_bookings,
    ROUND(SUM(is_canceled)*100.0/COUNT(*),2) AS cancellation_rate
FROM hotel_data
GROUP BY distribution_channel
ORDER BY cancellation_rate DESC;

#Do special requests reduce cancellations? #(customers who are making more special requests may be more commited to stay
SELECT
    total_of_special_requests,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS cancelled_bookings,
    ROUND(SUM(is_canceled)*100.0/COUNT(*),2) AS cancellation_rate
FROM hotel_data
GROUP BY total_of_special_requests
ORDER BY total_of_special_requests;

#Average stay of cancelled customers
SELECT
    hotel,
    ROUND(AVG(stays_in_weekend_nights + stays_in_week_nights),2) AS avg_stay
FROM hotel_data
WHERE is_canceled = 1
GROUP BY hotel;

#Cancellation rate withing the market segment
SELECT
    market_segment,
    COUNT(*) AS total_bookings,
    SUM(is_canceled) AS cancelled_bookings,
    ROUND(
        SUM(is_canceled) * 100.0 / COUNT(*),
        2
    ) AS cancellation_rate
FROM hotel_data
GROUP BY market_segment
ORDER BY cancellation_rate DESC;
