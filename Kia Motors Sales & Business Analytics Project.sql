#questions

#Customer Analysis

#1. Find the total number of customers.
SELECT COUNT(*) AS total_customers
FROM Customers;


#2. Find the number of customers from each city.
SELECT city,
       COUNT(customer_id) AS total_customers
FROM Customers
GROUP BY city;


#3. Find the top 10 customers based on total purchase amount.
SELECT c.customer_name,
       SUM(s.sale_amount) AS total_purchase_amount
FROM Customers c
JOIN Sales s
ON c.customer_id = s.customer_id
WHERE s.sale_status = 'Completed'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_purchase_amount DESC
LIMIT 10;


#4. Find customers who have purchased more than one vehicle.
SELECT c.customer_name,
       COUNT(s.vehicle_id) AS total_vehicles
FROM Customers c
JOIN Sales s
ON c.customer_id = s.customer_id
WHERE s.sale_status = 'Completed'
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(s.vehicle_id) > 1;


#5. Find customers who have never purchased a vehicle.
SELECT c.customer_name
FROM Customers c
LEFT JOIN Sales s
ON c.customer_id = s.customer_id
AND s.sale_status = 'Completed'
WHERE s.sale_id IS NULL;


#6. Find the average purchase amount for each customer.
SELECT c.customer_name,
       AVG(s.sale_amount) AS average_purchase_amount
FROM Customers c
JOIN Sales s
ON c.customer_id = s.customer_id
WHERE s.sale_status = 'Completed'
GROUP BY c.customer_id, c.customer_name;


#7. Find the customer who spent the highest amount.
SELECT c.customer_name,
       SUM(s.sale_amount) AS total_spending
FROM Customers c
JOIN Sales s
ON c.customer_id = s.customer_id
WHERE s.sale_status = 'Completed'
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spending DESC
LIMIT 1;


#8. Find customers who purchased a vehicle in 2026.
SELECT DISTINCT c.customer_name
FROM Customers c
JOIN Sales s
ON c.customer_id = s.customer_id
WHERE YEAR(s.sale_date) = 2026
AND s.sale_status = 'Completed';


#9. Find customers whose purchase amount is greater than the average purchase amount.
SELECT c.customer_name,
       s.sale_amount AS purchase_amount
FROM Customers c
JOIN Sales s
ON c.customer_id = s.customer_id
WHERE s.sale_status = 'Completed'
AND s.sale_amount > (
    SELECT AVG(sale_amount)
    FROM Sales
    WHERE sale_status = 'Completed'
);

#10. Find the number of customers in each state.
SELECT state,
       COUNT(customer_id) AS total_customers
FROM Customers
GROUP BY state;

#Vehicle Analysis

#11. Find the total number of vehicle models.
SELECT COUNT(*) AS total_vehicle_models
FROM Vehicle_Models;


#12. Find the number of vehicles available for each model.
SELECT vm.model_name,
       COUNT(v.vehicle_id) AS total_vehicles
FROM Vehicle_Models vm
LEFT JOIN Vehicles v
ON vm.model_id = v.model_id
AND v.availability_status = 'Available'
GROUP BY vm.model_id, vm.model_name;


#13. Find the top 10 vehicle models based on sales.
SELECT vm.model_name,
       SUM(sd.quantity) AS total_sales
FROM Vehicle_Models vm
JOIN Sales_Details sd
ON vm.model_id = sd.model_id
JOIN Sales s
ON sd.sale_id = s.sale_id
WHERE s.sale_status = 'Completed'
GROUP BY vm.model_id, vm.model_name
ORDER BY total_sales DESC
LIMIT 10;


#14. Find the most expensive vehicle model.
SELECT model_name,
       base_price
FROM Vehicle_Models
ORDER BY base_price DESC
LIMIT 1;


#15. Find the least expensive vehicle model.
SELECT model_name,
       base_price
FROM Vehicle_Models
ORDER BY base_price ASC
LIMIT 1;


#16. Find vehicles that have never been sold.
SELECT v.registration_number,
       vm.model_name
