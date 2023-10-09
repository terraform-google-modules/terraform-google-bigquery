-- Copyright 2023 Google LLC
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

CREATE OR REPLACE VIEW `${project_id}.${dataset_id}.lookerstudio_report_distribution_centers`
OPTIONS(
    labels=[("data-warehouse","true")]
)
AS
WITH OrdersData AS
(
  SELECT  dc.name                                               AS distribution_center_name,
          EXTRACT(YEAR FROM order_items.created_at)             AS year,
          EXTRACT(WEEK FROM order_items.created_at)             AS week_number,
          CONCAT('Week ',FORMAT("%02d",
                  EXTRACT(WEEK FROM order_items.created_at)))   AS week_name,
          EXTRACT(DATE FROM TIMESTAMP_TRUNC(order_items.created_at, WEEK)) AS week_start_date,
          CONCAT(product_distribution_center_id,':',EXTRACT(YEAR FROM order_items.created_at),
                  ':',FORMAT("%02d",EXTRACT(WEEK FROM order_items.created_at))) AS GroupPartition,
          COUNT(order_items.product_id)                         AS products_ordered_count,
          COUNT(DISTINCT order_items.order_id)                  AS orders_count,
          SUM(cost)                                             AS inventory_sold_cost_total,
          AVG(cost)                                             AS inventory_sold_cost_avg,
          SUM(order_items.sale_price - cost)                    AS profit_total,
          AVG(order_items.sale_price - cost)                    AS profit_avg,
          AVG(TIMESTAMP_DIFF(delivered_at, shipped_at, HOUR))   AS shipping_hours,
          AVG(TIMESTAMP_DIFF(shipped_at, order_items.created_at, HOUR)) AS processing_hours,
          AVG(TIMESTAMP_DIFF(delivered_at, order_items.created_at, HOUR)) AS order_to_delivery_hours
  FROM
    `${project_id}.${dataset_id}.order_items` AS order_items
  JOIN
    `${project_id}.${dataset_id}.inventory_items` AS inventory_items ON order_items.product_id = inventory_items.product_id AND order_items.inventory_item_id = inventory_items.id
  JOIN
    `${project_id}.${dataset_id}.distribution_centers` AS dc ON inventory_items.product_distribution_center_id = dc.id
  WHERE
    order_items.created_at IS NOT NULL
    AND order_items.created_at <= CURRENT_TIMESTAMP()
  GROUP BY 1, 2, 3, 4, 5, 6
)
, LagPercents AS
(
  SELECT  distribution_center_name,
          year,
          week_number,
          week_name,
          week_start_date,
          GroupPartition,
          products_ordered_count,
          orders_count,
          profit_total,
          profit_avg,
          inventory_sold_cost_total,
          inventory_sold_cost_avg,
          shipping_hours,
          processing_hours,
          order_to_delivery_hours,
          LAG(products_ordered_count)          OVER (PARTITION BY distribution_center_name ORDER BY year DESC, week_number DESC) AS prior_week_products_ordered_count,
          LAG(orders_count)                    OVER (PARTITION BY distribution_center_name ORDER BY year DESC, week_number DESC) AS prior_week_orders_count,
          LAG(profit_total)                    OVER (PARTITION BY distribution_center_name ORDER BY year DESC, week_number DESC) AS prior_week_profit_total,
          LAG(profit_avg)                      OVER (PARTITION BY distribution_center_name ORDER BY year DESC, week_number DESC) AS prior_week_profit_avg,
          LAG(inventory_sold_cost_total)       OVER (PARTITION BY distribution_center_name ORDER BY year DESC, week_number DESC) AS prior_week_inventory_sold_cost_total,
          LAG(inventory_sold_cost_avg)         OVER (PARTITION BY distribution_center_name ORDER BY year DESC, week_number DESC) AS prior_week_inventory_sold_cost_avg,
          LAG(shipping_hours)                  OVER (PARTITION BY distribution_center_name ORDER BY year DESC, week_number DESC) AS prior_week_shipping_hours,
          LAG(processing_hours)                OVER (PARTITION BY distribution_center_name ORDER BY year DESC, week_number DESC) AS prior_week_processing_hours,
          LAG(order_to_delivery_hours)         OVER (PARTITION BY distribution_center_name ORDER BY year DESC, week_number DESC) AS prior_week_order_to_delivery_hours
    FROM OrdersData
)
, PercentChange AS
(
  SELECT  distribution_center_name,
          year,
          week_number,
          week_name,
          week_start_date,
          GroupPartition,
          products_ordered_count,
          orders_count,
          profit_total,
          profit_avg,
          inventory_sold_cost_total,
          inventory_sold_cost_avg,
          shipping_hours,
          processing_hours,
          order_to_delivery_hours,
          prior_week_products_ordered_count,
          prior_week_orders_count,
          prior_week_profit_total,
          prior_week_profit_avg,
          prior_week_inventory_sold_cost_total,
          prior_week_inventory_sold_cost_avg,
          prior_week_shipping_hours,
          prior_week_processing_hours,
          prior_week_order_to_delivery_hours,
          SAFE_DIVIDE(CAST(products_ordered_count - prior_week_products_ordered_count AS NUMERIC) , CAST(prior_week_products_ordered_count AS NUMERIC)) AS percent_change_products_ordered_count,
          SAFE_DIVIDE(CAST(orders_count - prior_week_orders_count AS NUMERIC) , CAST(prior_week_orders_count AS NUMERIC)) AS percent_change_orders_count,
          SAFE_DIVIDE((profit_total - prior_week_profit_total) , prior_week_profit_total) AS percent_change_profit_total,
          SAFE_DIVIDE((profit_avg - prior_week_profit_avg) , prior_week_profit_avg) AS percent_change_profit_avg,
          SAFE_DIVIDE((inventory_sold_cost_total - prior_week_inventory_sold_cost_total) , prior_week_inventory_sold_cost_total) AS percent_change_inventory_sold_cost_total,
          SAFE_DIVIDE((inventory_sold_cost_avg - prior_week_inventory_sold_cost_avg) , prior_week_inventory_sold_cost_avg) AS percent_change_inventory_sold_cost_avg,
          SAFE_DIVIDE((shipping_hours - prior_week_shipping_hours) , prior_week_shipping_hours) AS percent_change_shipping_hours,
          SAFE_DIVIDE((processing_hours - prior_week_processing_hours) , prior_week_processing_hours) AS percent_change_processing_hours,
          SAFE_DIVIDE((order_to_delivery_hours - prior_week_order_to_delivery_hours) , prior_week_order_to_delivery_hours) AS percent_change_order_to_delivery_hours
  FROM LagPercents
)
SELECT *
FROM PercentChange
ORDER BY GroupPartition;

CREATE OR REPLACE VIEW `${project_id}.${dataset_id}.lookerstudio_report_profit`
OPTIONS(
    labels=[("data-warehouse","true")]
)
AS
with SubsetInventory AS(
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
