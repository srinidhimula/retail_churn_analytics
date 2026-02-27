WITH monthly AS (
    SELECT
        DATE_TRUNC(DATE(invoice_timestamp), MONTH) AS invoice_month,

        ROUND(SUM(amount),2) AS total_revenue,
        COUNT(DISTINCT customer_id) AS active_customers,
        COUNT(DISTINCT invoice_no) AS total_orders

    FROM {{ ref('stg_transactions_with_amount') }}
    GROUP BY invoice_month
)

SELECT
    invoice_month,
    total_revenue,
    active_customers,
    total_orders,
    SAFE_DIVIDE(total_revenue, total_orders) AS avg_order_value,
    SAFE_DIVIDE(total_orders, active_customers) AS orders_per_customer
FROM monthly
WHERE invoice_month < DATE '2011-12-01'
ORDER BY invoice_month