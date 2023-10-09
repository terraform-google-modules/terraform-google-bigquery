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

CREATE OR REPLACE TABLE `${project_id}.${dataset_id}.distribution_centers`

    (
        id INTEGER,
        name STRING,
        longitude FLOAT64,
        latitude FLOAT64,
        distribution_center_geom GEOGRAPHY
    )
  OPTIONS(
      labels=[("data-warehouse","true")]
  )
AS
SELECT 1, 'Memphis TN', -89.9711, 35.1174, ST_GEOGPOINT(-89.9711, 35.1174)
UNION ALL
SELECT 2, 'Chicago IL', -87.6847, 41.8369, ST_GEOGPOINT(-87.6847, 41.8369)
UNION ALL
SELECT 3, 'Houston TX', -95.3698, 29.7604, ST_GEOGPOINT(-95.3698, 29.7604)
UNION ALL
SELECT 4, 'Los Angeles CA', -118.25, 34.05, ST_GEOGPOINT(-118.25, 34.05)
UNION ALL
SELECT 5, 'New Orleans LA', -90.0667, 29.95, ST_GEOGPOINT(-90.0667, 29.95)
UNION ALL
SELECT 6, 'Port Authority of New York/New Jersey NY/NJ', -73.7834, 40.634, ST_GEOGPOINT(-73.7834, 40.634)
UNION ALL
SELECT 7, 'Philadelphia PA', -75.1667, 39.95, ST_GEOGPOINT(-75.1667, 39.95)
UNION ALL
SELECT 8, 'Mobile AL', -88.0431, 30.6944, ST_GEOGPOINT(-88.0431, 30.6944)
UNION ALL
SELECT 9, 'Charleston SC', -79.9333, 32.7833, ST_GEOGPOINT(-79.9333, 32.7833)
UNION ALL
SELECT 10, 'Savannah GA', -81.1167, 32.0167, ST_GEOGPOINT(-81.1167, 32.0167)
;
