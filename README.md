---------

# Olist SQL Data Analysis

Project overview, analysis, and business questions for the Olist Brazilian e‑commerce dataset — implemented as T-SQL scripts for Microsoft SQL Server.

---

## 1. Project title
Olist SQL Data Analysis

---

## 2. Project overview
This repository contains a structured SQL-based data analytics project built on the public "Brazilian E‑Commerce Public Dataset by Olist". The project prepares a relational schema from staging CSV imports, performs data cleaning and validation, explores the data with descriptive queries, and runs business-level analyses to produce revenue, customer, seller, product, delivery, payments and review-related KPIs.

Repository artifacts are implemented as T-SQL scripts (designed for Microsoft SQL Server / T-SQL).

---

## 3. Business objective
- Prepare and validate the Olist dataset in a relational schema and compute business metrics to support revenue reporting, customer and seller analysis, product/category performance, delivery performance, and payment/review relationships.
- Provide a reproducible SQL codebase (ETL-ish scripts + data-quality checks + exploration + business analysis) so analysts or stakeholders can run and review the results.

---

## 4. Dataset description
Source (documented in repository):
- Dataset: Brazilian E‑Commerce Public Dataset by Olist
- Provider: Olist
- Source: Kaggle (reference in data dictionary)
- Period: 2016–2018 (as described in the repository data dictionary)
- Format: CSV (multiple related files)
- License: CC BY‑NC‑SA 4.0 (noted in the repository data dictionary)

Common source CSVs described in the data dictionary:
- olist_customers_dataset.csv
- olist_orders_dataset.csv
- olist_order_items_dataset.csv
- olist_order_payments_dataset.csv
- olist_order_reviews_dataset.csv
- olist_products_dataset.csv
- olist_sellers_dataset.csv
- olist_geolocation_dataset.csv
- product_category_name_translation.csv

Data dictionary file: `Data/Olist Data Dictionary.md`

---

## 5. Database schema / tables
The SQL scripts create/operate on the following tables (target tables shown; source staging tables are named with a `1` suffix in the repository scripts, e.g., `Orders1`):

- Customers
  - customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state
- Orders
  - order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at, order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date
- Order_Items
  - order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value
- Products
  - product_id, product_category_name, product_name_lenght, product_description_lenght, product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm
- Payments
  - order_id, payment_sequential, payment_type, payment_installments, payment_value
- Reviews
  - review_id, order_id, review_score, review_comment_title, review_comment_message, review_creation_date, review_answer_timestamp
- Sellers
  - seller_id, seller_zip_code_prefix, seller_city, seller_state
- Geolocation
  - geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state
- Category_Translation
  - product_category_name, product_category_name_english

Note: staging/source tables used by the ETL script are referenced as Orders1, Order_Items1, Sellers1, Reviews1, Payments1, Geolocation1, etc. The repository scripts assume those staging tables (or equivalent CSV imports) are available.

The primary key constraints are set in the schema script (see Olist.sql), e.g., PKs created for Orders, Customers, Products, Sellers, Payments, Order_Items, Reviews, and Category_Translation.

Schema / loading script: `SQL/Olist.sql`

---

## 6. Tools and technologies
- SQL dialect: T-SQL / Microsoft SQL Server (scripts use DATETIME2, TRY_CAST, DATENAME, TOP, GO, sp_rename, etc.)
- Everything in the repository is implemented as SQL scripts; no additional code languages are present.
- Data dictionary, documentation: Markdown.

Files:
- ETL / schema adjustments: `SQL/Olist.sql`
- Data quality checks: `SQL/Data_Quality_Assessment.sql`
- Exploratory analysis: `SQL/Data_Exploration.sql`
- Business analysis: `SQL/Business_Analysis.sql`

---

## 7. Data cleaning and validation
The repository implements the following data-cleaning and validation steps (as T-SQL operations and QA queries):

- Type coercion and safe casting:
  - Loading scripts use TRY_CAST when inserting from staging to the final tables to convert strings to DATETIME2, INT, DECIMAL, etc. Invalid casts become NULL so loading does not fail.
- Column adjustments:
  - ALTER TABLE statements to allow NULLs on certain Products numeric columns before load.
- Category translation cleanup:
  - Category_Translation table header-like row detected and removed; columns renamed from generic column1/column2 to product_category_name/product_category_name_english.
- Primary key enforcement:
  - Primary keys are added after loading and duplicate checks (e.g., Orders.order_id, Customers.customer_id).
- Data-quality checks (in Data_Quality_Assessment.sql):
  - Row counts per table.
  - Duplicate-key detection for primary-key candidates and composite keys (e.g., (order_id, order_item_id), (order_id, payment_sequential)).
  - NULL/missing counts for important dates and product attributes.
  - Detection of negative/zero prices or freight and zero/invalid payments.
  - Logical date-order checks (e.g., delivered before purchase).
  - Referential integrity checks (orphan records) via LEFT JOINs.
  - Suspicious status combinations (e.g., canceled orders with delivered date present).