FROM Vehicles v
JOIN Vehicle_Models vm
ON v.model_id = vm.model_id
LEFT JOIN Sales s
ON v.vehicle_id = s.vehicle_id
AND s.sale_status = 'Completed'
WHERE s.sale_id IS NULL;


#17. Find the average selling price of each vehicle model.
SELECT vm.model_name,
       AVG(sd.selling_price) AS average_selling_price
FROM Vehicle_Models vm
JOIN Sales_Details sd
ON vm.model_id = sd.model_id
JOIN Sales s
ON sd.sale_id = s.sale_id
WHERE s.sale_status = 'Completed'
GROUP BY vm.model_id, vm.model_name;


#18. Find the vehicle model generating the highest revenue.
SELECT vm.model_name,
       SUM(sd.selling_price * sd.quantity) AS total_revenue
FROM Vehicle_Models vm
JOIN Sales_Details sd
ON vm.model_id = sd.model_id
JOIN Sales s
ON sd.sale_id = s.sale_id
WHERE s.sale_status = 'Completed'
GROUP BY vm.model_id, vm.model_name
ORDER BY total_revenue DESC
LIMIT 1;


#19. Find the number of vehicles sold in each fuel type.
SELECT vm.fuel_type,
       SUM(sd.quantity) AS vehicles_sold
FROM Vehicle_Models vm
JOIN Sales_Details sd
ON vm.model_id = sd.model_id
JOIN Sales s
ON sd.sale_id = s.sale_id
WHERE s.sale_status = 'Completed'
GROUP BY vm.fuel_type;


#20. Find the most popular vehicle model in each city.
SELECT city, model_name, total_sales
FROM (
    SELECT d.city,
           vm.model_name,
           SUM(sd.quantity) AS total_sales,
           RANK() OVER (
               PARTITION BY d.city
               ORDER BY SUM(sd.quantity) DESC
           ) AS ranking
    FROM Dealerships d
    JOIN Sales s
    ON d.dealership_id = s.dealership_id
    JOIN Vehicles v
    ON s.vehicle_id = v.vehicle_id
    JOIN Vehicle_Models vm
    ON v.model_id = vm.model_id
    JOIN Sales_Details sd
    ON s.sale_id = sd.sale_id
    WHERE s.sale_status = 'Completed'
    GROUP BY d.city, vm.model_id, vm.model_name
) AS x
WHERE ranking = 1;

#Dealership Analysis

#21. Find the total number of dealerships.
SELECT COUNT(*) AS total_dealerships
FROM Dealerships;


#22. Find the number of dealerships in each city.
SELECT city,
       COUNT(dealership_id) AS total_dealerships
FROM Dealerships
GROUP BY city;


#23. Find the top 10 dealerships based on total sales revenue.
SELECT d.dealership_name,
       SUM(s.sale_amount) AS total_revenue
FROM Dealerships d
JOIN Sales s
ON d.dealership_id = s.dealership_id
WHERE s.sale_status = 'Completed'
GROUP BY d.dealership_id, d.dealership_name
ORDER BY total_revenue DESC
LIMIT 10;


#24. Find the dealership with the highest number of vehicles sold.
SELECT d.dealership_name,
       SUM(sd.quantity) AS vehicles_sold
FROM Dealerships d
JOIN Sales s
ON d.dealership_id = s.dealership_id
JOIN Sales_Details sd
ON s.sale_id = sd.sale_id
WHERE s.sale_status = 'Completed'
GROUP BY d.dealership_id, d.dealership_name
ORDER BY vehicles_sold DESC
LIMIT 1;


#25. Find dealerships that have not sold any vehicle.
SELECT d.dealership_name
FROM Dealerships d
LEFT JOIN Sales s
ON d.dealership_id = s.dealership_id
AND s.sale_status = 'Completed'
WHERE s.sale_id IS NULL;


#26. Find the average sales value for each dealership.
SELECT d.dealership_name,
       AVG(s.sale_amount) AS average_sales_value
FROM Dealerships d
JOIN Sales s
ON d.dealership_id = s.dealership_id
WHERE s.sale_status = 'Completed'
GROUP BY d.dealership_id, d.dealership_name;


