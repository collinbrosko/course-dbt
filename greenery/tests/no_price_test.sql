SELECT *
FROM {{ ref(‘stg_greenery__orders’) }}
WHERE order_total IS NULL
