# Olist Brazilian E-Commerce Dataset — Data Dictionary

This document describes the tables and columns used in the Olist SQL Data Analytics Project.

The project uses the **Brazilian E-Commerce Public Dataset by Olist**, a real but anonymized commercial dataset containing information about approximately 100,000 orders made between 2016 and 2018 through multiple marketplaces in Brazil. The dataset includes order, customer, product, seller, payment, shipping, review, and geographic information.

## Dataset Source

- **Dataset:** Brazilian E-Commerce Public Dataset by Olist
- **Provider:** Olist
- **Source:** Kaggle
- **Original data period:** 2016–2018
- **Format:** CSV
- **Number of related datasets:** 9
- **License:** CC BY-NC-SA 4.0

---

# 1. Customers

**Source file:** `olist_customers_dataset.csv`  
**Project table:** `Customers`

Contains information about customers associated with orders, including their location.

| Column | Description |
|---|---|
| `customer_id` | Unique identifier for the customer record associated with an order. Used to connect customers with orders. |
| `customer_unique_id` | Identifier representing the unique customer. This can be used to identify customers who placed multiple orders. |
| `customer_zip_code_prefix` | First five digits of the customer's Brazilian postal code. |
| `customer_city` | City associated with the customer's location. |
| `customer_state` | Brazilian state abbreviation associated with the customer's location. |

**Relationship:**

`Customers.customer_id` → `Orders.customer_id`

---

# 2. Orders

**Source file:** `olist_orders_dataset.csv`  
**Project table:** `Orders`

Contains order-level information and timestamps describing different stages of the order lifecycle.

| Column | Description |
|---|---|
| `order_id` | Unique identifier of an order. |
| `customer_id` | Identifier of the customer who placed the order. |
| `order_status` | Current status of the order, such as delivered, shipped, canceled, unavailable, processing, or invoiced. |
| `order_purchase_timestamp` | Date and time when the order was placed. |
| `order_approved_at` | Date and time when the order payment was approved. |
| `order_delivered_carrier_date` | Date and time when the order was handed over to the carrier. |
| `order_delivered_customer_date` | Date and time when the order was delivered to the customer. |
| `order_estimated_delivery_date` | Estimated delivery date associated with the order. |

**Relationships:**

- `Orders.customer_id` → `Customers.customer_id`
- `Orders.order_id` → `Order_Items.order_id`
- `Orders.order_id` → `Payments.order_id`
- `Orders.order_id` → `Reviews.order_id`

---

# 3. Order Items

**Source file:** `olist_order_items_dataset.csv`  
**Project table:** `Order_Items`

Contains information about individual products included in orders.

An order can contain multiple items, and different items within the same order can be fulfilled by different sellers.

| Column | Description |
|---|---|
| `order_id` | Identifier of the order containing the item. |
| `order_item_id` | Sequential number identifying an item within an order. |
| `product_id` | Identifier of the product purchased. |
| `seller_id` | Identifier of the seller responsible for the item. |
| `shipping_limit_date` | Date and time by which the seller is expected to ship the item. |
| `price` | Price of the product/item in Brazilian Reais (BRL). |
| `freight_value` | Freight/shipping charge associated with the item, in Brazilian Reais (BRL). |

**Relationships:**

- `Order_Items.order_id` → `Orders.order_id`
- `Order_Items.product_id` → `Products.product_id`
- `Order_Items.seller_id` → `Sellers.seller_id`

**Important note:**  
`order_id` is not unique in this table because an order can contain multiple items. The combination of `order_id` and `order_item_id` identifies an individual item within an order.

---

# 4. Payments

**Source file:** `olist_order_payments_dataset.csv`  
**Project table:** `Payments`

Contains payment information associated with orders.

A single order can have multiple payment records.

| Column | Description |
|---|---|
| `order_id` | Identifier of the order associated with the payment. |
| `payment_sequential` | Sequential number identifying a payment within an order. |
| `payment_type` | Payment method used for the transaction, such as credit card, boleto, voucher, or debit card. |
| `payment_installments` | Number of installments selected for the payment. |
| `payment_value` | Payment amount in Brazilian Reais (BRL). |

**Relationship:**

`Payments.order_id` → `Orders.order_id`

**Important note:**  
`order_id` is not necessarily unique in this table because an order may have multiple payment records.

---

# 5. Reviews

**Source file:** `olist_order_reviews_dataset.csv`  
**Project table:** `Reviews`

Contains customer satisfaction ratings and written review information associated with orders.

| Column | Description |
|---|---|
| `review_id` | Identifier of the review. |
| `order_id` | Identifier of the order associated with the review. |
| `review_score` | Customer rating on a scale from 1 to 5. |
| `review_comment_title` | Title of the customer's written review, when provided. |
| `review_comment_message` | Written review message, when provided. |
| `review_creation_date` | Date and time associated with the creation of the review record/satisfaction survey. |
| `review_answer_timestamp` | Date and time when the customer answered the review/satisfaction survey. |

**Relationship:**

`Reviews.order_id` → `Orders.order_id`

