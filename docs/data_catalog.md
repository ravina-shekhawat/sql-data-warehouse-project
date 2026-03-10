## Overview
The Gold Layer is the business-level data representation , structured to support analytical and reproting use cases. it consists of  **dimension 
tables** and **fact tables** for specific business metrics.

---
### 1. gold.dim_customers
- **Purpose:** Stores customer details enriched with demographic and geographic data.
- **Columns:** 

| Column Name | Date Type | Description |
|-------------|-----------|-------------|
|customer_key|INT| Surrogate key uniquely identifying each customer record in the dimension table.|
|customer_id|INT|Unique numerical identifier assigned to each customer.|
|customer_number|NVARCHAR(50)|Alphanumeric identifier representing the customer,used for tracking and referencing.|
|first_name|NVARCHAR(50)|The customer's first name, as recorded in the system.|
|last_name|NVARCHAR(50)| The customer's last name or family name.|
|country|NVARCHAR(50)|The country of residence for the customer(e.g.'India').|
|marital_status|NVARCHAR(50)|The marital status of the customer(e.g.'Married','Single'). |
|gender|NVARCHAR(50)|The gender of the customer(e.g.'Male','Female','n/a').|
|birthdate|DATE|The date of birth of the customer, formatted as YYYY-MM-DD (e.g. 1998-10-06)|.
|create_date|DATE|The date and time when the customer record was created in the system.

---
### 2. gold.dim_products
- **Purpose:** Provides information about the products and attributes.
- **Columns:**

| Column Name | Date Type | Description |
|-------------|-----------|-------------|
|product_key|INT|Surrogate key uniquely identifying each product record in the product dimension table.|
|product_id|INT|A unique identifier assigned to the product for internal tracking and referencing.|
|Product_number|NVARCHAR(50)|A structured alphanumeric code representing the product , ofthen used for categorization or inventory.|
|category_id|NVARCHAR(50)|A unique identifier for the product's category, linking to its high-level classification.|
||




