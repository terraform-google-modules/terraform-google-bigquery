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
SELECT *
FROM ML.GENERATE_TEXT(
  MODEL `${project_id}.${dataset_id}.${model_name}`,
  (
    with clusters AS(
      SELECT
      CONCAT('cluster ', CAST(centroid_id as STRING)) as centroid,
      avg_spend as average_spend,
      count_orders as count_of_orders,
      days_since_order
      FROM (
        SELECT centroid_id, feature, ROUND(numerical_value, 2) as value
        FROM ML.CENTROIDS(MODEL `${project_id}.${dataset_id}.customer_segment_clustering`)
      )
      PIVOT (
        SUM(value)
        FOR feature IN ('avg_spend',  'count_orders', 'days_since_order')
      )
      ORDER BY centroid_id
    )

    SELECT
      "Pretend you're a creative strategist, given the following clusters come up with creative brand persona and title labels for each of these clusters, and explain step by step; what would be the next marketing step for these clusters" || " " || clusters.centroid || ", Average Spend $" || clusters.average_spend || ", Count of orders per person " || clusters.count_of_orders || ", Days since last order " || clusters.days_since_order AS prompt
    FROM
      clusters
  ),
  -- See the BigQuery "Generate Text" docs to better understand how changing these inputs will impact your results: https://cloud.google.com/bigquery/docs/generate-text#generate_text
  STRUCT(
    600 AS max_output_tokens,
    0.3 AS temperature,
    40 AS top_k,
    0.8 AS top_p,
    TRUE AS flatten_json_output
  )
);
*/


