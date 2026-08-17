USE Olist_Project;
GO

/******************************************************************************
PHASE 3 - BUSINESS FAMILIARIZATION
Purpose:
Understand the structure, size, and characteristics of the Olist business
before beginning business analysis.
******************************************************************************/

/******************************************************************************
SECTION A - BUSINESS SIZE
******************************************************************************/

-- Q1. Total customer records

SELECT COUNT(*) AS Total_Customers
FROM Customers;

------------------------------------------------------------

-- Q2. Total unique customers

SELECT COUNT(DISTINCT customer_unique_id) AS Total_Unique_Customers
FROM Customers;

------------------------------------------------------------

-- Q3. Total orders

SELECT COUNT(*) AS Total_Orders
FROM Orders;

------------------------------------------------------------

-- Q4. Total sellers

SELECT COUNT(*) AS Total_Sellers
FROM Sellers;

------------------------------------------------------------

-- Q5. Total products

SELECT COUNT(*) AS Total_Products
FROM Products;

------------------------------------------------------------

-- Q6. Total product categories

SELECT COUNT(DISTINCT product_category_name) AS Total_Product_Categories
FROM Products;

------------------------------------------------------------

-- Q7. Products without a category

SELECT COUNT(*) AS Products_Without_Category
FROM Products
WHERE product_category_name IS NULL;

/******************************************************************************
SECTION B - TIME EXPLORATION
******************************************************************************/

-- Q8. Earliest purchase date

SELECT MIN(order_purchase_timestamp) AS First_Order_Date
FROM Orders;

------------------------------------------------------------

-- Q9. Latest purchase date

SELECT MAX(order_purchase_timestamp) AS Last_Order_Date
FROM Orders;

------------------------------------------------------------

-- Q10. Number of years covered

SELECT
DATEDIFF(
YEAR,
MIN(order_purchase_timestamp),
MAX(order_purchase_timestamp)
) + 1 AS Years_Of_Data
FROM Orders;

------------------------------------------------------------

-- Q11. Years present in the dataset

SELECT DISTINCT
YEAR(order_purchase_timestamp) AS Order_Year
FROM Orders
ORDER BY Order_Year;

------------------------------------------------------------

-- Q12. Orders per year

SELECT
YEAR(order_purchase_timestamp) AS Order_Year,
COUNT(*) AS Total_Orders
FROM Orders
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY Order_Year;

------------------------------------------------------------

-- Q13. Orders per month

SELECT
YEAR(order_purchase_timestamp) AS Order_Year,
MONTH(order_purchase_timestamp) AS Month_Number,
DATENAME(MONTH,order_purchase_timestamp) AS Month_Name,
COUNT(*) AS Total_Orders
FROM Orders
GROUP BY
YEAR(order_purchase_timestamp),
MONTH(order_purchase_timestamp),
DATENAME(MONTH,order_purchase_timestamp)
ORDER BY
Order_Year,
Month_Number;

------------------------------------------------------------

-- Q14. Month with highest orders

SELECT TOP 1
YEAR(order_purchase_timestamp) AS Order_Year,
MONTH(order_purchase_timestamp) AS Month_Number,
DATENAME(MONTH,order_purchase_timestamp) AS Month_Name,
COUNT(*) AS Total_Orders
FROM Orders
GROUP BY
YEAR(order_purchase_timestamp),
MONTH(order_purchase_timestamp),
DATENAME(MONTH,order_purchase_timestamp)
ORDER BY Total_Orders DESC;

------------------------------------------------------------

-- Q15. Month with fewest orders

SELECT TOP 1
YEAR(order_purchase_timestamp) AS Order_Year,
MONTH(order_purchase_timestamp) AS Month_Number,
DATENAME(MONTH,order_purchase_timestamp) AS Month_Name,
COUNT(*) AS Total_Orders
FROM Orders
GROUP BY
YEAR(order_purchase_timestamp),
MONTH(order_purchase_timestamp),
DATENAME(MONTH,order_purchase_timestamp)
ORDER BY Total_Orders ASC;

/******************************************************************************
SECTION C - ORDERS
******************************************************************************/

-- Q16. Order statuses

SELECT DISTINCT order_status
FROM Orders;

------------------------------------------------------------

-- Q17. Number of orders by status

SELECT
order_status,
COUNT(*) AS Total_Orders
FROM Orders
GROUP BY order_status
ORDER BY Total_Orders DESC;

------------------------------------------------------------

-- Q18. Percentage of delivered orders

