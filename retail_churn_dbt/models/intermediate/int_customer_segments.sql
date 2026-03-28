WITH base AS (
    SELECT *
    FROM {{ ref('int_customer_metrics') }}
),

value_segments AS (
    SELECT
        customer_id,
        NTILE(3) OVER (ORDER BY total_revenue DESC) AS revenue_tile
    FROM base
)

SELECT
    b.customer_id,

    -- One-time vs repeat
    CASE 
        WHEN b.total_orders = 1 THEN 'one_time'
        ELSE 'repeat'
    END AS customer_type,

    -- Value segment
    CASE 
        WHEN v.revenue_tile = 1 THEN 'high_value'
        WHEN v.revenue_tile = 2 THEN 'mid_value'
        ELSE 'low_value'
    END AS value_segment,

    -- Recency segment
    CASE 
        WHEN b.recency_days <= 30 THEN 'active'
        WHEN b.recency_days <= 90 THEN 'warm'
        ELSE 'cold'
    END AS recency_segment

FROM base b
LEFT JOIN value_segments v
    ON b.customer_id = v.customer_id