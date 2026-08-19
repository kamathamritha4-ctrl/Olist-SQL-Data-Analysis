USE Olist_Project;
GO

SELECT TOP 20
    c.customer_unique_id,
    SUM(oi.price) AS Total_Revenue
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
JOIN Order_Items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
ORDER BY Total_Revenue DESC;

With CustomerRevenue As
(
SELECT 
    c.customer_unique_id,
    SUM(oi.price) AS Revenue
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
JOIN Order_Items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
)

Select
customer_unique_id,
Revenue,
Case
When Revenue>=1000 Then 'Gold'
When Revenue>=500 Then 'Silver'
Else 'Bronze'
End As Customer_Segment
From CustomerRevenue
Order By Revenue DESC


SELECT TOP 20
c.customer_unique_id,
COUNT(o.order_id) AS Total_Orders
FROM Customers c
JOIN Orders o
ON c.customer_id=o.customer_id
GROUP BY c.customer_unique_id
ORDER BY Total_Orders DESC;


Select ct.product_category_name_english,
Sum(oi.price) As Revenue,
Round(
100.0*
Sum(oi.price)/
Sum(Sum(oi.price)) Over(),
2) As Revenue_Percentage
From Products p
Join Order_Items oi
On p.product_id=oi.product_id
Left Join Category_Translation ct
On p.product_category_name=ct.product_category_name
Group By ct.product_category_name_english
Order By Revenue DESC

Select ct.product_category_name_english As Category,
SUM(oi.price) As Revenue,
Count(*) As Order_Items_Sold
From Products p
Join Order_Items oi
On oi.product_id=p.product_id
Left Join Category_Translation ct
On p.product_category_name=ct.product_category_name
Group By ct.product_category_name_english
Order By Order_Items_Sold DESC

Select ct.product_category_name_english As Category,
Avg(oi.price) As Avg_Selling_Price,
Count(*) As Products_Sold
From Products p
Join Order_Items oi
On oi.product_id=p.product_id
Left Join Category_Translation ct
On p.product_category_name=ct.product_category_name
Group By ct.product_category_name_english
Order By Avg_Selling_Price DESC

Select ct.product_category_name_english As Category,
SUM(oi.price) As Revenue,
Round(
100.0*
Sum(oi.price)/
Sum(Sum(oi.price)) Over(),
2) As Revenue_Percentage,
Count(*) As Products_Sold,
Avg(oi.price) As Avg_Selling_Price
From Products p
Join Order_Items oi
On oi.product_id=p.product_id
Left Join Category_Translation ct
On p.product_category_name=ct.product_category_name
Group By ct.product_category_name_english
Order By Revenue DESC

Select seller_id, 
SUM(price) As Revenue,
Rank() Over(Order By SUM(price) DESC) AS Seller_Rank
From Order_Items
Group By seller_id
Order By Revenue DESC

Select oi.seller_id, 
SUM(oi.price) As Revenue,
s.seller_state As Seller_State,
Rank() Over(
Partition By s.seller_state
Order By SUM(oi.price) DESC
) AS Seller_Rank
From Order_Items oi
Join Sellers s
On oi.seller_id=s.seller_id
Group By oi.seller_id,s.seller_state
Order By s.seller_state,Seller_Rank



With SellerRanking As
(Select oi.seller_id, 
SUM(oi.price) As Revenue,
s.seller_state As Seller_State,
Rank() Over(
Partition By s.seller_state
Order By SUM(oi.price) DESC
) AS Seller_Rank
From Order_Items oi
Join Sellers s
On oi.seller_id=s.seller_id
Group By oi.seller_id,s.seller_state

)
Select * From SellerRanking
Where Seller_Rank<=5
Order By Seller_State,Seller_Rank

Select
Avg(
DATEDIFF(DAY,order_purchase_timestamp,order_delivered_customer_date)
) As Avg_Delivery_Date
From Orders
Where order_delivered_customer_date Is Not Null