SELECT
ROUND(
100.0 *
SUM(CASE WHEN order_status='delivered' THEN 1 ELSE 0 END)
/ COUNT(*),2
) AS Delivered_Percentage
FROM Orders;

------------------------------------------------------------

-- Q19. Percentage of cancelled orders

SELECT
ROUND(
100.0 *
SUM(CASE WHEN order_status='canceled' THEN 1 ELSE 0 END)
/ COUNT(*),2
) AS Cancelled_Percentage
FROM Orders;

------------------------------------------------------------

-- Q20. Percentage of in-progress orders

SELECT
ROUND(
100.0 *
SUM(
CASE
WHEN order_status IN
('approved','created','invoiced','processing','shipped')
THEN 1
ELSE 0
END
)
/ COUNT(*),2
) AS In_Progress_Percentage
FROM Orders;

/******************************************************************************
SECTION D - CUSTOMERS
******************************************************************************/

-- Q21. Customers by state

SELECT
customer_state,
COUNT(*) AS Total_Customers
FROM Customers
GROUP BY customer_state
ORDER BY Total_Customers DESC;

------------------------------------------------------------

-- Q22. Top 10 customer states

SELECT TOP 10
customer_state,
COUNT(*) AS Total_Customers
FROM Customers
GROUP BY customer_state
ORDER BY Total_Customers DESC;

------------------------------------------------------------

-- Q23. Customers by city

SELECT
customer_city,
COUNT(*) AS Total_Customers
FROM Customers
GROUP BY customer_city
ORDER BY Total_Customers DESC;

------------------------------------------------------------

-- Q24. Top 10 customer cities

SELECT TOP 10
customer_city,
COUNT(*) AS Total_Customers
FROM Customers
GROUP BY customer_city
ORDER BY Total_Customers DESC;

------------------------------------------------------------

-- Q25. Number of states

SELECT COUNT(DISTINCT customer_state) AS Total_States
FROM Customers;

------------------------------------------------------------

-- Q26. State with the fewest customers

SELECT TOP 1
customer_state,
COUNT(*) AS Total_Customers
FROM Customers
GROUP BY customer_state
ORDER BY Total_Customers;

/******************************************************************************
SECTION E - PRODUCTS
******************************************************************************/

-- Q27. Products by category

SELECT
product_category_name,
COUNT(*) AS Products
FROM Products
GROUP BY product_category_name
ORDER BY Products DESC;

------------------------------------------------------------

-- Q28. Top 10 categories

SELECT TOP 10
product_category_name,
COUNT(*) AS Products
FROM Products
GROUP BY product_category_name
ORDER BY Products DESC;

------------------------------------------------------------

-- Q29. Bottom 10 categories

SELECT TOP 10
product_category_name,
COUNT(*) AS Products
FROM Products
GROUP BY product_category_name
ORDER BY Products ASC;

------------------------------------------------------------

-- Q30. Average product weight by category

SELECT
product_category_name,
AVG(product_weight_g) AS Avg_Weight
FROM Products
GROUP BY product_category_name
ORDER BY Avg_Weight DESC;

------------------------------------------------------------

-- Q31. Average photos per category

SELECT
product_category_name,
AVG(product_photos_qty) AS Avg_Photos
FROM Products
GROUP BY product_category_name
ORDER BY Avg_Photos DESC;;

------------------------------------------------------------

-- Q32. Average description length

SELECT
product_category_name,
AVG(product_description_lenght) AS Avg_Description_Length
FROM Products
GROUP BY product_category_name
ORDER BY Avg_Description_Length DESC;

/******************************************************************************
SECTION F - SELLERS
******************************************************************************/

-- Q33. Sellers by state

SELECT
seller_state,
COUNT(*) AS Total_Sellers
FROM Sellers
GROUP BY seller_state
ORDER BY Total_Sellers DESC;

------------------------------------------------------------

-- Q34. Top 10 seller states

SELECT TOP 10
seller_state,
COUNT(*) AS Total_Sellers
FROM Sellers
GROUP BY seller_state
ORDER BY Total_Sellers DESC;

------------------------------------------------------------

-- Q35. Sellers by city

SELECT
seller_city,
COUNT(*) AS Total_Sellers
FROM Sellers
GROUP BY seller_city
ORDER BY Total_Sellers DESC;

------------------------------------------------------------

-- Q36. Top 10 seller cities

SELECT TOP 10
seller_city,
COUNT(*) AS Total_Sellers
FROM Sellers
GROUP BY seller_city
ORDER BY Total_Sellers DESC;

------------------------------------------------------------

-- Q37. State with the most sellers

