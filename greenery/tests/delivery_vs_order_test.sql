SELECT *
FROM {{ ref(‘stg_greenery__orders’) }}
WHERE delivered_at < created_at 
