WITH dataset_end AS (
    SELECT 
        MAX(invoice_timestamp) AS dataset_end_date
    FROM {{ ref('stg_transactions_with_amount') }}
),

customer_agg AS (
    SELECT
        customer_id,
        ANY_VALUE(country) AS country,
        MIN(invoice_timestamp) AS first_purchase_date,
        MAX(invoice_timestamp) AS last_purchase_date,
        COUNT(DISTINCT invoice_no) AS total_orders,
        ROUND(SUM(amount),3) AS total_revenue
    FROM {{ ref('stg_transactions_with_amount') }}
    GROUP BY customer_id
),

interpurchase AS (
    SELECT
        customer_id,
        AVG(days_between_orders) AS avg_interpurchase_days
    FROM (
        SELECT
            customer_id,
            invoice_timestamp,
            TIMESTAMP_DIFF(
                invoice_timestamp,
                LAG(invoice_timestamp) OVER (
                    PARTITION BY customer_id 
                    ORDER BY invoice_timestamp
                ),
                DAY
            ) AS days_between_orders
        FROM {{ ref('stg_transactions_with_amount') }}
    )
    WHERE days_between_orders IS NOT NULL
    GROUP BY customer_id
)

SELECT
    c.customer_id,
    c.country,
    c.first_purchase_date,
    c.last_purchase_date,
    c.total_orders,
    c.total_revenue,
    SAFE_DIVIDE(c.total_revenue, c.total_orders) AS avg_order_value,

    TIMESTAMP_DIFF(
        d.dataset_end_date,
        c.last_purchase_date,
        DAY
    ) AS recency_days,

    i.avg_interpurchase_days,

    CASE 
        WHEN c.total_orders = 1 THEN 1 
        ELSE 0 
    END AS one_time_customer

FROM customer_agg c
CROSS JOIN dataset_end d
LEFT JOIN interpurchase i 
    ON c.customer_id = i.customer_id