WITH DeliveryStatus AS
(
    SELECT
        CASE
            WHEN order_delivered_customer_date <= order_estimated_delivery_date
                THEN 'On Time'
            ELSE 'Late'
        END AS Delivery_Status
    FROM Orders
    WHERE order_delivered_customer_date IS NOT NULL
      AND order_estimated_delivery_date IS NOT NULL
)

SELECT
    Delivery_Status,
    COUNT(*) AS Total_Orders
FROM DeliveryStatus
GROUP BY Delivery_Status;



With DeliveryStatus As(
Select order_id, 
Case
When order_delivered_customer_date<=order_estimated_delivery_date
Then 'On Time'
Else 'Late'
End As Delivery_Status
From Orders
WHERE order_delivered_customer_date IS NOT NULL
)
Select ds.Delivery_Status, Round(Avg(r.review_score),2)
As Review_Score
From DeliveryStatus ds
Join Reviews r
On ds.order_id=r.order_id
Group By ds.Delivery_Status
Order By Review_Score;



With MonthlyRevenue As
(Select Year(o.order_purchase_timestamp) As Year,
Month(o.order_purchase_timestamp) As Month,
SUM(oi.price) As Revenue
From Orders o
Join Order_Items oi
On o.order_id=oi.order_id
Group By Year(o.order_purchase_timestamp),
Month(o.order_purchase_timestamp)
)
,RevenueTrend AS
(
SELECT
Year,
Month,
Revenue,
LAG(Revenue)
OVER(ORDER BY Year,Month)
AS Previous_Month_Revenue
FROM MonthlyRevenue
)
Select Year,
Month,
Revenue,
Previous_Month_Revenue,
Revenue-Previous_Month_Revenue As Revenue_Growth,
Round((100.0*(Revenue-Previous_Month_Revenue)
)/
Nullif(Previous_Month_Revenue,0),2) As Growth_Percentage,
SUM(Revenue)
OVER(
    ORDER BY Year, Month
) As Cumulative_Revenue
From RevenueTrend
ORDER BY
Year,
Month;

SELECT
    c.customer_unique_id,
    COUNT(*) AS No_Of_Orders
 FROM Orders o
JOIN Customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(*) > 1
ORDER BY No_Of_Orders DESC;

Select c.customer_unique_id,
o.order_id,
o.order_purchase_timestamp,
ROW_NUMBER() Over(Partition By c.customer_unique_id 
Order By o.order_purchase_timestamp) As Row_No
From Customers c
Join Orders o
On c.customer_id=o.customer_id

SELECT
    MAX(Row_No) AS Highest_Purchase_Number
FROM
(
    SELECT
        c.customer_unique_id,
        ROW_NUMBER() OVER
        (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS Row_No
    FROM Customers c
    JOIN Orders o
        ON c.customer_id = o.customer_id
) AS CustomerOrders;

WITH CustomerOrders AS
(
    SELECT
        c.customer_unique_id,
        ROW_NUMBER() OVER
        (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS Purchase_Number
    FROM Customers c
    JOIN Orders o
        ON c.customer_id = o.customer_id
)

SELECT
    Purchase_Number,
    COUNT(*) AS Customers
FROM CustomerOrders
GROUP BY Purchase_Number
ORDER BY Purchase_Number;


WITH CustomerPurchases AS
(
    SELECT
        c.customer_unique_id,
        ROW_NUMBER() OVER
        (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS Purchase_Number
    FROM Customers c
    JOIN Orders o
        ON c.customer_id = o.customer_id
),

CustomerRetentionSummary AS
(
    SELECT
        COUNT(DISTINCT customer_unique_id) AS Total_Customers,

        (
            SELECT COUNT(DISTINCT customer_unique_id)
            FROM CustomerPurchases
            WHERE Purchase_Number >= 2
        ) AS Repeat_Customers

    FROM CustomerPurchases
)

SELECT
    Total_Customers,
    Repeat_Customers,

    ROUND
    (
        100.0 * Repeat_Customers
        / Total_Customers,
        2
    ) AS Repeat_Purchase_Rate

FROM CustomerRetentionSummary; 


