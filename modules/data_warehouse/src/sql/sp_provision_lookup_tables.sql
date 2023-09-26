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

CREATE OR REPLACE TABLE `${project_id}.ds_edw.distribution_centers`
    (
        id INTEGER,
        name STRING,
        latitude FLOAT64,
        longitude FLOAT64,
        distribution_center_geom GEOGRAPHY
    )
AS
SELECT 1, 'Memphis TN', 35.1174, -89.9711, ST_GEOGPOINT(35.1174, -89.9711)
UNION ALL
SELECT 2, 'Chicago IL', 41.8369, -87.6847, ST_GEOGPOINT(41.8369, -87.6847)
UNION ALL
SELECT 3, 'Houston TX', 29.7604, -95.3698, ST_GEOGPOINT(29.7604, -95.3698)
UNION ALL
SELECT 4, 'Los Angeles CA', 34.05, -118.25, ST_GEOGPOINT(34.05, -118.25)
UNION ALL
SELECT 5, 'New Orleans LA', 29.95, -90.0667, ST_GEOGPOINT(29.95, -90.0667)
UNION ALL
SELECT 6, 'Port Authority of New York/New Jersey NY/NJ', 40.634, -73.7834, ST_GEOGPOINT(40.634, -73.7834)
UNION ALL
SELECT 7, 'Philadelphia PA', 39.95, -75.1667, ST_GEOGPOINT(39.95, -75.1667)
UNION ALL
SELECT 8, 'Mobile AL', 30.6944, -88.0431, ST_GEOGPOINT(30.6944, -88.0431)
UNION ALL
SELECT 9, 'Charleston SC', 32.7833, -79.9333, ST_GEOGPOINT(32.7833, -79.9333)
UNION ALL
SELECT 10, 'Savannah GA', 32.0167, -81.1167, ST_GEOGPOINT(32.0167, -81.1167)
;
