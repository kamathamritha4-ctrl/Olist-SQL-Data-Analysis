USE Olist_Project;
GO

SELECT
SUM(price) AS Total_Revenue
FROM Order_Items;

SELECT
SUM(freight_value) AS Total_Freight_Revenue
FROM Order_Items;

SELECT
SUM(price + freight_value) AS Gross_Revenue
FROM Order_Items;

--SELECT
--COUNT(*) AS Total_Orders
--FROM Orders;

SELECT
AVG(Order_Total) AS Average_Order_Value
FROM
(
    SELECT
        order_id,
        SUM(price) AS Order_Total
    FROM Order_Items
    GROUP BY order_id
) AS OrderRevenue;

Select 
Year(o.order_purchase_timestamp) As Order_Year,
SUM(oi.price) As Revenue
FROM Orders o
Join Order_Items oi
On o.order_id=oi.order_id
Group by Year(o.order_purchase_timestamp)
Order by Order_Year

Select 
Year(o.order_purchase_timestamp) As Order_Year,
MONTH(o.order_purchase_timestamp) As Month_Number,
DateName(Month,o.order_purchase_timestamp) As Month_Name,
SUM(oi.price) As Revenue
FROM Orders o
Join Order_Items oi
On o.order_id=oi.order_id
Group by Year(o.order_purchase_timestamp),
MONTH(o.order_purchase_timestamp),
DateName(Month,o.order_purchase_timestamp)
Order by Order_Year,
Month_Number

Select Top 1
Year(o.order_purchase_timestamp) As Order_Year,
MONTH(o.order_purchase_timestamp) As Month_Number,
DateName(Month,o.order_purchase_timestamp) As Month_Name,
SUM(oi.price) As Revenue
FROM Orders o
Join Order_Items oi
On o.order_id=oi.order_id
Group by Year(o.order_purchase_timestamp),
MONTH(o.order_purchase_timestamp),
DateName(Month,o.order_purchase_timestamp)
Order by Revenue DESC

Select Top 1
Year(o.order_purchase_timestamp) As Order_Year,
MONTH(o.order_purchase_timestamp) As Month_Number,
DateName(Month,o.order_purchase_timestamp) As Month_Name,
SUM(oi.price) As Revenue
FROM Orders o
Join Order_Items oi
On o.order_id=oi.order_id
Group by Year(o.order_purchase_timestamp),
MONTH(o.order_purchase_timestamp),
DateName(Month,o.order_purchase_timestamp)
Order by Revenue 


Select AVG(Monthly_Revenue) As Average_Monthly_Revenue
FROM
(Select 
Year(o.order_purchase_timestamp) As Order_Year,
MONTH(o.order_purchase_timestamp) As Month_Number,
DateName(Month,o.order_purchase_timestamp) As Month_Name,
SUM(oi.price) As Monthly_Revenue
FROM Orders o
Join Order_Items oi
On o.order_id=oi.order_id
Group by Year(o.order_purchase_timestamp),
MONTH(o.order_purchase_timestamp),
DateName(Month,o.order_purchase_timestamp)
) AS Monthly_Revenue

Select 
Year(o.order_purchase_timestamp) As Order_Year,
MONTH(o.order_purchase_timestamp) As Month_Number,
SUM(oi.price) As Monthly_Revenue
FROM Orders o
Join Order_Items oi
On o.order_id=oi.order_id
Group by Year(o.order_purchase_timestamp),
MONTH(o.order_purchase_timestamp)
Order by Order_Year,Month_Number

Select c.customer_state,
SUM(oi.price) As Total_Revenue
From Customers c
Join Orders o
On c.customer_id=o.customer_id
Join Order_Items oi
On o.order_id=oi.order_id
Group by c.customer_state
Order By Total_Revenue

Select Top 10
c.customer_state,
SUM(oi.price) As Total_Revenue
From Customers c
Join Orders o
On c.customer_id=o.customer_id
Join Order_Items oi
On o.order_id=oi.order_id
Group by c.customer_state
Order By Total_Revenue DESC

Select c.customer_city,
SUM(oi.price) As Total_Revenue
From Customers c
Join Orders o
On c.customer_id=o.customer_id
Join Order_Items oi
On o.order_id=oi.order_id
Group by c.customer_city

Select Top 10
c.customer_city,
SUM(oi.price) As Total_Revenue
From Customers c
Join Orders o
On c.customer_id=o.customer_id
Join Order_Items oi
On o.order_id=oi.order_id
Group by c.customer_city 
Order by Total_Revenue DESC

SELECT
    AVG(Customer_Revenue) AS Avg_Revenue_Per_Customer
