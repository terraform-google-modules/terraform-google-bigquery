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

CREATE OR REPLACE TABLE `${project_id}.ds_edw.vendor`
    (
        Vendor_Id INTEGER,
        Vendor_Description STRING
    )
AS
SELECT 1, 'Creative Mobile Technologies, LLC'
UNION ALL
SELECT 2, 'VeriFone Inc.';

CREATE OR REPLACE TABLE `${project_id}.ds_edw.payment_type`
    (
        Payment_Type_Id INTEGER,
        Payment_Type_Description STRING
    )
AS
SELECT 1, 'Credit card'
UNION ALL
SELECT 2, 'Cash'
UNION ALL
SELECT 3, 'No charge'
UNION ALL
SELECT 4, 'Dispute'
UNION ALL
SELECT 5, 'Unknown'
UNION ALL
SELECT 6, 'Voided trip';
