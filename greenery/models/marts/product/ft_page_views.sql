{{
  config(
    materialized='table'
  )
}}

SELECT 
DISTINCT(events.event_id),
events.session_id,
events.user_id,
events.page_url,
events.created_at,
events.event_type,
events.order_id,
events.product_id,
name, 
price
FROM {{ ref('stg_greenery__events') }} AS events
LEFT JOIN {{ ref('stg_greenery__products') }} AS products on events.product_id=products.product_id

