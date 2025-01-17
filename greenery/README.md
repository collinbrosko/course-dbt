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

## Week 2
### What is our user repeat rate?
27.42%
WITH user_count AS (
  SELECT 
  user_id
  , COUNT(user_id) as order_count
  FROM dbt_collinb.stg_greenery__orders
  GROUP BY 1
),

repeat_users AS (
  SELECT 
  COUNT(order_count) AS repeat_users
  FROM user_count
  WHERE order_count>=2
),

total_users AS (
  SELECT 
  COUNT(user_id) as total_users
  FROM dbt_collinb.stg_greenery__orders
),

combined AS (
  SELECT 
    repeat_users, 
    (SELECT 
    COUNT(user_id) as total_users
    FROM dbt_collinb.stg_greenery__orders)
  FROM repeat_users
)

SELECT repeat_users/total_users FROM combined

### What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?
Good indications of users who will likely purchase again are: how many times that a users view a product, the amount of time that a user spent viewing a product, the location of the user, the time of day that an order was made, the day of week that the order was made, products likely to be purchased together, if the user clicked a link provided from an email, what URLs the user visited directly after viewing a product, what path did the user use to navigate to the site. All of these indicators would also be able to identify users who are not likely to purchase again. 

### Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.
I would make sure that every model and view has a freshness test and those notifications were monitored daily. I would also use the test that identify null or incorret rows based on the test SQL files to populate another view or table that could be loading into a dashboard to monitor on a daily basis the amount of bad data that was being loaded into our system

## Week 3
### What is our overall conversion rate?
62.457%
SELECT SUM(checkout)/COUNT(DISTINCT session_id)
FROM dbt_collinb.int_session_event_agg

### What is our conversion rate by product?
Alocasia Polly - 52.94117647058823529400
Aloe Vera - 55.38461538461538461500
Angel Wings Begonia - 52.45901639344262295100
Arrow Head - 61.90476190476190476200
Bamboo - 62.68656716417910447800 ...

select 
    name
    , sum(add_to_cart) / count(distinct session_id)*100 as conversion_rate_by_product      
from dbt_collinb.int_session_event_agg as session_event_agg
LEFT JOIN dbt_collinb.dim_product AS dim_product ON session_event_agg.product_id=dim_product.product_id
group by 1

### Part 2:Create a macro to simplify part of a model(s)

{%- macro events(event_type) -%}
    SUM(CASE WHEN event_type = '{{event_type}}' THEN 1 ELSE 0 END)
{%- endmacro -%}


### Part 4: PART 4: Install a package (i.e. dbt-utils, dbt-expectations) and apply one or more of the macros to your project
  set event_types = dbt_utils.get_query_results_as_dict(
    "SELECT DISTINCT quote_literal(event_type) AS event_type, event_type AS column_name FROM"
    ~ ref('stg_greenery__events')

