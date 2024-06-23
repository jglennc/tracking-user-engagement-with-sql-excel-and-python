USE data_scientist_project;

-- I. Calculating a Subscription’s End Date
-- To calculate the end date of a subscription (date_end), add one month, three months,
-- or 12 months to the start date of a subscription for a Monthly (represented as 0 in the plan_id column),
-- Quarterly (1), or an Annual (2) purchase, respectively.

-- The only exception is the lifetime subscription (denoted by 3), which has no end date.
SELECT 
    purchase_id,
    student_id,
    plan_id,
    date_purchased AS date_start,
    CASE
        WHEN
            plan_id = 0
        THEN
            DATE_ADD(date_purchased,
                INTERVAL 1 MONTH)
        WHEN
            plan_id = 1
        THEN
            DATE_ADD(date_purchased,
                INTERVAL 3 MONTH)
        WHEN
            plan_id = 2
        THEN
            DATE_ADD(date_purchased,
                INTERVAL 12 MONTH)
        WHEN plan_id = 3 THEN '9999-12-31'
    END AS date_end,
    date_refunded
FROM
    student_purchases;

-- II. Re-Calculating a Subscription’s End Date
-- Re-calculate the date_end column so that if an order was refunded—indicated by 
-- a non-NULL value in the date_refunded field—the student’s subscription terminates 
-- at the refund date.
SELECT 
    purchase_id,
    student_id,
    plan_id,
    date_start,
    IF(date_refunded IS NULL,
        date_end,
        date_refunded) AS date_end
FROM
    (SELECT 
        purchase_id,
            student_id,
            plan_id,
            date_purchased AS date_start,
            CASE
                WHEN plan_id = 0 THEN DATE_ADD(date_purchased, INTERVAL 1 MONTH)
                WHEN plan_id = 1 THEN DATE_ADD(date_purchased, INTERVAL 3 MONTH)
                WHEN plan_id = 2 THEN DATE_ADD(date_purchased, INTERVAL 12 MONTH)
                WHEN plan_id = 3 THEN '9999-12-31'
            END AS date_end,
            date_refunded
    FROM
        student_purchases) a;
        
-- III. Creating Two ‘paid’ Columns and a MySQL View
DROP VIEW IF EXISTS purchases_info;

CREATE VIEW purchases_info AS
    SELECT 
        *,
        CASE
            WHEN date_end < '2021-04-01' THEN 0
            WHEN date_start > '2021-06-30' THEN 0
            ELSE 1
        END AS paid_q2_2021,
        CASE
            WHEN date_end < '2022-04-01' THEN 0
            WHEN date_start > '2022-06-30' THEN 0
            ELSE 1
        END AS paid_q2_2022
    FROM
        (SELECT 
            purchase_id,
                student_id,
                plan_id,
                date_start,
                IF(date_refunded IS NULL, date_end, date_refunded) AS date_end
        FROM
            (SELECT 
            purchase_id,
                student_id,
                plan_id,
                date_purchased AS date_start,
                CASE
                    WHEN plan_id = 0 THEN DATE_ADD(date_purchased, INTERVAL 1 MONTH)
                    WHEN plan_id = 1 THEN DATE_ADD(date_purchased, INTERVAL 3 MONTH)
                    WHEN plan_id = 2 THEN DATE_ADD(date_purchased, INTERVAL 12 MONTH)
                    WHEN plan_id = 3 THEN '9999-12-31'
                END AS date_end,
                date_refunded
        FROM
            student_purchases) a) b;