FROM
(
    SELECT
        c.customer_unique_id,
        SUM(oi.price) AS Customer_Revenue
    FROM Customers c
    JOIN Orders o
        ON c.customer_id = o.customer_id
    JOIN Order_Items oi
        ON o.order_id = oi.order_id
    GROUP BY c.customer_unique_id
) AS CustomerTotals;

SELECT TOP 20
    c.customer_unique_id,
    SUM(oi.price) AS Total_Spent
FROM Customers c
JOIN Orders o
    ON c.customer_id = o.customer_id
JOIN Order_Items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
ORDER BY Total_Spent DESC;

Select Count(*) AS One_Time_Customers
From(Select c.customer_unique_id
From Customers c
Join Orders o
On c.customer_id=o.customer_id
Group by c.customer_unique_id
Having Count(o.order_id)=1) As OneTimeCustomers

SELECT
    COUNT(*) AS Repeat_Customers
FROM
(
    SELECT
        c.customer_unique_id
    FROM Customers c
    JOIN Orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
    HAVING COUNT(o.order_id) > 1
) AS RepeatCustomers;

SELECT
    AVG(Order_Count * 1.0) AS Avg_Orders_Per_Customer
FROM
(
    SELECT
        c.customer_unique_id,
        COUNT(o.order_id) AS Order_Count
    FROM Customers c
    JOIN Orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.customer_unique_id
) AS CustomerOrders;

Select ct.product_category_name_english As Category_Name,
SUM(oi.price) AS Total_Revenue
From Products p
Join Order_Items oi
On p.product_id=oi.product_id
Left Join Category_Translation ct
On p.product_category_name=ct.product_category_name
Group by ct.product_category_name_english 
Order by Total_Revenue DESC

SELECT TOP 10
    ct.product_category_name_english AS Category,
    SUM(oi.price) AS Total_Revenue
FROM Products p
JOIN Order_Items oi
    ON p.product_id = oi.product_id
LEFT JOIN Category_Translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english
ORDER BY Total_Revenue DESC;

Select ct.product_category_name_english As Category,
Count(*) As Products_Sold
From Products p
Join Order_Items oi
On p.product_id=oi.product_id
Left Join Category_Translation ct
On p.product_category_name=ct.product_category_name
Group By ct.product_category_name_english
Order By Products_Sold DESC

SELECT Top 10
    ct.product_category_name_english AS Category,
    COUNT(*) AS Products_Sold
FROM Products p
JOIN Order_Items oi
    ON p.product_id = oi.product_id
LEFT JOIN Category_Translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english
ORDER BY Products_Sold DESC;

Select ct.product_category_name_english As Category_Name,
AVG(oi.price) AS Avg_Price
From Products p
Join Order_Items oi
On p.product_id=oi.product_id
Left Join Category_Translation ct
On p.product_category_name=ct.product_category_name
Group by ct.product_category_name_english 
Order by Avg_Price DESC

SELECT
    ct.product_category_name_english AS Category,
    AVG(oi.freight_value) AS Avg_Freight
FROM Products p
JOIN Order_Items oi
    ON p.product_id = oi.product_id
LEFT JOIN Category_Translation ct
    ON p.product_category_name = ct.product_category_name
GROUP BY ct.product_category_name_english
ORDER BY Avg_Freight DESC;

Select ct.product_category_name_english As Category,
SUM(oi.price) As Revenue,
ROUND(100.0*SUM(oi.price)/(Select SUM(price) from Order_Items),2) 
As Revenue_Percentage
From Products p
Join Order_Items oi
On p.product_id=oi.product_id
Left Join Category_Translation ct
On p.product_category_name=ct.product_category_name
Group By ct.product_category_name_english
Order By Revenue DESC


SELECT
    s.seller_id,
    SUM(oi.price) AS Total_Revenue
FROM Sellers s
JOIN Order_Items oi
    ON s.seller_id = oi.seller_id
GROUP BY s.seller_id
ORDER BY Total_Revenue DESC;

SELECT TOP 10
    s.seller_id,
    SUM(oi.price) AS Total_Revenue
FROM Sellers s
JOIN Order_Items oi
    ON s.seller_id = oi.seller_id
GROUP BY s.seller_id
ORDER BY Total_Revenue DESC;

SELECT
    s.seller_state,
    SUM(oi.price) AS Total_Revenue
FROM Sellers s
JOIN Order_Items oi
    ON s.seller_id = oi.seller_id
GROUP BY s.seller_state
ORDER BY Total_Revenue DESC;

SELECT
    seller_state,
    COUNT(*) AS Total_Sellers
FROM Sellers
GROUP BY seller_state
ORDER BY Total_Sellers DESC;

