SELECT
  EXTRACT(YEAR FROM raw:added_on::DATE) AS year,
  EXTRACT(MONTH FROM raw:added_on::DATE) AS month,
  COUNT(*) AS product_count,
  AVG(raw:price::FLOAT) AS avg_price
FROM stg_specs
GROUP BY year, month
ORDER BY year, month
