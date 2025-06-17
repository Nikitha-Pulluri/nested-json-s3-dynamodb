SELECT
  raw:category::STRING AS category,
  COUNT(*) AS total_products,
  AVG(raw:price::FLOAT) AS avg_price,
  SUM(raw:stock_info.stock::INT) AS total_stock
FROM stg_SPECS
GROUP BY category
