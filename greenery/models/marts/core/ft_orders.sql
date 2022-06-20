{{
  config(
    materialized='table'
  )
}}

SELECT 
DISTINCT(orders.order_id),
created_at,
order_cost,
shipping_cost
order_total,
quantity
FROM {{ ref('stg_greenery__orders') }} AS orders
LEFT JOIN {{ ref('stg_greenery__order_items') }} AS order_items ON orders.order_id=order_items.order_id







