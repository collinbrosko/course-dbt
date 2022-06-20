{{
  config(
    materialized='table'
  )
}}

SELECT 
COUNT(user_id)
FROM {{ ref('stg_greenery__users') }}
