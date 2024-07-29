with
actual_datatypes as (
    select column_name, data_type
    from {{ source('information_schema','COLUMNS') }}
    where table_name = 'movies_curate'
),
expected_datatypes as(
    select 'adult' as column_name, 'bool' as data_type
    union all
    select 'belongs_to_collection', 'json'
    union all
    select 'budget', 'int64'
    union all
    select 'genres', 'Array<string>'
    union all
    select 'homepage', 'string'
    union all
    select 'id', 'int64'
    union all
    select 'imdb_id', 'string'
    union all
    select 'original_language', 'string'
    union all
    select 'original_title', 'string'
    union all
    select 'overview', 'string'
    union all
    select 'popularity', 'numeric'
    union all
    select 'poster_path', 'string'
    union all
    select 'production_companies', 'Array<string>'
    union all
    select 'production_countries', 'Array<string>'
    union all
    select 'release_date', 'date'
    union all
    select 'revenue', 'int64'
    union all
    select 'runtime', 'numeric'
    union all
    select 'spoken_languages', 'Array<string>'
    union all
    select 'status', 'string'
    union all
    select 'tagline', 'string'
    union all
    select 'title', 'string'
    union all
    select 'video', 'bool'
    union all
    select 'vote_average', 'numeric'
    union all
    select 'vote_count', 'int64'
    )
select * from actual_datatypes ad inner join expected_datatypes ed
on ad.column_name = ed.column_name and lower(ad.data_type) != lower(ed.data_type)