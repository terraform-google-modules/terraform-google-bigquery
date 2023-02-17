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

/* Run a query to see the prediction results of the model
--
select * from ML.PREDICT(MODEL ds_edw.model_taxi_estimate,
  TABLE ds_edw.taxi_trips)
  limit 1000;  */

--Model Example
CREATE OR REPLACE MODEL
  `${project_id}.ds_edw.model_taxi_estimate` OPTIONS ( MODEL_TYPE='LINEAR_REG',
    LS_INIT_LEARN_RATE=0.15,
    L1_REG=1,
    MAX_ITERATIONS=5 ) AS
SELECT
  pickup_datetime,
  dropoff_datetime,
  IFNULL(passenger_count,0) passenger_count,
  IFNULL(trip_distance,0) trip_distance,
  IFNULL(rate_code,'') rate_code,
  IFNULL(payment_type,'') payment_type,
  IFNULL(fare_amount,0) label,
  IFNULL(pickup_location_id,'') pickup_location_id,
  IFNULL(dropoff_location_id,'')dropoff_location_id
FROM
  `${project_id}.ds_edw.taxi_trips`
WHERE
  fare_amount > 0;