SELECT
    AVG(Seller_Revenue) AS Avg_Revenue_Per_Seller
FROM(SELECT
        seller_id,
        SUM(price) AS Seller_Revenue
    FROM Order_Items
    GROUP BY seller_id)
 AS SellerTotals;

 SELECT TOP 20
    seller_id,
    COUNT(DISTINCT product_id) AS Unique_Products
FROM Order_Items
GROUP BY seller_id
ORDER BY Unique_Products DESC;

SELECT
    s.seller_id,
    AVG(r.review_score) AS Avg_Review,
    COUNT(r.review_score) AS Total_Reviews
FROM Sellers s
JOIN Order_Items oi
    ON s.seller_id = oi.seller_id
JOIN Orders o
    ON oi.order_id = o.order_id
JOIN Reviews r
    ON o.order_id = r.order_id
GROUP BY s.seller_id
HAVING COUNT(r.review_score) >= 30
ORDER BY Avg_Review DESC;

SELECT
    s.seller_id,
    AVG(r.review_score) AS Avg_Review,
    COUNT(r.review_score) AS Total_Reviews
FROM Sellers s
JOIN Order_Items oi
    ON s.seller_id = oi.seller_id
JOIN Orders o
    ON oi.order_id = o.order_id
JOIN Reviews r
    ON o.order_id = r.order_id
GROUP BY s.seller_id
HAVING COUNT(r.review_score) >= 30
ORDER BY Avg_Review ASC;

SELECT
    s.seller_state,
    AVG(oi.freight_value) AS Avg_Freight
FROM Sellers s
JOIN Order_Items oi
    ON s.seller_id = oi.seller_id
GROUP BY s.seller_state
ORDER BY Avg_Freight DESC;

SELECT
    oi.seller_id,
    AVG(oi.price) AS Avg_Order_Value
FROM Order_Items oi
GROUP BY oi.seller_id
ORDER BY Avg_Order_Value DESC;

SELECT
    seller_id,
    AVG(price) AS Avg_Order_Value
FROM Order_Items 
GROUP BY seller_id
ORDER BY Avg_Order_Value DESC;

SELECT
    AVG(
        DATEDIFF(
            DAY,
            order_purchase_timestamp,
            order_delivered_customer_date
        )
    ) AS Avg_Delivery_Days
FROM Orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL;

SELECT
AVG(
    DATEDIFF(
        DAY,
        order_purchase_timestamp,
        order_delivered_carrier_date
    )
) AS Avg_Shipping_Days
FROM Orders
WHERE order_delivered_carrier_date IS NOT NULL
And order_purchase_timestamp IS NOT NULL;

SELECT
    c.customer_state,
    AVG(
        DATEDIFF(
            DAY,
            o.order_purchase_timestamp,
            o.order_delivered_customer_date
        )
    ) AS Avg_Delivery_Days
FROM Orders o
JOIN Customers c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY Avg_Delivery_Days DESC;

SELECT TOP 10
    c.customer_state,
    AVG(
        DATEDIFF(
            DAY,
            o.order_purchase_timestamp,
            o.order_delivered_customer_date
        )
    ) AS Avg_Delivery_Days
FROM Orders o
JOIN Customers c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY Avg_Delivery_Days DESC;

SELECT TOP 10
    c.customer_state,
    AVG(
        DATEDIFF(
            DAY,
            o.order_purchase_timestamp,
            o.order_delivered_customer_date
        )
    ) AS Avg_Delivery_Days
FROM Orders o
JOIN Customers c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
AND o.order_delivered_customer_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY Avg_Delivery_Days ASC;


SELECT
    ct.product_category_name_english AS Category,
    AVG(
        DATEDIFF(
            DAY,
            o.order_purchase_timestamp,
            o.order_delivered_customer_date
        )
    ) AS Avg_Delivery_Days
FROM Orders o
JOIN Order_Items oi
    ON o.order_id = oi.order_id
JOIN Products p
    ON oi.product_id = p.product_id
LEFT JOIN Category_Translation ct
    ON p.product_category_name = ct.product_category_name
WHERE o.order_status = 'delivered'
AND o.order_delivered_customer_date IS NOT NULL
GROUP BY ct.product_category_name_english
HAVING COUNT(*) >= 30
ORDER BY Avg_Delivery_Days DESC;

SELECT
COUNT(*) AS Early_Deliveries
FROM Orders
WHERE order_status = 'delivered'
AND order_delivered_customer_date < order_estimated_delivery_date;

SELECT
COUNT(*) AS Late_Deliveries
FROM Orders
WHERE order_status = 'delivered'
AND order_delivered_customer_date > order_estimated_delivery_date;

