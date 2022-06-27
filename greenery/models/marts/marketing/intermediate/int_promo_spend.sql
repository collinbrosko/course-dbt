{{
  config(
    materialized='table'
  )
}}


SELECT 
promos.promo_id,
SUM(order_total)
FROM {{ ref('stg_greenery__orders') }} AS orders
RIGHT JOIN {{ ref('stg_greenery__promos') }} AS promos ON orders.promo_id=promos.promo_id
GROUP BY 1