---

## 8. SQL techniques used
The scripts make extensive use of standard T‑SQL constructs and functions, including:
- DDL: CREATE TABLE, ALTER TABLE, EXEC sp_rename
- DML: INSERT SELECT with TRY_CAST
- Constraints: PRIMARY KEY creation
- Joins: INNER JOIN, LEFT JOIN
- Aggregation and grouping: GROUP BY, HAVING, COUNT, SUM, AVG
- Date/time and time-delta functions: YEAR(), MONTH(), DATENAME(), DATEDIFF()
- Conditional expressions: CASE WHEN
- Ordering and limiting: ORDER BY, TOP
- Numeric formatting/rounding: ROUND
- Null-safe aggregation and pattern checks
- Referential integrity and orphan detection via LEFT JOIN / IS NULL checks

---

## 9. Analysis performed
The repository contains two main analysis scripts:

- Exploratory data analysis (SQL/Data_Exploration.sql)
  - Business size metrics (counts of customers, unique customers, orders, sellers, products, categories).
  - Time-series exploration (first/last order dates, orders by year and month).
  - Order and status distributions (percent delivered, canceled, in-progress).
  - Customer geography (customers by state/city, top-10 lists).
  - Product attributes by category (counts, avg weight, photo counts, description length).
  - Seller distributions by state/city.
  - Payments exploration (payment types, averages, installments).
  - Reviews exploration (avg score, distribution, comments vs ratings-only).
  - Bonus descriptive metrics (avg orders per customer, avg items per order, avg freight, top expensive products).

- Business analysis (SQL/Business_Analysis.sql)
  - Revenue KPIs (total price revenue, freight revenue, gross revenue, average order value, monthly revenue).
  - Revenue by geography and time (by state/city, by year/month).
  - Customer value and retention (avg revenue per customer, top customers, repeat vs one-time customers).
  - Product/category performance (revenue and units by translated category, avg price/freight by category, top categories).
  - Seller performance (seller revenue, top sellers, unique-products per seller, seller review averages).
  - Delivery performance (avg delivery/shipping days, on-time delivery percentage, early/late delivery counts, delivery by state/category).
  - Relationship analyses (delivery speed vs review scores, payment type vs average review).

Files:
- `SQL/Data_Exploration.sql`
- `SQL/Business_Analysis.sql`

---

## 10. Key business questions
(The scripts encode these questions; numeric answers are not included here — see "Key findings" below for result placeholders.)

- How much revenue did the platform generate (price, freight, gross)?
- What is the average order value and average monthly revenue?
- Which months/years generate the most/least revenue (seasonality)?
- Which product categories drive the most revenue and units sold?
- Who are the top customers and what is the average revenue per customer?
- What share of customers are repeat vs one-time?
- Which states/cities drive the most revenue?
- Which sellers earn the most and which have the largest assortments?
- What are the average delivery and shipping times, and what share of deliveries are on-time?
- How does delivery speed relate to review score?
- How do payment types contribute to revenue and reviews?

These questions are implemented as queries across the exploratory and business analysis scripts.

---
## 11. Key findings

### Revenue
- Total item revenue: **R$13,496,408.43**
- Total freight revenue: **R$2,241,259.09**
- Gross revenue (item price + freight): **R$15,737,667.52**
- Average order value: **R$160.25**

### Customers
- Average revenue per customer: **R$165.68**
- One-time customers: **92,636 (96.94%)**
- Repeat customers: **2,924 (3.06%)**
- The highest-spending customer generated **R$13,664.08** across one order.

### Products and categories
- Top category by revenue: **health_beauty — R$1,255,695.13**
- Top category by units sold: **bed_bath_table — 11,097 units**
- Other high-revenue categories include watches_gifts, bed_bath_table, sports_leisure, and computers_accessories.

### Delivery and customer satisfaction
- Average delivery time: **12.5 days**
- On-time delivery rate: **91.89%**
- 5-star reviews represented **57.78%** of all reviews.
- Average review score decreased as delivery time increased:
  - 0–7 days: **4.41**
  - 8–14 days: **4.30**
  - 15–21 days: **4.12**
  - 22+ days: **3.06**

### Data quality
- No duplicate primary-key values were identified in Customers, Orders, Products, or Sellers.
- No negative prices or freight values were identified.
- No orphan order-item, payment, or review records were identified.
- Missing operational dates were identified in Orders:
  - Approval date: **160**
  - Carrier date: **1,783**
  - Customer delivery date: **2,965**
  - Estimated delivery date: **0**

---

## 12. Business insights
The repository contains analyses that enable the following types of insight; actual statements require execution of the SQL to convert query outputs into conclusions. All items below are supported by queries in the repository; the specific insights are left to results after running the queries.

