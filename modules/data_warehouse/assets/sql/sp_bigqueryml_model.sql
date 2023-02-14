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
