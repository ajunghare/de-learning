{{ config(
    materialized='view'
) }}

with
medians as (
    select distinct
        ratings.movieid as movie_id,
        percentile_cont(ratings.rating, 0.5)
            over (partition by ratings.movieid)
            as median_ratings
    from
        {{ ref('ratings_raw_to_curate') }} as ratings
),

counters as (
    select
        movies.id as movie_id,
        movies.title,
        count(ratings.rating) as number_of_ratings
    from {{ ref("movies_raw_to_curate") }} as movies
    inner join {{ ref("ratings_raw_to_curate") }} as ratings
        on movies.id = ratings.movieid
    group by movies.id, movies.title
),

final as (
    select
        counters.movie_id,
        counters.title,
        counters.number_of_ratings,
        medians.median_ratings,
        rank()
            over (order by medians.median_ratings desc)
            as rank_movie_by_median_rating
    from
        counters
    inner join
        medians on counters.movie_id = medians.movie_id
)

select * from final
