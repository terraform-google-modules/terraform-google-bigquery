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

/* To use the Migration Service, in the top pane, go to More --> Enable SQL translation.
The queries below are examples of non-BigQuery SQL syntax that can be used with the
interactive translator to see before and after changes performed.

The sample query below uses PostgreSQL syntax.*/

/* Query 1
-------------

CREATE TABLE ${project_id}.${dataset_id}.inventory_items (id VARCHAR, product_id VARCHAR, created_at TIMESTAMP, sold_at TIMESTAMP, cost NUMERIC, product_category VARCHAR, product_name VARCHAR, product_brand VARCHAR, product_retail_price NUMERIC, product_department VARCHAR, product_sku VARCHAR, product_distribution_center_id VARCHAR);
CREATE TABLE ${project_id}.${dataset_id}.order_items (id INTEGER, order_id INTEGER, user_id INTEGER, product_id INTEGER, inventory_item_id INTEGER, status VARCHAR, created_at TIMESTAMP, shipped_at TIMESTAMP, delivered_at TIMESTAMP, returned_at TIMESTAMP, sale_price NUMERIC);

SELECT
  EXTRACT(dow from order_items.created_at) AS WeekdayNumber,
  TO_CHAR(order_items.created_at, 'DAY') AS WeekdayName,
  inventory.product_category AS product_category,
  COUNT(DISTINCT order_items.order_id) AS num_high_value_orders
FROM ${project_id}.${dataset_id}.inventory_items AS inventory
  INNER JOIN ${project_id}.${dataset_id}.order_items AS order_items
    ON inventory.id::int = order_items.inventory_item_id
    AND cast(inventory.product_id as int) = order_items.product_id
    AND order_items.created_at BETWEEN TO_TIMESTAMP('2022-01-01','YYYY-MM-DD') AND TO_TIMESTAMP('2022-12-31','YYYY-MM-DD')
GROUP BY 1, 2, 3
HAVING AVG(order_items.sale_price) > 85;
*/


SELECT 'OPEN THE STORED PROCEDURE FOR MORE DETAILS TO USE THE TRANSLATION SERVICE' as sql_text;
