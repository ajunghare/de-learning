{{config(
    materialized='view'
)}}

with 
medians as (
    select distinct
        ratings.movieId as movie_id,
        percentile_cont(ratings.rating, 0.5) over (partition by ratings.movieId) as median_ratings
    from 
    {{ ref('ratings_raw_to_curate') }} ratings
),
counters as(
    select 
        movies.Id as movie_id,
        movies.title as title,
        count(ratings.rating) as number_of_ratings
    from  {{ ref("movies_raw_to_curate") }} as movies 
    inner join  {{ ref("ratings_raw_to_curate") }} as ratings
    on movies.Id = ratings.movieId
    group by movies.Id, movies.title
)
select 
    counters.movie_id,
    counters.title, 
    counters.number_of_ratings,
    medians.median_ratings,
    rank() over (order by medians.median_ratings desc) rank_movie_by_median_rating
    from 
    counters 
        inner join
    medians on medians.movie_id = counters.movie_id
    order by rank_movie_by_median_rating