#27. Find dealerships whose revenue is higher than the average dealership revenue.
SELECT d.dealership_name,
       SUM(s.sale_amount) AS total_revenue
FROM Dealerships d
JOIN Sales s
ON d.dealership_id = s.dealership_id
WHERE s.sale_status = 'Completed'
GROUP BY d.dealership_id, d.dealership_name
HAVING SUM(s.sale_amount) > (
    SELECT AVG(total_revenue)
    FROM (
        SELECT SUM(s2.sale_amount) AS total_revenue
        FROM Sales s2
        WHERE s2.sale_status = 'Completed'
        GROUP BY s2.dealership_id
    ) AS dealership_revenue
);


#28. Find the dealership generating the lowest revenue.
SELECT d.dealership_name,
       COALESCE(SUM(s.sale_amount), 0) AS total_revenue
FROM Dealerships d
LEFT JOIN Sales s
ON d.dealership_id = s.dealership_id
AND s.sale_status = 'Completed'
GROUP BY d.dealership_id, d.dealership_name
ORDER BY total_revenue ASC
LIMIT 1;

#Sales & Revenue Analysis

#29. Calculate the total number of vehicles sold.
SELECT SUM(sd.quantity) AS total_vehicles_sold
FROM Sales s
JOIN Sales_Details sd
ON s.sale_id = sd.sale_id
WHERE s.sale_status = 'Completed';


#30. Calculate the total sales revenue.
SELECT SUM(sale_amount) AS total_sales_revenue
FROM Sales
WHERE sale_status = 'Completed';


#31. Calculate the average vehicle selling price.
SELECT AVG(sd.selling_price) AS average_vehicle_selling_price
FROM Sales s
JOIN Sales_Details sd
ON s.sale_id = sd.sale_id
WHERE s.sale_status = 'Completed';


#32. Find monthly sales revenue for 2026.
SELECT MONTH(sale_date) AS month,
       SUM(sale_amount) AS monthly_revenue
FROM Sales
WHERE YEAR(sale_date) = 2026
AND sale_status = 'Completed'
GROUP BY MONTH(sale_date)
ORDER BY month;


#33. Find the month with the highest sales revenue.
SELECT MONTH(sale_date) AS month,
       SUM(sale_amount) AS total_revenue
FROM Sales
WHERE YEAR(sale_date) = 2026
AND sale_status = 'Completed'
GROUP BY MONTH(sale_date)
ORDER BY total_revenue DESC
LIMIT 1;


#34. Find the month with the lowest sales revenue.
SELECT MONTH(sale_date) AS month,
       SUM(sale_amount) AS total_revenue
FROM Sales
WHERE YEAR(sale_date) = 2026
AND sale_status = 'Completed'
GROUP BY MONTH(sale_date)
ORDER BY total_revenue ASC
LIMIT 1;


#35. Find the number of vehicles sold for each fuel type.
SELECT vm.fuel_type,
       SUM(sd.quantity) AS vehicles_sold
FROM Vehicle_Models vm
JOIN Sales_Details sd
ON vm.model_id = sd.model_id
JOIN Sales s
ON sd.sale_id = s.sale_id
WHERE s.sale_status = 'Completed'
GROUP BY vm.fuel_type;


#36. Calculate the percentage of cancelled sales.
SELECT
    (SUM(CASE
        WHEN sale_status = 'Cancelled' THEN 1
        ELSE 0
    END) / COUNT(*)) * 100 AS cancelled_percentage
FROM Sales;


#37. Find the city generating the highest sales revenue.
SELECT d.city,
       SUM(s.sale_amount) AS total_revenue
FROM Dealerships d
JOIN Sales s
ON d.dealership_id = s.dealership_id
WHERE s.sale_status = 'Completed'
GROUP BY d.city
ORDER BY total_revenue DESC
LIMIT 1;


#38. Find the daily sales revenue for a selected month.
SELECT sale_date,
       SUM(sale_amount) AS daily_revenue
FROM Sales
WHERE YEAR(sale_date) = 2026
AND MONTH(sale_date) = 8
AND sale_status = 'Completed'
GROUP BY sale_date
ORDER BY sale_date;