SELECT
ROUND(
100.0 *
SUM(
CASE
WHEN order_delivered_customer_date <= order_estimated_delivery_date
THEN 1
ELSE 0
END
)
/
COUNT(*),
2
) AS On_Time_Delivery_Percentage
FROM Orders
WHERE order_status = 'delivered'
AND order_delivered_customer_date IS NOT NULL;


SELECT
AVG(
    DATEDIFF(
        DAY,
        order_estimated_delivery_date,
        order_delivered_customer_date
    )
) AS Avg_Delay_Days
FROM Orders
WHERE order_status = 'delivered'
AND order_delivered_customer_date > order_estimated_delivery_date;

SELECT
    c.customer_state,
    ROUND(AVG(r.review_score * 1.0), 2) AS Avg_Review_Score
FROM Reviews r
JOIN Orders o
    ON r.order_id = o.order_id
JOIN Customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY Avg_Review_Score DESC;

SELECT
    p.payment_type,
    ROUND(AVG(r.review_score * 1.0), 2) AS Avg_Review_Score
FROM
(
    SELECT DISTINCT order_id, payment_type
    FROM Payments
) p
JOIN Reviews r
    ON r.order_id = p.order_id
GROUP BY p.payment_type
ORDER BY Avg_Review_Score DESC;

Select 
Case
When DATEDIFF(Day,
o.order_purchase_timestamp,
o.order_delivered_customer_date)<=7
Then 'Fast Delivery(<=7)'
When DATEDIFF(Day,
o.order_purchase_timestamp,
o.order_delivered_customer_date)<=14
Then 'Medium Delivery(8-14 days)'
Else 'Slow Delivery(>14 days)'
End As Delivery_Speed,
Round(AVG(r.review_score*1.0),2) AS Average_Review
From Orders o
Join Reviews r 
On o.order_id=r.order_id
Where o.order_status='Delivered'
And o.order_delivered_customer_date Is Not NULL
Group By
Case
When DATEDIFF(Day,
o.order_purchase_timestamp,
o.order_delivered_customer_date)<=7
Then 'Fast Delivery(<=7)'
When DATEDIFF(Day,
o.order_purchase_timestamp,
o.order_delivered_customer_date)<=14
Then 'Medium Delivery(8-14 days)'
Else 'Slow Delivery(>14 days)'
End
Order By Average_Review DESC

SELECT
    review_score,
    COUNT(*) AS Total_Reviews,
    ROUND(
        100.0 * COUNT(*) /
        (SELECT COUNT(*) FROM Reviews),
        2
    ) AS Percentage
FROM Reviews
GROUP BY review_score
ORDER BY review_score;

SELECT
    payment_type,
    SUM(payment_value) AS Total_Revenue
FROM Payments
GROUP BY payment_type
ORDER BY Total_Revenue DESC;

SELECT
    payment_type,
    ROUND(AVG(payment_value),2) AS Avg_Payment
FROM Payments
GROUP BY payment_type
ORDER BY Avg_Payment DESC;

SELECT
    payment_type,
    ROUND(AVG(payment_installments * 1.0),2) AS Avg_Installments
FROM Payments
GROUP BY payment_type
ORDER BY Avg_Installments DESC;

SELECT TOP 1
    payment_type,
    COUNT(*) AS Number_of_Payments
FROM Payments
GROUP BY payment_type
ORDER BY Number_of_Payments DESC;

SELECT
SUM(price) AS Total_Revenue
FROM Order_Items;

SELECT
COUNT(*) AS Total_Orders
FROM Orders;

SELECT
COUNT(DISTINCT customer_unique_id) AS Total_Customers
FROM Customers;

SELECT
COUNT(*) AS Total_Sellers
FROM Sellers;

SELECT
AVG(Order_Total) AS Average_Order_Value
FROM
(
SELECT
order_id,
SUM(price) AS Order_Total
FROM Order_Items
GROUP BY order_id
) AS X;

SELECT
ROUND(AVG(review_score * 1.0),2) AS Average_Review
FROM Reviews;

Select 
Round(
Avg(DATEDIFF(Day,
order_purchase_timestamp,
order_delivered_customer_date)*1.0)
,2) As Average_Delivery_Days
From 
Orders
where 
order_status='delivered'
And order_delivered_customer_date Is Not Null

SELECT
ROUND(
100.0 *
SUM(
CASE
WHEN order_delivered_customer_date <= order_estimated_delivery_date
THEN 1
ELSE 0
END
)
/
COUNT(*),2
) AS On_Time_Delivery_Rate
FROM Orders
WHERE order_status='delivered'
AND order_delivered_customer_date IS NOT NULL;


