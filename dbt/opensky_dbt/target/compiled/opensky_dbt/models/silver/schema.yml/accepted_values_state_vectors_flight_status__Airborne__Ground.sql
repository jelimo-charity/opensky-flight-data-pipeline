
    
    

with all_values as (

    select
        flight_status as value_field,
        count(*) as n_records

    from "opensky_flight_data"."silver"."state_vectors"
    group by flight_status

)

select *
from all_values
where value_field not in (
    'Airborne','Ground'
)


