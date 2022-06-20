{{
  config(
    materialized='table'
  )
}}


SELECT 
user_id,
SUM(order_total)
FROM {{ ref('stg_greenery__orders') }}
GROUP BY 1