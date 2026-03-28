WITH base AS (
    SELECT 
        c.*,
        w.* EXCEPT(customer_id),
        s.* EXCEPT(customer_id)
    FROM {{ ref('int_customer_metrics') }} c
    LEFT JOIN {{ ref('int_customer_segments') }} s
        ON c.customer_id = s.customer_id
    LEFT JOIN {{ ref('int_customer_time_windows') }} w
        ON c.customer_id = w.customer_id
)

SELECT
    base.customer_id,
    base.total_revenue,
    base.country,
    base.customer_type,
    base.value_segment,
    base.recency_segment,
    CASE 
        WHEN recency_days > 180 THEN 1
        ELSE 0
    END AS churn_180d,

    CASE 
        WHEN revenue_last_3m < 0.5 * revenue_previous_6m
        THEN 1 ELSE 0
    END AS churn_revenue_drop,

    CASE
        WHEN avg_interpurchase_days IS NOT NULL
             AND recency_days > 2 * avg_interpurchase_days
        THEN 1 ELSE 0
    END AS churn_dynamic


FROM base
