
    
    

with all_values as (

    select
        heading as value_field,
        count(*) as n_records

    from "opensky_flight_data"."silver"."state_vectors"
    group by heading

)

select *
from all_values
where value_field not in (
    'N','NE','E','SE','S','SW','W','NW'
)


