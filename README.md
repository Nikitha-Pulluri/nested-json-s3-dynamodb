# Project: Nested JSON ETL with Matillion, Snowflake, and DynamoDB

## Overview

This project demonstrates an end-to-end ETL pipeline that:

* Ingests **nested JSON** data from **AWS S3**
* Loads it into **Snowflake** via **Matillion DPC**
* Performs extensive **SQL transformations** (flattening, enrichment, aggregation)
* Exports the final output to **Parquet format** in S3
* Optionally loads the data into **DynamoDB** using an AWS Lambda function

---

## Input Data

**Source**: `stocks_sample_data.json`
**Format**: Nested JSON (e.g., brand, specs, stock\_info as nested objects)
**Uploaded to**: `s3://s3-matillion-dynamodb/input/`

---

## Step-by-Step Architecture

### 1. Load JSON from S3 to Snowflake

* Created a **JSON file format** in Snowflake
* Created an **external stage** pointing to the S3 bucket
* Created a staging table `stg_products (raw VARIANT)`
* Used **Matillion S3 Load** component to load data into the staging table

### 2. Transformations in Matillion

Built multiple SQL-based transformation jobs using Matillion:

#### `transformed_products` (flattened + enriched)

* Extracted nested fields
* Derived fields (e.g., `discounted_price`, `stock_value`)
* Applied tags and categories (e.g., `price_tag`, `weight_category`)
* Used date/time logic (e.g., `EXTRACT`, `DATEDIFF`)

#### Aggregated summary tables

* `summary_products_by_category`: `GROUP BY category`
* `warehouse_stock_summary`: `GROUP BY warehouse`
* `brand_discount_summary`: `GROUP BY brand_name, discount_tier`
* `monthly_sales_summary`: `GROUP BY EXTRACT(YEAR), EXTRACT(MONTH)`

---

## Export to Parquet (Snowflake to S3)

Used the following query in Matillion SQL Script component:

```sql
COPY INTO 's3://s3-matillion-dynamodb/transformed_products.parquet'
FROM transformed_products
FILE_FORMAT = (TYPE = PARQUET)
STORAGE_INTEGRATION = MY_S3_INTEGRATION
OVERWRITE = TRUE;
```

* Configured a Snowflake **STORAGE INTEGRATION**
* Updated IAM role and S3 bucket policy for access

---

## Load into DynamoDB

* Created a DynamoDB table `Products`
* Built a **Lambda function** to:

  * Trigger on Parquet file upload to S3
  * Read the Parquet file using `pyarrow` and `pandas`
  * Convert rows to JSON with `Decimal` conversion
  * Insert into DynamoDB using `boto3.put_item()`

---

## Tech Stack

* **AWS S3** – data storage
* **Matillion DPC** – orchestration and ELT
* **Snowflake** – cloud data warehouse
* **SQL** – transformations
* **Parquet** – columnar output format
* **AWS Lambda** – serverless loader
* **DynamoDB** – NoSQL target store

---

## Use Cases

* Showcases real-world ETL with semi-structured data
* Demonstrates SQL fluency (CASE, JOIN, GROUP BY, EXTRACT, DATEDIFF)
* Prepares data for both analytical and operational workloads

---

## Outcomes

* Successfully processed and enriched nested JSON using SQL
* Built multiple transformations and summaries
* Exported to Parquet
* Dynamically inserted into DynamoDB using Lambda

