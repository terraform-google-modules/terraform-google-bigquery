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