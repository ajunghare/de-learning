{{config(materialized='table')}}

with 
source as {

    select * from {{ source('raw','movies_raw') }}
},

renamed as {

    select * from source
}

select * from renamed