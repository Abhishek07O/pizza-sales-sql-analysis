USE `ZOMATO_ANALYSIS`;
SELECT * FROM ORDER_DETAILS;
SELECT * FROM ORDERS;
SELECT * FROM PIZZA_TYPES;
SELECT * FROM PIZZAS;



-- 1. Retrieve the total number of orders placed.

SELECT 
    COUNT(order_id) AS total_orders
FROM
    ORDERS;
    
    
-- 2. Calculate the total revenue generated from pizza sales.    
    
 SELECT 
    ROUND(SUM(order_details.quantity * Pizzas.price),
            2) AS total_revenue
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id;
    
    
    
  
  -- 3. Identify the highest-priced pizza.
  
  
  SELECT 
    pizza_types.name, Pizzas.price
FROM
    Pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY Pizzas.price DESC
LIMIT 1;

-- 4.Identify the most common pizza size ordered.

SELECT 
    pizzas.size,
    SUM(quantity) AS most_common_pizza_size
FROM
    Pizzas
        JOIN
    order_details ON pizzas.Pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY most_common_pizza_size DESC ;


-- 5.List the top 5 most ordered pizza types along with their quantities.
SELECT 
    pizza_types.NAME,
    SUM(order_details.quantity) AS most_ordered_pizza_types
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.NAME
ORDER BY most_ordered_pizza_types DESC
LIMIT 5;



-- 6. Join the necessary tables to find the total quantity of 
-- each pizza category ordered.

SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS total_order_quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category
ORDER BY total_order_quantity DESC;



-- 7. Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(time) AS `HOUR`, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY `HOUR`;

-- 8.Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(`name`) `NAME`
FROM
    pizza_types
GROUP BY category;

-- 9. Group the orders by date and calculate the average number
-- of pizzas ordered per day.
SELECT 
    ROUND(AVG(avg_order), 0) AS avg_order_per_day
FROM
    (SELECT 
        orders.`date`, SUM(order_details.quantity) AS avg_order
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.`date`) AS per_day;
 
 
 -- 10. Determine the top 3 most ordered pizza types based on revenue.
 
  SELECT 
    pizza_types.`name`,
    SUM(order_details.quantity * pizzas.price) AS revanue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.`name`
ORDER BY revanue DESC
LIMIT 3;

-- 11. Calculate the percentage contribution 
-- of each pizza type to total revenue.

 SELECT 
    pizza_types.category,
    ROUND((SUM(order_details.quantity * pizzas.price) / (SELECT 
                    ROUND(SUM(order_details.quantity * pizzas.price),
                                2) AS total_sales
                FROM
                    order_details
                        JOIN
                    pizzas ON pizzas.pizza_id = order_details.pizza_id)) * 100,
            2) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;




-- 12. Analyze the cumulative revenue generated over time.

 SELECT `date`,
 SUM(revenue) OVER(ORDER BY `date`) AS cum_revenue
 FROM 
(SELECT orders.`date`, 
ROUND(SUM(order_details.quantity*pizzas.price),0) AS revenue
FROM order_details
JOIN pizzas
ON order_details.pizza_id = pizzas.pizza_id
JOIN orders
ON orders.order_id = order_details.order_id
GROUP BY orders.`date`) AS sales ;

-- 13. Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT `name`,ROUND(revenue,0) AS revenue_clear ,category FROM 
(SELECT category, `name`,revenue	,
RANK() OVER(PARTITION BY category ORDER BY revenue DESC	) AS `rank` FROM(SELECT 
    pizza_types.category, pizza_types.`name`,
    SUM((order_details.quantity)*pizzas.price) AS revenue	
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY  pizza_types.category,pizza_types.`name`) AS Determine_top_3 ) Determine_top_3_2
WHERE `rank` <=3; 