- Where the business derives most revenue (categories, states, months) — computed via revenue-by-category and revenue-by-geography queries.
- Customer value segmentation (top customers, avg revenue per customer, repeat customer share) — computed via customer-level aggregations.
- Seller performance and product assortment signals (seller revenue, unique products per seller, seller review averages).
- Delivery performance and its relationship to customer satisfaction (avg delivery times, on-time % and review score by delivery speed).
- Payment method contribution and potential correlations with review scores.

All of the above depend on running the SQL and interpreting the numeric outputs.

---

## 13. Recommendations
Based on the analyses implemented in the repository, typical next steps an analyst or business stakeholder would take are:

- Run the Data_Quality_Assessment.sql and remediate large data issues before downstream reporting (duplicate keys, null/invalid dates, negative/zero monetary values, orphan rows).
- Use the business-analysis queries to produce executive dashboards (total/gross revenue, AOV, top categories/states, top customers, on-time delivery rate).
- Investigate any high-value sellers or customers identified by the queries to inform partnership and retention strategies.
- Examine categories with high freight or long delivery times (queries already present) and consider logistics optimization for those categories.
- Cross-check payment type vs review score outputs and investigate whether payment-related processes affect satisfaction.

Note: the repository provides the queries to compute the above; concrete recommendations should be tailored to numeric outputs after running the scripts. Replace [RESULT NEEDED] with actual numbers to finalize recommendations.

---

## 14. Limitations
The repository and the scripts include these limitations and assumptions (explicit in the SQL and data dictionary):

- The SQL scripts are written for Microsoft SQL Server / T‑SQL and use server-specific functions (e.g., TRY_CAST, DATETIME2, DATENAME, sp_rename, TOP). Running on other SQL engines will require adaptation.
- The ETL script expects staging tables (e.g., Orders1, Order_Items1, Reviews1, Payments1, Sellers1, Geolocation1) to be created and populated from CSV imports before running the transformation steps. Those CSV import steps are not included in the repository.
- TRY_CAST is used to avoid load failures; invalid values become NULL. This preserves load but requires careful examination of NULLs after casting (the repository includes QA queries for this purpose).
- Geolocation joins can multiply rows because the geolocation table uses zip-code prefixes that are not unique. The data dictionary warns join behavior must be handled carefully to avoid inflated aggregates.
- Payments, Order_Items and Reviews can have multiple rows per order; naive joins can double-count revenue or other order-level metrics if aggregation is not applied correctly. The repository queries are generally aware of this.
- The repository contains SQL queries and checks but does not persist or visualize numeric results — execution against the dataset is needed to obtain numbers.
- No automated remediation beyond casting and simple header deletion is implemented; most QA checks return result sets for manual inspection.

---

## 15. Project structure
Top-level files and folders (as present in the repository):

- SQL/
  - Olist.sql — schema creation, type casting, insert-from-staging, simple cleaning and PK creation
    - Link: `SQL/Olist.sql`
  - Data_Quality_Assessment.sql — comprehensive data-quality checks and validation queries
    - Link: `SQL/Data_Quality_Assessment.sql`
  - Data_Exploration.sql — exploratory data analysis queries (business familiarization)
    - Link: `SQL/Data_Exploration.sql`
  - Business_Analysis.sql — KPI and business-level analyses (revenue, delivery, sellers, categories)
    - Link: `SQL/Business_Analysis.sql`

- Data/
  - Olist Data Dictionary.md — detailed descriptions of CSV source files, columns, and relationships
    - Link: `Data/Olist Data Dictionary.md`

- README.md.txt — empty/unused (repository README placeholder)

---

## How to reproduce / run (notes)
1. Create a Microsoft SQL Server database named `Olist_Project` (scripts assume `USE Olist_Project`).
2. Import the original CSV source files into staging tables referenced by Olist.sql (the repository expects tables like `Orders1`, `Order_Items1`, `Payments1`, `Reviews1`, `Sellers1`, `Geolocation1`, etc.). The repository does not include the CSV import steps.
3. Run `SQL/Olist.sql` to create target tables, cast types, and insert data from staging tables.
4. Run `SQL/Data_Quality_Assessment.sql` to review data-quality issues and decide remediation actions.
5. Run `SQL/Data_Exploration.sql` and `SQL/Business_Analysis.sql` to generate exploratory and business-level metrics.
6. Export query outputs to visualization tools or notebooks if needed (visualization is not included in the repository).

---

## Contact / notes
- The repository provides the SQL queries and data dictionary needed to prepare and analyze the Olist dataset. Numeric outputs and dashboards are not included; run the provided scripts against the dataset to produce results.
- All conclusions that require numeric outputs are left as [RESULT NEEDED] and should be replaced after script execution.

---
