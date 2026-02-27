SELECT 
  CAST(InvoiceNo AS STRING) AS invoice_no,
  CAST(StockCode AS STRING) AS stock_code,
  CAST(Description AS STRING) AS description,
  CAST(Quantity AS INT64) AS quantity,
  PARSE_TIMESTAMP('%m/%d/%y %H:%M', InvoiceDate) AS invoice_timestamp,
  CAST(UnitPrice AS FLOAT64) AS unit_price,
  CAST(CustomerID AS STRING) AS customer_id,
  CAST(Country AS STRING) AS country,
FROM `customerretention-retail.retail_raw.raw_data`
WHERE CustomerID IS NOT NULL
