{{
  config(
    materialized='table'
  )
}}

SELECT 
COUNT(session_id),

FROM {{ ref('stg_greenery__events') }} AS events