SELECT TOP 1
seller_state,
COUNT(*) AS Total_Sellers
FROM Sellers
GROUP BY seller_state
ORDER BY Total_Sellers DESC;

/******************************************************************************
SECTION G - PAYMENTS
******************************************************************************/

-- Q38. Payment methods

SELECT DISTINCT payment_type
FROM Payments;

------------------------------------------------------------

-- Q39. Orders by payment type

SELECT
payment_type,
COUNT(*) AS Total
FROM Payments
GROUP BY payment_type
ORDER BY Total DESC;

------------------------------------------------------------

-- Q40. Average payment value

SELECT AVG(payment_value) AS Avg_Payment
FROM Payments;

------------------------------------------------------------

-- Q41. Highest payment

SELECT MAX(payment_value) AS Highest_Payment
FROM Payments;

------------------------------------------------------------

-- Q42. Lowest payment

SELECT MIN(payment_value) AS Lowest_Payment
FROM Payments;

------------------------------------------------------------

-- Q43. Average installments

SELECT AVG(payment_installments) AS Avg_Installments
FROM Payments;

------------------------------------------------------------

-- Q44. Maximum installments

SELECT MAX(payment_installments) AS Max_Installments
FROM Payments;

------------------------------------------------------------

-- Q45. Most common installment count

SELECT TOP 1
payment_installments,
COUNT(*) AS Total
FROM Payments
GROUP BY payment_installments
ORDER BY Total DESC;

/******************************************************************************
SECTION H - REVIEWS
******************************************************************************/

-- Q46. Average review score

SELECT AVG(CAST(review_score AS DECIMAL(10,2))) AS Avg_Review
FROM Reviews;

------------------------------------------------------------

-- Q47. Review distribution

SELECT
review_score,
COUNT(*) AS Total
FROM Reviews
GROUP BY review_score
ORDER BY review_score;

------------------------------------------------------------

-- Q48. Percentage of each review score

SELECT
review_score,
COUNT(*) AS Total,
ROUND(
100.0 * COUNT(*) /
(SELECT COUNT(*) FROM Reviews),2
) AS Percentage
FROM Reviews
GROUP BY review_score
ORDER BY review_score;

------------------------------------------------------------

-- Q49. Reviews with written comments

SELECT COUNT(*) AS Reviews_With_Comments
FROM Reviews
WHERE review_comment_message IS NOT NULL;

------------------------------------------------------------

-- Q50. Reviews containing only ratings

SELECT COUNT(*) AS Ratings_Only
FROM Reviews
WHERE review_comment_message IS NULL;

------------------------------------------------------------

-- Q51. Average review score by year

SELECT
YEAR(review_creation_date) AS Review_Year,
AVG(CAST(review_score AS DECIMAL(10,2))) AS Avg_Review_Score
FROM Reviews
GROUP BY YEAR(review_creation_date)
ORDER BY Review_Year;

/******************************************************************************
BONUS QUESTIONS
******************************************************************************/

-- B1. Average orders per unique customer

SELECT
CAST(COUNT(*) AS FLOAT) /
COUNT(DISTINCT customer_unique_id) AS Avg_Orders_Per_Customer
FROM Customers;

------------------------------------------------------------

-- B2. Average items sold per seller

SELECT
CAST(COUNT(*) AS FLOAT) /
COUNT(DISTINCT seller_id) AS Avg_Items_Per_Seller
FROM Order_Items;

------------------------------------------------------------

-- B3. Average freight cost

SELECT AVG(freight_value) AS Avg_Freight
FROM Order_Items;

------------------------------------------------------------

-- B4. Average product price

SELECT AVG(price) AS Avg_Product_Price
FROM Order_Items;

------------------------------------------------------------

-- B5. Top 10 most expensive products

SELECT TOP 10
product_id,
price
FROM Order_Items
ORDER BY price DESC;

------------------------------------------------------------

-- B6. Average order value

SELECT AVG(Order_Total) AS Avg_Order_Value
FROM
(
    SELECT
        order_id,
        SUM(price) AS Order_Total
    FROM Order_Items
    GROUP BY order_id
) AS Orders;

------------------------------------------------------------

-- B7. Orders containing more than one item

SELECT
order_id,
COUNT(*) AS Items
FROM Order_Items
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY Items DESC;

------------------------------------------------------------

-- B8. Average number of items per order

SELECT AVG(Item_Count) AS Avg_Items_Per_Order
FROM
(
    SELECT
        order_id,
        COUNT(*) AS Item_Count
    FROM Order_Items
    GROUP BY order_id
) AS X;