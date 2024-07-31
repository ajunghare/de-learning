select * from {{ ref ('movies_raw_to_curate') }}
where adult is null
