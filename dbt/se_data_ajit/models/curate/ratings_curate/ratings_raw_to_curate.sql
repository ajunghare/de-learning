{{config(
    materialized='incremental', 
    alias='ratings_curate',
    unique_key=['userId','movieId'])}}

with latest_rating as(
select
    cast (userId as INT) as userId,
    cast (movieId as INT) as movieId,
    cast (rating as DECIMAL) as rating,
    cast (timestamp as INT) as timestamp,
    load_time
from 
  {{ source('raw','ratings_raw') }}
  {% if is_incremental() %}
  where load_time >= (select coalesce(max(load_time),'1900-01-01') from {{ this }} )
  {% endif %}
),
max_timestamp_per_user_per_movie as (
select
    userId,
    movieId,
    max(timestamp) ts
    from latest_rating
    group by userId, movieId
    )
select 
    lr.userId
  , lr.movieId
  , lr.timestamp
  , lr.rating
  , lr.load_time 
  from 
max_timestamp_per_user_per_movie mt 
  inner join 
latest_rating lr 
  on  lr.userId = mt.userId 
  and lr.movieId = mt.movieId 
  and lr.timestamp = mt.ts