#Employee Analysis

#39. Find the total number of sales employees.
SELECT COUNT(*) AS total_sales_employees
FROM Employees
WHERE job_role LIKE '%Sales%';


#40. Find the number of employees working at each dealership.
SELECT d.dealership_name,
       COUNT(e.employee_id) AS total_employees
FROM Dealerships d
JOIN Employees e
ON d.dealership_id = e.dealership_id
GROUP BY d.dealership_id, d.dealership_name;


#41. Find employees who have generated more than the average sales revenue.
SELECT e.employee_name,
       SUM(s.sale_amount) AS total_revenue
FROM Employees e
JOIN Sales s
ON e.employee_id = s.employee_id
WHERE s.sale_status = 'Completed'
GROUP BY e.employee_id, e.employee_name
HAVING SUM(s.sale_amount) > (
    SELECT AVG(total_revenue)
    FROM (
        SELECT SUM(s2.sale_amount) AS total_revenue
        FROM Sales s2
        WHERE s2.sale_status = 'Completed'
        GROUP BY s2.employee_id
    ) AS employee_revenue
);


#42. Find the employee with the highest number of vehicle sales.
SELECT e.employee_name,
       SUM(sd.quantity) AS vehicles_sold
FROM Employees e
JOIN Sales s
ON e.employee_id = s.employee_id
JOIN Sales_Details sd
ON s.sale_id = sd.sale_id
WHERE s.sale_status = 'Completed'
GROUP BY e.employee_id, e.employee_name
ORDER BY vehicles_sold DESC
LIMIT 1;


#43. Find the employee who generated the highest revenue.
SELECT e.employee_name,
       SUM(s.sale_amount) AS total_revenue
FROM Employees e
JOIN Sales s
ON e.employee_id = s.employee_id
WHERE s.sale_status = 'Completed'
GROUP BY e.employee_id, e.employee_name
ORDER BY total_revenue DESC
LIMIT 1;

#Payment Analysis

#44. Find the most frequently used payment method.
SELECT payment_method,
       COUNT(*) AS total_transactions
FROM Payments
GROUP BY payment_method
ORDER BY total_transactions DESC
LIMIT 1;


#45. Calculate total revenue received through each payment method.
SELECT payment_method,
       SUM(amount) AS total_revenue
FROM Payments
WHERE payment_status = 'Successful'
GROUP BY payment_method
ORDER BY total_revenue DESC;


#46. Find the number of successful and failed payments.
SELECT payment_status,
       COUNT(*) AS total_payments
FROM Payments
GROUP BY payment_status;


#47. Find the payment method with the highest failure rate.
SELECT 
    payment_method,
    (SUM(CASE
        WHEN payment_status = 'Failed' THEN 1
        ELSE 0
    END) / COUNT(*)) * 100 AS failure_rate
FROM
    Payments
GROUP BY payment_method
ORDER BY failure_rate DESC
LIMIT 1;

#Service Analysis 

#48. Find the number of service records for each vehicle model.
SELECT vm.model_name,
       COUNT(sr.service_id) AS total_service_records
FROM Vehicle_Models vm
LEFT JOIN Vehicles v
ON vm.model_id = v.model_id
LEFT JOIN Service_Records sr
ON v.vehicle_id = sr.vehicle_id
GROUP BY vm.model_id, vm.model_name;


#49. Calculate the average service cost for each vehicle model.
SELECT vm.model_name,
       AVG(sr.service_cost) AS average_service_cost
FROM Vehicle_Models vm
JOIN Vehicles v
ON vm.model_id = v.model_id
JOIN Service_Records sr
ON v.vehicle_id = sr.vehicle_id
GROUP BY vm.model_id, vm.model_name;


#50. Find vehicles whose service cost is higher than the average service cost.
SELECT v.registration_number,
       vm.model_name,
       sr.service_cost
FROM Vehicles v
JOIN Vehicle_Models vm
ON v.model_id = vm.model_id
JOIN Service_Records sr
ON v.vehicle_id = sr.vehicle_id
WHERE sr.service_cost > (
    SELECT AVG(service_cost)
    FROM Service_Records
);



