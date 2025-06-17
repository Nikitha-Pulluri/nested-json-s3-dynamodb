SELECT
  raw:id::STRING AS product_id,
  raw:name::STRING AS product_name,
  raw:brand.name::STRING AS brand_name,
  raw:brand.origin_country::STRING AS origin_country,
  raw:category::STRING AS category,
  raw:stock_info.warehouse::STRING AS warehouse,
  raw:stock_info.stock::INT AS stock,
  raw:price::FLOAT AS price,
  raw:specs.color::STRING AS color,
  raw:specs.weight_grams::FLOAT AS weight_grams,
  raw:discounts.percent::FLOAT AS discount_percent,
  raw:discounts.valid_till::DATE AS valid_till,
  raw:added_on::DATE AS added_on,
  raw:is_active::BOOLEAN AS is_active,

  -- Derived fields
  ROUND(raw:price::FLOAT * (1 - raw:discounts.percent::FLOAT / 100), 2) AS discounted_price,
  raw:stock_info.stock::INT * raw:price::FLOAT AS stock_value,

  -- Classification tags
  CASE 
    WHEN raw:price::FLOAT >= 500 THEN 'Premium'
    WHEN raw:price::FLOAT >= 100 THEN 'Standard'
    ELSE 'Budget'
  END AS price_tag,

  CASE 
    WHEN raw:specs.weight_grams::FLOAT > 1000 THEN 'Heavy'
    WHEN raw:specs.weight_grams::FLOAT > 500 THEN 'Medium'
    ELSE 'Light'
  END AS weight_category,

  CASE 
    WHEN raw:stock_info.stock::INT = 0 THEN 'Out of Stock'
    WHEN raw:stock_info.stock::INT < 50 THEN 'Low Stock'
    WHEN raw:stock_info.stock::INT <= 200 THEN 'In Stock'
    ELSE 'Overstocked'
  END AS stock_status,

  CASE 
    WHEN raw:discounts.percent::FLOAT >= 50 THEN 'Huge Discount'
    WHEN raw:discounts.percent::FLOAT >= 20 THEN 'Moderate Discount'
    ELSE 'Minor Discount'
  END AS discount_tier,

  CASE 
    WHEN raw:is_active::BOOLEAN THEN 'Active'
    ELSE 'Inactive'
  END AS activity_flag,

  -- Time-based insights
  DATEDIFF(DAY, raw:discounts.valid_till::DATE, CURRENT_DATE()) AS days_since_discount_expired,
  EXTRACT(YEAR FROM raw:added_on::DATE) AS added_year,
  EXTRACT(MONTH FROM raw:added_on::DATE) AS added_month

FROM stg_specs
