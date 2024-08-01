with
actual_datatypes as (
    select
        column_name,
        data_type
    from {{ source('information_schema','COLUMNS') }}
    where table_name = 'movies_curate'
),

expected_datatypes as (
    select
        'adult' as column_name,
        'bool' as data_type
    union all
    select
        'belongs_to_collection' as column_name,
        'json' as data_type
    union all
    select
        'budget' as column_name,
        'int64' as data_type
    union all
    select
        'genres' as column_name,
        'Array<string>' as data_type
    union all
    select
        'homepage' as column_name,
        'string' as data_type
    union all
    select
        'id' as column_name,
        'int64' as data_type
    union all
    select
        'imdb_id' as column_name,
        'string' as data_type
    union all
    select
        'original_language' as column_name,
        'string' as data_type
    union all
    select
        'original_title' as column_name,
        'string' as data_type
    union all
    select
        'overview' as column_name,
        'string' as data_type
    union all
    select
        'popularity' as column_name,
        'numeric' as data_type
    union all
    select
        'poster_path' as column_name,
        'string' as data_type
    union all
    select
        'production_companies' as column_name,
        'Array<string>' as data_type
    union all
    select
        'production_countries' as column_name,
        'Array<string>' as data_type
    union all
    select
        'release_date' as column_name,
        'date' as data_type
    union all
    select
        'revenue' as column_name,
        'int64' as data_type
    union all
    select
        'runtime' as column_name,
        'numeric' as data_type
    union all
    select
        'spoken_languages' as column_name,
        'Array<string>' as data_type
    union all
    select
        'status' as column_name,
        'string' as data_type
    union all
    select
        'tagline' as column_name,
        'string' as data_type
    union all
    select
        'title' as column_name,
        'string' as data_type
    union all
    select
        'video' as column_name,
        'bool' as data_type
    union all
    select
        'vote_average' as column_name,
        'numeric' as data_type
    union all
    select
        'vote_count' as column_name,
        'int64' as data_type
)

select * from actual_datatypes as ad inner join expected_datatypes as ed
    on
        ad.column_name = ed.column_name
        and lower(ad.data_type) != lower(ed.data_type)
