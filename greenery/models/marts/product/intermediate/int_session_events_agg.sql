{{
config(
  materialized = "table"
  )
}}

{%- set event_types = dbt_utils.get_column_values(
    table=ref('stg_greenery__events'),
    column='event_type'
) -%}

SELECT 
  session_id
  , date(created_at) created_at
  , user_id
  {% for event in event_types %}
  , {{events(event)}} AS {{event}}_counts
  {% endfor %}
FROM {{ ref('stg_greenery__events') }}
GROUP BY 1,2,3


