SELECT
  *,
  quantity * unit_price AS amount
FROM {{ ref('stg_transactions') }}

