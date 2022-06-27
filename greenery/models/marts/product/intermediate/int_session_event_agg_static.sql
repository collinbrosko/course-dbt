{{
config(
  materialized = "table"
  )
}}


SELECT 
session_id
, user_id
, date(created_at) created_at
, SUM(case when event_type = 'add_to_cart' then 1 else 0 end) as add_to_cart
, SUM(case when event_type = 'checkout' then 1 else 0 end) as checkout
, SUM(case when event_type = 'page_view' then 1 else 0 end) as page_view
, SUM(case when event_type = 'package_shipped' then 1 else 0 end) as package_shipped
, SUM(case when event_type = 'product_checkout')
FROM {{ ref('stg_greenery__events') }}
GROUP BY 1,2,3