**Important note:**  
`order_id` should not automatically be assumed to be unique in this table. Review records should be analyzed according to the actual data and the project's validation checks.

---

# 6. Products

**Source file:** `olist_products_dataset.csv`  
**Project table:** `Products`

Contains descriptive and physical attributes of products listed on the Olist marketplace.

| Column | Description |
|---|---|
| `product_id` | Unique identifier of a product. |
| `product_category_name` | Product category name in Portuguese. |
| `product_name_lenght` | Number of characters in the product name. The spelling `lenght` is retained from the original dataset. |
| `product_description_lenght` | Number of characters in the product description. The spelling `lenght` is retained from the original dataset. |
| `product_photos_qty` | Number of photographs associated with the product. |
| `product_weight_g` | Product weight in grams. |
| `product_length_cm` | Product length in centimeters. |
| `product_height_cm` | Product height in centimeters. |
| `product_width_cm` | Product width in centimeters. |

**Relationships:**

- `Products.product_id` → `Order_Items.product_id`
- `Products.product_category_name` → `Category_Translation.product_category_name` for available translations.

---

# 7. Sellers

**Source file:** `olist_sellers_dataset.csv`  
**Project table:** `Sellers`

Contains identification and location information for sellers using the Olist marketplace.

| Column | Description |
|---|---|
| `seller_id` | Unique identifier of a seller. |
| `seller_zip_code_prefix` | First five digits of the seller's Brazilian postal code. |
| `seller_city` | City associated with the seller's location. |
| `seller_state` | Brazilian state abbreviation associated with the seller's location. |

**Relationship:**

`Sellers.seller_id` → `Order_Items.seller_id`

---

# 8. Geolocation

**Source file:** `olist_geolocation_dataset.csv`  
**Project table:** `Geolocation`

Contains geographic information associated with Brazilian postal code prefixes, including latitude and longitude coordinates.

| Column | Description |
|---|---|
| `geolocation_zip_code_prefix` | First five digits of a Brazilian postal code. |
| `geolocation_lat` | Latitude associated with the postal code/location. |
| `geolocation_lng` | Longitude associated with the postal code/location. |
| `geolocation_city` | City associated with the geographic record. |
| `geolocation_state` | Brazilian state associated with the geographic record. |

**Important note:**  
`geolocation_zip_code_prefix` is not a unique identifier. Multiple geographic records can exist for the same postal code prefix, so joins involving this column should be handled carefully to avoid unintentionally multiplying rows.

The table can be associated with customer and seller locations through their respective postal code prefixes.

---

# 9. Category Translation

**Source file:** `product_category_name_translation.csv`  
**Project table:** `Category_Translation`

Provides English translations for product category names originally recorded in Portuguese.

| Column | Description |
|---|---|
| `product_category_name` | Product category name in Portuguese. |
| `product_category_name_english` | English translation of the product category name. |

**Join relationship:**

`Products.product_category_name`  
→ `Category_Translation.product_category_name`

**Important note:**  
This is a translation/reference table rather than a transaction table. A category can only be translated when a corresponding entry exists in the translation dataset.

---

# Key Table Relationships

The main relationships used in the project can be represented as:

```text
Customers
    │
    │ customer_id
    ▼
Orders
    │
    ├──────── order_id ────────► Order_Items
    │                              │
    │                              ├── product_id ──► Products
    │                              │                    │
    │                              │                    └── product_category_name
    │                              │                              │
    │                              │                              ▼
    │                              │                     Category_Translation
    │                              │
    │                              └── seller_id ───► Sellers
    │
    ├──────── order_id ────────► Payments
    │
    └──────── order_id ────────► Reviews
```

The `Geolocation` table provides geographic information that can be associated with customer and seller postal code prefixes.

---

# Important Data Structure Notes

### Order-level vs. item-level data

`Orders` contains one record per order, while `Order_Items` contains records for individual items within those orders.

Therefore:

```text
One Order
   ↓
One or more Order Items
```

An order may also involve multiple sellers because different items in the same order can be fulfilled by different sellers.

### Payments

An order can have multiple payment records. Therefore, joining `Orders` directly to `Payments` can duplicate order-level rows if aggregation is not handled appropriately.

### Reviews

Review records should be treated separately from order-level records when calculating order or customer metrics. The actual relationship and possible duplicates should be verified during data-quality analysis.

### Customer identifiers

`customer_id` identifies the customer record associated with an order, while `customer_unique_id` can be used to identify the same customer across multiple orders.

This distinction is important when calculating metrics such as repeat customers and number of orders per customer.

### Geolocation

Postal code prefixes in the geolocation dataset are not unique. A direct join without accounting for this can produce duplicate or inflated results.

### Product categories

Product categories are stored in Portuguese in the `Products` table. `Category_Translation` provides corresponding English category names where a translation is available.

---

# Source and Attribution

**Dataset:** Brazilian E-Commerce Public Dataset by Olist  
**Provider:** Olist  
**Source:** Kaggle

The dataset was released by Olist as anonymized commercial data for public analysis and research. The original dataset contains approximately 100,000 orders from 2016–2018.

For the original dataset and full schema, refer to the official Kaggle dataset:

https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce