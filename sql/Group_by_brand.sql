SELECT
  raw:brand.name::STRING AS brand_name,
  CASE 
    WHEN raw:discounts.percent::FLOAT >= 50 THEN 'Huge Discount'
    WHEN raw:discounts.percent::FLOAT >= 20 THEN 'Moderate Discount'
    ELSE 'Low Discount'
  END AS discount_tier,
  COUNT(*) AS products,
  AVG(raw:price::FLOAT) AS avg_price
FROM stg_specs
GROUP BY brand_name, discount_tier
