SELECT
  raw:stock_info.warehouse::STRING AS warehouse,
  COUNT(*) AS product_count,
  SUM(raw:stock_info.stock::INT) AS total_stock,
  MAX(raw:price::FLOAT) AS max_price
FROM stg_specs
GROUP BY warehouse
