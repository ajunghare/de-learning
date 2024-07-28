{{config(
    materialized='incremental', alias='ratings_curate')}}


select
    cast (userId as INT) as userId,
    cast (movieId as INT) as movieId,
    cast (rating as DECIMAL) as rating,
    timestamp,
    load_time
from 
{{ source('raw','ratings_raw') }}
{% if is_incremental() %}
  -- (uses >= to include records whose timestamp occurred since the last run of this model)
  -- (If event_time is NULL or the table is truncated, the condition will always be true and load all records)
where load_time >= (select coalesce(max(load_time),'1900-01-01') from {{ this }} )

{% endif %}


