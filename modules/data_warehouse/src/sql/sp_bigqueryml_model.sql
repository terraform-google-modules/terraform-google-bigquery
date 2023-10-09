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
Run a query to see the results of the model
--
SELECT
  CONCAT('cluster ', CAST(centroid_id as STRING)) as cluster,
  avg_spend as average_spend,
  count_orders as count_of_orders,
  days_since_order
FROM (
  SELECT
    centroid_id,
    feature,
    ROUND(numerical_value, 2) as value
  FROM
    ML.CENTROIDS(MODEL `${dataset_id}.customer_segment_clustering`)
)
PIVOT (
  SUM(value)
  FOR feature IN ('avg_spend',  'count_orders', 'days_since_order')
)
ORDER BY centroid_id
*/

--Model Example
CREATE OR REPLACE MODEL
  `${project_id}.${dataset_id}.customer_segment_clustering`
  OPTIONS(
    MODEL_TYPE = 'KMEANS', -- model name
    NUM_CLUSTERS = 5, -- how many clusters to create
    KMEANS_INIT_METHOD = 'KMEANS++',
    STANDARDIZE_FEATURES = TRUE -- note: normalization taking place to scale the range of independent variables (each feature contributes proportionately to the final distance)
  )
  AS (
    SELECT
      * EXCEPT (user_id)
    FROM (
      SELECT
        user_id,
        DATE_DIFF(CURRENT_DATE(), CAST(MAX(order_created_date) as DATE), day) as days_since_order, ---RECENCY
        COUNT(DISTINCT order_id) as count_orders, --FREQUENCY
        AVG(sale_price) as avg_spend --MONETARY
      FROM (
        SELECT
          user_id,
          order_id,
          sale_price,
          created_at as order_created_date
        FROM
          `${project_id}.${dataset_id}.order_items`
        WHERE
          created_at BETWEEN TIMESTAMP('2020-07-31 00:00:00')
          AND TIMESTAMP('2023-07-31 00:00:00')
      )
      GROUP BY user_id
    )
  )
;
