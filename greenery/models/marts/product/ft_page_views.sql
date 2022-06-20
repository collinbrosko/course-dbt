{{
  config(
    materialized='table'
  )
}}

SELECT 
DISTINCT(event_id),
session_id,
user_id,
page_url,
created_at,
event_type,
order_id,
events.product_id,
name, 
price
FROM {{ ref('stg_greenery__events') }} AS events
LEFT JOIN {{ ref('stg_greenery__events') }} AS products on events.product_id=products.product_id

