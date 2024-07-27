{{config(
    materialized='table', alias='movies_curate')}}

with 
movies_curate as (
    select 
        cast( adult as BOOLEAN) as adult,
        safe.PARSE_JSON( belongs_to_collection) as belongs_to_collection,
        cast( budget as INT) as budget,
        JSON_EXTRACT_ARRAY(genres) as genres,
        cast( homepage as STRING) as homepage,
        cast( id as INT) as id,
        cast( imdb_id as STRING) as imdb_id,
        cast( original_language as STRING) as original_language,
        cast( original_title as STRING) as original_title,
        cast( overview as STRING) as overview,
        cast( popularity as DECIMAL) as popularity,
        cast( poster_path as STRING) as poster_path,
        JSON_EXTRACT_ARRAY(  production_companies) as production_companies,
        JSON_EXTRACT_ARRAY(  production_countries) as production_countries,
        cast( release_date as DATE) as release_date,
        cast( revenue as INT) as revenue,
        cast( runtime as DECIMAL) as runtime,
        JSON_EXTRACT_ARRAY( spoken_languages) as spoken_languages,
        cast( status as STRING) as status,
        cast( tagline as STRING) as tagline,
        cast( title as STRING) as title,
        cast( video as BOOLEAN) as video,
        cast( vote_average as DECIMAL) as vote_average,
        cast( vote_count as int) as vote_count,
        load_date
    
     from {{ source('raw','movies_raw') }}
     where adult in ("True", "False")
     and adult !="Two months later" #Erroranous data
)
select * from movies_curate