{{ config(
    materialized='incremental', 
    alias='ratings_curate',
    unique_key=['userId','movieId']) }}

with latest_rating as (
    select
        cast(userid as INT) as userid,
        cast(movieid as INT) as movieid,
        cast(rating as DECIMAL) as rating,
        cast(timestamp as INT) as timestamp,
        load_time
    from
        {{ source('raw','ratings_raw') }}
    {% if is_incremental() %}
        where
            load_time
            >= (select coalesce(max(load_time), '1900-01-01') from {{ this }})
    {% endif %}
),

max_timestamp_per_user_per_movie as (
    select
        userid,
        movieid,
        max(timestamp) as ts
    from latest_rating
    group by userid, movieid
)

select
    lr.userid,
    lr.movieid,
    lr.timestamp,
    lr.rating,
    lr.load_time
from
    max_timestamp_per_user_per_movie as mt
inner join
    latest_rating as lr
    on
        mt.userid = lr.userid
        and mt.movieid = lr.movieid
        and mt.ts = lr.timestamp
