{{
  config(
    materialized='table'
  )
}}


SELECT 
order_id,
user_id,
order_total,
promos.promo_id
FROM {{ ref('stg_greenery__orders') }} AS orders
RIGHT JOIN {{ ref('stg_greenery__promos') }} AS promos ON orders.promo_id=promos.promo_id