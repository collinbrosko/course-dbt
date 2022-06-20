{{
  config(
    materialized='table'
  )
}}

SELECT 
DISTINCT(promo_id), discount, status
FROM {{ ref('stg_greenery__promos') }}
