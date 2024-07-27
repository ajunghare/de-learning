{{config(
    materialized='view'
)}}

with joined_movie_ratings as(
    select 
        ratings.movieId as movie_id,
        movies.title as title,
        count(ratings.rating) as number_of_ratings,
        percentile_cont(ratings.rating, 0.5) over () as median_ratings 
    from  {{ ref("movies_raw_to_curate") }} as movies 
    inner join  {{ ref("ratings_raw_to_curate") }} as ratings
    on movies.Id = ratings.movieId
    group by ratings.movieId, movies.title
)
select 
    movie_id,
    title, 
    number_of_ratings,
    median_ratings,
    rank() over (partition by median_ratings)
        rank_movie_by_median_rating
    from joined_movie_ratings

