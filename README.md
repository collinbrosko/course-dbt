# Analytics engineering with dbt

## Week 1
### How many users do we have?
130
SELECT COUNT(DISTINCT user_id) FROM dbt_collinb.stg_greenery__users

### On average, how many orders do we receive per hour?
7.5208333333333333
WITH hour_count AS (
  SELECT
  date_trunc('hour', created_at) as order_hour,
  count(distinct order_id) as order_count
  FROM dbt_collinb.stg_greenery__orders
  GROUP BY 1
)

SELECT AVG(order_count) AS avg_hourly_order_count
FROM hour_count

### On average, how long does an order take from being placed to being delivered?
3 days 21:24:11.803279
WITH place_to_delivery_time AS (
  SELECT
  order_id,
  (delivered_at - created_at) AS place_to_delivery_time
  FROM dbt_collinb.stg_greenery__orders
  WHERE delivered_at IS NOT NULL
)

SELECT AVG(place_to_delivery_time) AS avg_place_to_delivery_time
FROM place_to_delivery_time

### How many users have only made one purchase? Two purchases? Three+ purchases?
1 Order = 25
2 Orders = 28
3 or More Ordres = 71

WITH user_order_count AS (
  SELECT
  user_id,
  CASE 
    WHEN COUNT(order_id) = 1 THEN '1'
    WHEN COUNT(order_id) = 2 THEN '2'
    WHEN COUNT(order_id) >= 3 THEN '3+'
  END order_count
  FROM dbt_collinb.stg_greenery__orders
  GROUP BY 1

)

SELECT order_count, COUNT(user_ID)
FROM user_order_count
GROUP BY 1
### On average, how many unique sessions do we have per hour?
16.3275862068965517

WITH session_count AS (
  SELECT
  date_trunc('hour', created_at) as order_hour,
  count(distinct session_id) as session_count
  FROM dbt_collinb.stg_greenery__events
  GROUP BY 1
)

SELECT AVG(session_count) AS avg_session_count
FROM session_count
