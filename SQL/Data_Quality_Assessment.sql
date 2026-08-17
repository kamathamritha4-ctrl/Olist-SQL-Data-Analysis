

USE Olist_Project;
GO


SELECT 'Customers' AS Table_Name, COUNT(*) AS Total_Rows FROM Customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM Orders
UNION ALL
SELECT 'Order_Items', COUNT(*) FROM Order_Items
UNION ALL
SELECT 'Products', COUNT(*) FROM Products
UNION ALL
SELECT 'Payments', COUNT(*) FROM Payments
UNION ALL
SELECT 'Reviews', COUNT(*) FROM Reviews
UNION ALL
SELECT 'Sellers', COUNT(*) FROM Sellers
UNION ALL
SELECT 'Category_Translation', COUNT(*) FROM Category_Translation
UNION ALL
SELECT 'Geolocation', COUNT(*) FROM Geolocation;



SELECT customer_id,
       COUNT(*) AS Duplicate_Count
FROM Customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT order_id,
       COUNT(*) AS Duplicate_Count
FROM Orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT product_id,
       COUNT(*) AS Duplicate_Count
FROM Products
GROUP BY product_id
HAVING COUNT(*) > 1;


SELECT seller_id,
       COUNT(*) AS Duplicate_Count
FROM Sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;



SELECT review_id,
       order_id,
       COUNT(*) AS Duplicate_Count
FROM Reviews
GROUP BY review_id, order_id
HAVING COUNT(*) > 1;



SELECT order_id,
       payment_sequential,
       COUNT(*) AS Duplicate_Count
FROM Payments
GROUP BY order_id, payment_sequential
HAVING COUNT(*) > 1;


SELECT order_id,
       order_item_id,
       COUNT(*) AS Duplicate_Count
FROM Order_Items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;



SELECT
SUM(CASE WHEN order_approved_at IS NULL THEN 1 ELSE 0 END) AS Missing_Approval_Date,
SUM(CASE WHEN order_delivered_carrier_date IS NULL THEN 1 ELSE 0 END) AS Missing_Carrier_Date,
SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END) AS Missing_Delivery_Date,
SUM(CASE WHEN order_estimated_delivery_date IS NULL THEN 1 ELSE 0 END) AS Missing_Estimated_Date
FROM Orders;

SELECT
    order_status,
    COUNT(*) AS Total_Orders
FROM Orders
WHERE order_delivered_customer_date IS NULL
GROUP BY order_status
ORDER BY Total_Orders DESC;




SELECT
SUM(CASE WHEN product_category_name IS NULL THEN 1 ELSE 0 END) AS Missing_Category,
SUM(CASE WHEN product_weight_g IS NULL THEN 1 ELSE 0 END) AS Missing_Weight,
SUM(CASE WHEN product_length_cm IS NULL THEN 1 ELSE 0 END) AS Missing_Length,
SUM(CASE WHEN product_height_cm IS NULL THEN 1 ELSE 0 END) AS Missing_Height,
SUM(CASE WHEN product_width_cm IS NULL THEN 1 ELSE 0 END) AS Missing_Width
FROM Products;

SELECT *
FROM Products
WHERE product_category_name IS NULL;



SELECT
SUM(CASE WHEN review_comment_title IS NULL THEN 1 ELSE 0 END) AS Missing_Title,
SUM(CASE WHEN review_comment_message IS NULL THEN 1 ELSE 0 END) AS Missing_Message
FROM Reviews;

SELECT
    review_score,
    COUNT(*) AS Reviews_Without_Message
FROM Reviews
WHERE review_comment_message IS NULL
GROUP BY review_score
ORDER BY review_score desc;

SELECT DISTINCT order_status
FROM Orders;

SELECT DISTINCT payment_type
FROM Payments;

SELECT DISTINCT customer_state
FROM Customers
ORDER BY customer_state;

SELECT DISTINCT seller_state
FROM Sellers
ORDER BY seller_state;

SELECT *
FROM Orders
WHERE order_approved_at < order_purchase_timestamp;


SELECT *
FROM Orders
WHERE order_delivered_carrier_date < order_purchase_timestamp;


SELECT TOP 20
    order_purchase_timestamp,
    order_delivered_carrier_date
FROM Orders
WHERE order_delivered_carrier_date < order_purchase_timestamp;


SELECT *
FROM Orders
WHERE order_delivered_customer_date < order_purchase_timestamp;


SELECT *
FROM Orders
WHERE order_estimated_delivery_date < order_purchase_timestamp;


SELECT *
FROM Order_Items
WHERE price < 0;


SELECT *
FROM Order_Items
WHERE freight_value < 0;


SELECT *
FROM Payments
WHERE payment_value <= 0;


SELECT COUNT(*) AS Zero_Value_Payments
FROM Payments
WHERE payment_value = 0;

SELECT *
FROM Payments
WHERE payment_value = 0;


SELECT *
FROM Reviews
WHERE review_score NOT BETWEEN 1 AND 5;


SELECT *
FROM Orders o
LEFT JOIN Customers c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT *
FROM Order_Items oi
LEFT JOIN Orders o
ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


SELECT *
FROM Order_Items oi
LEFT JOIN Products p
ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


SELECT *
FROM Order_Items oi
LEFT JOIN Sellers s
ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;


SELECT *
FROM Payments p
LEFT JOIN Orders o
ON p.order_id = o.order_id
WHERE o.order_id IS NULL;


SELECT *
FROM Reviews r
LEFT JOIN Orders o
ON r.order_id = o.order_id
WHERE o.order_id IS NULL;


SELECT *
FROM Orders
WHERE order_status = 'canceled'
AND order_delivered_customer_date IS NOT NULL;


SELECT
    order_status,
    COUNT(*) AS Total_Orders
FROM Orders
WHERE order_delivered_customer_date IS NOT NULL
GROUP BY order_status
ORDER BY Total_Orders DESC;


SELECT *
FROM Orders
WHERE order_status = 'delivered'
AND order_delivered_customer_date IS NULL;

SELECT TOP 20 *
FROM Orders
WHERE order_status = 'delivered'
AND order_delivered_customer_date IS NULL;

SELECT *
FROM Orders
WHERE order_status = 'delivered'
AND order_approved_at IS NULL;


SELECT review_score,
COUNT(*) AS Total_Reviews
FROM Reviews
GROUP BY review_score
ORDER BY review_score;


SELECT order_id,
COUNT(*) AS Number_of_Payments
FROM Payments
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY Number_of_Payments DESC;


SELECT TOP 20
    order_id,
    payment_type,
    payment_installments,
    payment_value
FROM Payments
WHERE order_id IN
(
    SELECT order_id
    FROM Payments
    GROUP BY order_id
    HAVING COUNT(*) > 1
);
