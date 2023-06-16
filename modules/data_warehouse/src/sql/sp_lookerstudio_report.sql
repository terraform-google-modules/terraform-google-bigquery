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

CREATE OR REPLACE TABLE `${project_id}.ds_edw.lookerstudio_report`
AS
WITH TaxiData AS
(
SELECT VENDOR_ID as TaxiCompany,
       EXTRACT(YEAR FROM Pickup_DateTime)          AS Year,
       EXTRACT(WEEK FROM Pickup_DateTime)          AS WeekNumber,
       CONCAT('Week ',FORMAT("%02d",
              EXTRACT(WEEK FROM Pickup_DateTime))) AS WeekName,
       CONCAT(VENDOR_ID,':',EXTRACT(YEAR FROM Pickup_DateTime),':',FORMAT("%02d",EXTRACT(WEEK FROM Pickup_DateTime))) AS GroupPartition,
       COUNT(1)                                    AS NumberOfRides,
       AVG(Trip_Distance)                          AS AvgDistance,
       SUM(Fare_Amount)                            AS Total_Fare_Amount,
       SUM(Extra)                              AS Total_Surcharge,
       SUM(MTA_Tax)                                AS Total_MTA_Tax,
       SUM(Tolls_Amount)                           AS Total_Tolls_Amount,
       SUM(imp_Surcharge)                  AS Total_Improvement_Surcharge,
       SUM(Tip_Amount)                             AS Total_Tip_Amount,
       SUM(Total_Amount)                           AS Total_Total_Amount
  FROM `${project_id}.ds_edw.taxi_trips` AS taxi_trips
 WHERE Pickup_DateTime BETWEEN '2022-01-01' AND '2022-02-02' --'2015-01-01' AND '2021-12-31'   -- There is odd data in some of the source files from NYC
 GROUP BY 1, 2, 3, 4, 5
)
, LagPercents AS
(
SELECT TaxiCompany,
       Year,
       WeekNumber,
       WeekName,
       NumberOfRides,
       GroupPartition,
       AvgDistance,
       Total_Fare_Amount,
       Total_Surcharge,
       Total_MTA_Tax,
       Total_Tolls_Amount,
       Total_Improvement_Surcharge,
       Total_Tip_Amount,
       Total_Total_Amount,
       LAG(NumberOfRides)               OVER (PARTITION BY TaxiCompany  ORDER BY Year, WeekNumber ASC) AS Prior_Week_NumberOfRides,
       LAG(AvgDistance)                 OVER (PARTITION BY TaxiCompany  ORDER BY Year, WeekNumber ASC) AS Prior_Week_AvgDistance,
       LAG(Total_Fare_Amount)           OVER (PARTITION BY TaxiCompany  ORDER BY Year, WeekNumber ASC) AS Prior_Week_Total_Fare_Amount,
       LAG(Total_Surcharge)             OVER (PARTITION BY TaxiCompany  ORDER BY Year, WeekNumber ASC) AS Prior_Week_Total_Surcharge,
       LAG(Total_MTA_Tax)               OVER (PARTITION BY TaxiCompany  ORDER BY Year, WeekNumber ASC) AS Prior_Week_Total_MTA_Tax,
       LAG(Total_Tolls_Amount)          OVER (PARTITION BY TaxiCompany  ORDER BY Year, WeekNumber ASC) AS Prior_Week_Total_Tolls_Amount,
       LAG(Total_Improvement_Surcharge) OVER (PARTITION BY TaxiCompany  ORDER BY Year, WeekNumber ASC) AS Prior_Week_Total_Improvement_Surcharge,
       LAG(Total_Tip_Amount)            OVER (PARTITION BY TaxiCompany  ORDER BY Year, WeekNumber ASC) AS Prior_Week_Total_Tip_Amount,
       LAG(Total_Total_Amount)          OVER (PARTITION BY TaxiCompany  ORDER BY Year, WeekNumber ASC) AS Prior_Week_Total_Total_Amount
  FROM TaxiData
)
, PercentChange AS
(
SELECT TaxiCompany,
       Year,
       WeekNumber,
       WeekName,
       GroupPartition,
       NumberOfRides,
       AvgDistance,
       Total_Fare_Amount,
       Total_Surcharge,
       Total_MTA_Tax,
       Total_Tolls_Amount,
       Total_Improvement_Surcharge,
       Total_Tip_Amount,
       Total_Total_Amount,
       Prior_Week_NumberOfRides,
       Prior_Week_AvgDistance,
       Prior_Week_Total_Fare_Amount,
       Prior_Week_Total_Surcharge,
       Prior_Week_Total_MTA_Tax,
       Prior_Week_Total_Tolls_Amount,
       Prior_Week_Total_Improvement_Surcharge,
       Prior_Week_Total_Tip_Amount,
       Prior_Week_Total_Total_Amount,
       SAFE_DIVIDE(CAST(NumberOfRides - Prior_Week_NumberOfRides AS NUMERIC) , CAST(Prior_Week_NumberOfRides AS NUMERIC)) AS PercentChange_NumberOfRides,
       SAFE_DIVIDE(CAST(AvgDistance - Prior_Week_AvgDistance AS NUMERIC) , CAST(Prior_Week_AvgDistance AS NUMERIC)) AS PercentChange_AvgDistance,
       SAFE_DIVIDE((Total_Fare_Amount - Prior_Week_Total_Fare_Amount) , Prior_Week_Total_Fare_Amount) AS PercentChange_Total_Fare_Amount,
       SAFE_DIVIDE((Total_Surcharge - Prior_Week_Total_Surcharge) , Prior_Week_Total_Surcharge) AS PercentChange_Total_Surcharge,
       SAFE_DIVIDE((Total_MTA_Tax - Prior_Week_Total_MTA_Tax) , Prior_Week_Total_MTA_Tax) AS PercentChange_Total_MTA_Tax,
       SAFE_DIVIDE((Total_Tolls_Amount - Prior_Week_Total_Tolls_Amount) , Prior_Week_Total_Tolls_Amount) AS PercentChange_Total_Tolls_Amount,
       SAFE_DIVIDE((Total_Improvement_Surcharge - Prior_Week_Total_Improvement_Surcharge) , Prior_Week_Total_Improvement_Surcharge) AS PercentChange_Total_Improvement_Surcharge,
       SAFE_DIVIDE((Total_Tip_Amount - Prior_Week_Total_Tip_Amount) , Prior_Week_Total_Tip_Amount) AS PercentChange_Total_Tip_Amount,
       SAFE_DIVIDE((Total_Total_Amount - Prior_Week_Total_Total_Amount) , Prior_Week_Total_Total_Amount) AS PercentChange_Total_Total_Amount
  FROM LagPercents
)
SELECT *
  FROM PercentChange
ORDER BY GroupPartition;

CREATE OR REPLACE VIEW `${project_id}.ds_edw.vw_lookerstudio_report` as
SELECT * FROM `${project_id}.ds_edw.lookerstudio_report`
WHERE Year in (2022);
