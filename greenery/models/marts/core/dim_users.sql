{{
  config(
    materialized='table'
  )
}}

SELECT 
DISTINCT(user_id), 
first_name, 
last_name, 
email, 
phone_number, 
address,
zipcode, 
state, 
country
FROM {{ ref('stg_greenery__users') }} AS users
LEFT JOIN {{ ref('stg_greenery__addresses') }} AS address ON users.address_id=address.address_id

