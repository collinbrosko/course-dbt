{{
config(
  materialized = "table"
  )
}}

{%
  set event_types = dbt_utils.get_query_results_as_dict(
    "SELECT DISTINCT quote_literal(event_type) AS event_type, event_type AS column_name FROM"
    ~ ref('stg_greenery__events')
  )
%}


SELECT 
  session_id
  , date(created_at) created_at
  , user_id
  {% for event_type in event_types['event_types']%}
  ,  SUM(case when event_type = {{event_type}} then 1 else 0 end ) as {{event_types['column_name'][loop.index0]}}
  {% endfor %}
FROM {{ ref('stg_greenery__events') }}
GROUP BY 1,2,3


