{{ config(
    materialized='table', alias='movies_curate') }}


select
    cast(adult as BOOLEAN) as adult,
    cast(budget as INT) as budget,
    cast(homepage as STRING) as homepage,
    cast(id as INT) as id,
    cast(imdb_id as STRING) as imdb_id,
    cast(original_language as STRING) as original_language,
    cast(original_title as STRING) as original_title,
    cast(overview as STRING) as overview,
    cast(popularity as DECIMAL) as popularity,
    cast(poster_path as STRING) as poster_path,
    cast(release_date as DATE) as release_date,
    cast(revenue as INT) as revenue,
    cast(runtime as DECIMAL) as runtime,
    cast(status as STRING) as status,
    cast(tagline as STRING) as tagline,
    cast(title as STRING) as title,
    cast(video as BOOLEAN) as video,
    cast(vote_average as DECIMAL) as vote_average,
    cast(vote_count as INT) as vote_count,
    load_date,
    safe.PARSE_JSON(belongs_to_collection) as belongs_to_collection,
    json_extract_array(genres) as genres,
    json_extract_array(production_companies) as production_companies,
    json_extract_array(production_countries) as production_countries,
    json_extract_array(spoken_languages) as spoken_languages

from {{ source('raw','movies_raw') }}
where
    adult in ("True", "False")
    and adult != "Two months later" --Erroranous data
