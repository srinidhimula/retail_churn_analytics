WITH dataset_end AS (
    SELECT 
        MAX(invoice_timestamp) AS dataset_end_date
    FROM {{ ref('stg_transactions_with_amount') }}
),

base AS (
    SELECT *
    FROM {{ ref('stg_transactions_with_amount') }}
)

SELECT
    customer_id,
    SUM(CASE 
        WHEN DATE(invoice_timestamp) >= DATE_SUB(DATE(dataset_end_date), INTERVAL 3 MONTH)
        THEN amount END) AS revenue_last_3m,

    SUM(
      CASE
        WHEN DATE(invoice_timestamp) >= DATE_SUB(DATE(dataset_end_date), INTERVAL 9 MONTH)
         AND DATE(invoice_timestamp) <  DATE_SUB(DATE(dataset_end_date), INTERVAL 3 MONTH)
        THEN amount
        ELSE 0
      END
    ) AS revenue_previous_6m

FROM base, dataset_end
GROUP BY customer_id
