SELECT
     ROUND(
          SUM(CASE WHEN status = 'completed successfully' 
                        AND actual_delivery_timestamp > estimated_delivery_timestamp THEN 1
                   WHEN status = 'completed incorrectly' 
                        OR status = 'never received' THEN 1 ELSE 0 END)*100.0/COUNT(*),2)
FROM orders O
JOIN 
     trips T ON O.trip_id = T.trip_id
JOIN 
     customers C ON C.customer_id = O.customer_id
WHERE 
     DATE(signup_timestamp) + 14 >= DATE(order_timestamp) 
     AND 
     EXTRACT(MONTH FROM signup_timestamp) = 6