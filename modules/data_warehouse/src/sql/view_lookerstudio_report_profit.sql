WITH SubsetInventory AS(
  SELECT
    SUM(ROUND(product_retail_price,2)) AS revenue_total,
    SUM(ROUND(cost,2)) AS cost_total,
    SUM(ROUND(product_retail_price-cost, 2)) AS profit_total,
    CONCAT(product_department, " - ", product_category) AS product_dept_cat,
    EXTRACT(DATE from sold_at) AS sold_at_day
  FROM
    `${project_id}.${dataset_id}.inventory_items`
  WHERE
    sold_at <= CURRENT_TIMESTAMP()
  GROUP BY
    product_dept_cat, sold_at_day
),

Inventory7d AS (
  SELECT
    product_dept_cat,
    sold_at_day AS day,
    revenue_total,
    cost_total,
    profit_total,
    SUM(ROUND(revenue_total,2)) OVER (PARTITION BY product_dept_cat ORDER BY UNIX_DATE(sold_at_day) ASC RANGE BETWEEN 6 PRECEDING and CURRENT ROW) AS revenue_last_7d,
    SUM(ROUND(cost_total,2)) OVER (PARTITION BY product_dept_cat ORDER BY UNIX_DATE(sold_at_day) ASC RANGE BETWEEN 6 PRECEDING and CURRENT ROW) AS cost_last_7d
  FROM
    SubsetInventory
),

Lags AS (
  SELECT
    product_dept_cat,
    day,
    revenue_total,
    cost_total,
    profit_total,
    revenue_last_7d,
    cost_last_7d,
    ROUND(SAFE_SUBTRACT(revenue_last_7d, cost_last_7d),2) AS profit_last_7d,
    LAG(revenue_last_7d,30) OVER (PARTITION BY product_dept_cat ORDER BY UNIX_DATE(day) ASC) AS prior_month_revenue_last_7d,
    LAG(cost_last_7d,30) OVER (PARTITION BY product_dept_cat ORDER BY UNIX_DATE(day) ASC) AS prior_month_cost_last_7d,
    LAG(revenue_last_7d,365) OVER (PARTITION BY product_dept_cat ORDER BY UNIX_DATE(day) ASC) AS prior_year_revenue_last_7d,
    LAG(cost_last_7d,365) OVER (PARTITION BY product_dept_cat ORDER BY UNIX_DATE(day) ASC) AS prior_year_cost_last_7d,
  FROM
    Inventory7d
),

LagPercentages AS (
  SELECT
    day,
    product_dept_cat,
    revenue_total,
    cost_total,
    profit_total,
    revenue_last_7d,
    prior_month_revenue_last_7d,
    prior_year_revenue_last_7d,
    SAFE_DIVIDE((revenue_last_7d - prior_month_revenue_last_7d), prior_month_revenue_last_7d) AS percent_change_revenue_month,
    SAFE_DIVIDE((revenue_last_7d - prior_year_revenue_last_7d), prior_year_revenue_last_7d) AS percent_change_revenue_year,
    cost_last_7d,
    prior_month_cost_last_7d,
    prior_year_cost_last_7d,
    SAFE_DIVIDE((cost_last_7d - prior_month_cost_last_7d), prior_month_cost_last_7d) AS percent_change_cost_month,
    SAFE_DIVIDE((cost_last_7d - prior_year_cost_last_7d), prior_year_cost_last_7d) AS percent_change_cost_year,
    profit_last_7d,
    ROUND(SAFE_SUBTRACT(prior_month_revenue_last_7d, prior_month_cost_last_7d),2) AS prior_month_profit_last_7d,
    ROUND(SAFE_SUBTRACT(prior_year_revenue_last_7d, prior_year_cost_last_7d),2) AS prior_year_profit_last_7d,
  FROM
    Lags
),

ProfitPercentages AS (
  SELECT
    day,
    product_dept_cat,
    revenue_total,
    revenue_last_7d,
    prior_month_revenue_last_7d,
    percent_change_revenue_month,
    prior_year_revenue_last_7d,
    percent_change_revenue_year,
    cost_total,
    cost_last_7d,
    prior_month_cost_last_7d,
    percent_change_cost_month,
    prior_year_cost_last_7d,
    percent_change_cost_year,
    profit_total,
    profit_last_7d,
    prior_month_profit_last_7d,
    SAFE_DIVIDE((profit_last_7d - prior_month_profit_last_7d), prior_month_profit_last_7d) AS percent_change_profit_month,
    prior_year_profit_last_7d,
    SAFE_DIVIDE((profit_last_7d - prior_year_profit_last_7d), prior_year_profit_last_7d) AS percent_change_profit_year
  FROM
    LagPercentages
  ORDER BY
    day DESC
)

SELECT *
FROM ProfitPercentages
ORDER BY day DESC;
