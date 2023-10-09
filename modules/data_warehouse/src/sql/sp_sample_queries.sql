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

/*
Use Cases:
    - BigQuery supports full SQL syntax and many analytic functions that make complex queries of lots of data easy

Description:
    - Show joins, date functions, rank, partition, pivot

Reference:
    - Rank/Partition: https://cloud.google.com/bigquery/docs/reference/standard-sql/analytic-function-concepts
    - Pivot: https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax#pivot_operator

Clean up / Reset script:
    n/a
*/

--Rank, Pivot, Json

-- Query: See the order price quartiles for each day of the week.
-- Shows: Date Functions, Joins, Group By, Having, Ordinal Group/Having, Quantiles
SELECT
    FORMAT_DATE("%w", created_at) AS WeekdayNumber,
    FORMAT_DATE("%A", created_at) AS WeekdayName,
    APPROX_QUANTILES(order_price, 4) AS quartiles
  FROM (
    SELECT
      created_at,
      SUM(sale_price) AS order_price
    FROM
      `${project_id}.${dataset_id}.order_items`
    GROUP BY
      order_id, 1
    HAVING SUM(sale_price) > 10)
  GROUP BY
    1, 2
  ORDER BY
    WeekdayNumber, 3
;

-- Query: Items with less than 30 days of inventory remaining
WITH Orders AS (
  SELECT
    order_items.product_id AS product_id,
    COUNT(order_items.id) AS count_sold_30d
  FROM
    `${project_id}.${dataset_id}.order_items` AS order_items
  WHERE
    order_items.created_at > TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 30 DAY)
  GROUP BY
    product_id
),

OnHand AS (
  SELECT
    inventory.product_id AS product_id,
    inventory.product_name AS product_name,
    COUNT(inventory.id) AS count_in_stock
  FROM
    `${project_id}.${dataset_id}.inventory_items` AS inventory
  WHERE
    inventory.sold_at IS NULL
  GROUP BY
    product_id,
    product_name
  ORDER BY
    count_in_stock DESC
),

End30dInventory AS (
  SELECT
    OnHand.*,
    Orders.count_sold_30d,
    count_in_stock - count_sold_30d AS expected_inventory_30d
  FROM
    OnHand
  INNER JOIN
    Orders USING (product_id)
)

SELECT
  RANK() OVER (ORDER BY expected_inventory_30d ASC) AS rank,
  End30dInventory.product_name,
  End30dInventory.expected_inventory_30d,
  End30dInventory.count_in_stock AS current_stock,
  End30dInventory.count_sold_30d
FROM
  End30dInventory
ORDER BY
  rank ASC, current_stock DESC
;

-- Query: data summed by month, then pivoted by department
with MonthlyData AS(
  SELECT
    sold_at,
    FORMAT_DATE("%B", inventory.sold_at) AS month_name,
    FORMAT_DATE("%m", inventory.sold_at) AS month_number,
    SAFE_SUBTRACT(inventory.product_retail_price, inventory.cost) AS profit,
    inventory.product_department AS product_department
  FROM
    `${project_id}.${dataset_id}.inventory_items` AS inventory
  WHERE
   sold_at IS NOT NULL
)

SELECT
  month_name,
  FORMAT("%'d", CAST(Profit_Men AS INTEGER)) AS Profit_Men,
  FORMAT("%'d", CAST(Profit_Women AS INTEGER)) AS Profit_Women
FROM
  MonthlyData
PIVOT
  (SUM(profit) AS Profit FOR product_department IN ("Men", "Women"))
ORDER BY month_number ASC
;

-- Query: See what day of the week in each month has the greatest amount of sales(that's the month/day to work)
WITH WeekdayData AS (
  SELECT
    FORMAT_DATE("%B", inventory.sold_at) AS month_name,
    FORMAT_DATE("%m", inventory.sold_at) AS month_number,
    FORMAT_DATE("%A", inventory.sold_at) AS weekday_name,
    SUM(inventory.product_retail_price) AS revenue
  FROM
    `${project_id}.${dataset_id}.inventory_items` AS inventory
  WHERE
    inventory.sold_at IS NOT NULL
 GROUP BY 1, 2, 3
)
SELECT month_name,
       FORMAT("%'d", CAST(Sunday    AS INTEGER)) AS Sunday,
       FORMAT("%'d", CAST(Monday    AS INTEGER)) AS Monday,
       FORMAT("%'d", CAST(Tuesday   AS INTEGER)) AS Tuesday,
       FORMAT("%'d", CAST(Wednesday AS INTEGER)) AS Wednesday,
       FORMAT("%'d", CAST(Thursday  AS INTEGER)) AS Thursday,
       FORMAT("%'d", CAST(Friday    AS INTEGER)) AS Friday,
       FORMAT("%'d", CAST(Saturday  AS INTEGER)) AS Saturday,
  FROM WeekdayData
 PIVOT(SUM(revenue) FOR weekday_name IN ('Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'))
ORDER BY month_number
;

-- Query: Revenue pivoted by category name for each month.
-- This query dynamically generates the pivot column names based on the distinct values in the product_category column
EXECUTE IMMEDIATE FORMAT("""
  with Subset AS(
    SELECT
      EXTRACT(MONTH FROM inventory.sold_at) AS month_number,
      inventory.product_category,
      inventory.product_retail_price
    FROM
      `${project_id}.${dataset_id}.inventory_items` AS inventory
    WHERE
      inventory.sold_at IS NOT NULL)

  SELECT
    CASE
      WHEN month_number = 1 THEN 'January'
      WHEN month_number = 2 THEN 'February'
      WHEN month_number = 3 THEN 'March'
      WHEN month_number = 4 THEN 'April'
      WHEN month_number = 5 THEN 'May'
      WHEN month_number = 6 THEN 'June'
      WHEN month_number = 7 THEN 'July'
      WHEN month_number = 8 THEN 'August'
      WHEN month_number = 9 THEN 'September'
      WHEN month_number = 10 THEN 'October'
      WHEN month_number = 11 THEN 'November'
      WHEN month_number = 12 THEN 'December'
    END AS month_name,
    * EXCEPT (month_number)
  FROM
    Subset
  PIVOT (SUM(Subset.product_retail_price) as Revenue FOR product_category IN %s)
  ORDER BY month_number;
  """,
    (
    SELECT
      CONCAT("(", STRING_AGG(DISTINCT CONCAT("'", product_category, "'"), ','), ")")
    FROM
      `${project_id}.${dataset_id}.inventory_items`
    )
)
;
