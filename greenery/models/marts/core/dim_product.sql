{{
  config(
    materialized='table'
  )
}}

SELECT 
DISTINCT(product_id), name, price, inventory
FROM {{ ref('stg_greenery__products') }}

