USE Olist_Project;
GO


ALTER TABLE Products
ALTER COLUMN product_name_lenght INT NULL;

ALTER TABLE Products
ALTER COLUMN product_description_lenght INT NULL;

ALTER TABLE Products
ALTER COLUMN product_photos_qty INT NULL;

ALTER TABLE Products
ALTER COLUMN product_weight_g INT NULL;

ALTER TABLE Products
ALTER COLUMN product_length_cm INT NULL;

ALTER TABLE Products
ALTER COLUMN product_height_cm INT NULL;

ALTER TABLE Products
ALTER COLUMN product_width_cm INT NULL;


Create Table Orders(
order_id Char(32),
customer_id Char(32),
order_status nvarchar(30),
order_purchase_timestamp Datetime2,
order_approved_at DATETIME2 NULL,
order_delivered_carrier_date Datetime2 Null,
order_delivered_customer_date Datetime2 Null,
order_estimated_delivery_date Datetime2
)
Insert into Orders(order_id,customer_id,order_status,order_purchase_timestamp,
order_approved_at,order_delivered_carrier_date,order_delivered_customer_date,
order_estimated_delivery_date)
Select
Try_Cast(order_id as Char(32)),
Try_Cast(customer_id as Char(32)),
Try_Cast(order_status as nvarchar(30)),
Try_Cast(order_purchase_timestamp as Datetime2),
Try_Cast(order_approved_at as DATETIME2),
Try_Cast(order_delivered_carrier_date as Datetime2),
Try_Cast(order_delivered_customer_date as Datetime2),
Try_Cast(order_estimated_delivery_date as Datetime2)
From dbo.Orders1;

CREATE TABLE Order_Items
(
    order_id CHAR(32),
    order_item_id INT,
    product_id CHAR(32),
    seller_id CHAR(32),
    shipping_limit_date DATETIME2,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);

INSERT INTO Order_Items
(
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
)
SELECT
    order_id,
    TRY_CAST(order_item_id AS INT),
    product_id,
    seller_id,
    TRY_CAST(shipping_limit_date AS DATETIME2),
    TRY_CAST(price AS DECIMAL(10,2)),
    TRY_CAST(freight_value AS DECIMAL(10,2))
FROM dbo.Order_Items1;


CREATE TABLE Sellers
(
    seller_id CHAR(32),
    seller_zip_code_prefix INT,
    seller_city NVARCHAR(100),
    seller_state CHAR(2)
);

INSERT INTO Sellers
(
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
)
SELECT
    seller_id,
    TRY_CAST(seller_zip_code_prefix AS INT),
    seller_city,
    seller_state
FROM Sellers1;


CREATE TABLE Reviews
(
    review_id CHAR(32),
    order_id CHAR(32),
    review_score INT,
    review_comment_title NVARCHAR(200) NULL,
    review_comment_message NVARCHAR(MAX) NULL,
    review_creation_date DATETIME2,
    review_answer_timestamp DATETIME2
);

INSERT INTO Reviews
(
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
)
SELECT
    review_id,
    order_id,
    TRY_CAST(review_score AS INT),
    review_comment_title,
    review_comment_message,
    TRY_CAST(review_creation_date AS DATETIME2),
    TRY_CAST(review_answer_timestamp AS DATETIME2)
FROM Reviews1;

CREATE TABLE Payments
(
    order_id CHAR(32),
    payment_sequential INT,
    payment_type NVARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(10,2)
);

INSERT INTO Payments
(
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
)
SELECT
    order_id,
    TRY_CAST(payment_sequential AS INT),
    payment_type,
    TRY_CAST(payment_installments AS INT),
    TRY_CAST(payment_value AS DECIMAL(10,2))
FROM Payments1;

Select * from Category_Translation

DELETE FROM Category_Translation
WHERE column1 = 'product_category_name'
  AND column2 = 'product_category_name_english';

-- Rename column1 to product_category_name
EXEC sp_rename 'Category_Translation.column1', 'product_category_name', 'COLUMN';

-- Rename column2 to product_category_name_english
EXEC sp_rename 'Category_Translation.column2', 'product_category_name_english', 'COLUMN';

CREATE TABLE Geolocation
(
    geolocation_zip_code_prefix INT,
    geolocation_lat DECIMAL(10,7),
    geolocation_lng DECIMAL(10,7),
    geolocation_city NVARCHAR(100),
    geolocation_state CHAR(2)
);

INSERT INTO Geolocation
(
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
)
SELECT
    TRY_CAST(geolocation_zip_code_prefix AS INT),
    TRY_CAST(geolocation_lat AS DECIMAL(10,7)),
    TRY_CAST(geolocation_lng AS DECIMAL(10,7)),
    geolocation_city,
    geolocation_state
FROM Geolocation1;

SELECT customer_id, COUNT(*)
FROM Customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT *
FROM Customers
WHERE customer_id IS NULL;

ALTER TABLE Customers
ADD CONSTRAINT PK_Customers
PRIMARY KEY (customer_id);

SELECT order_id, COUNT(*)
FROM Orders
GROUP BY order_id
HAVING COUNT(*) > 1;

SELECT *
FROM Orders
WHERE order_id IS NULL;

ALTER TABLE Orders
ALTER COLUMN order_id CHAR(32) NOT NULL;

ALTER TABLE Orders
ADD CONSTRAINT Pk_Orders
PRIMARY KEY (order_id);

ALTER TABLE Sellers
ALTER COLUMN seller_id CHAR(32) NOT NULL;

ALTER TABLE Sellers
ADD CONSTRAINT PK_Sellers
PRIMARY KEY (seller_id);

ALTER TABLE Products
ADD CONSTRAINT PK_Products
PRIMARY KEY (product_id);

ALTER TABLE Reviews
ALTER COLUMN review_id CHAR(32) NOT NULL;

ALTER TABLE Reviews
ALTER COLUMN order_id CHAR(32) NOT NULL;

ALTER TABLE Reviews
ADD CONSTRAINT PK_Reviews
PRIMARY KEY (review_id, order_id);

ALTER TABLE Payments
ALTER COLUMN order_id CHAR(32) NOT NULL;

ALTER TABLE Payments
ALTER COLUMN payment_sequential INT NOT NULL;

ALTER TABLE Payments
ADD CONSTRAINT PK_Payments
PRIMARY KEY(order_id, payment_sequential);

ALTER TABLE Order_Items
ALTER COLUMN order_id CHAR(32) NOT NULL;

ALTER TABLE Order_Items
ALTER COLUMN order_item_id INT NOT NULL;

ALTER TABLE Order_Items
ADD CONSTRAINT PK_Order_Items
PRIMARY KEY(order_id, order_item_id);

ALTER TABLE Category_Translation
ALTER COLUMN product_category_name NVARCHAR(100) NOT NULL;

ALTER TABLE Category_Translation
ADD CONSTRAINT PK_CategoryTranslation
PRIMARY KEY(product_category_name);
