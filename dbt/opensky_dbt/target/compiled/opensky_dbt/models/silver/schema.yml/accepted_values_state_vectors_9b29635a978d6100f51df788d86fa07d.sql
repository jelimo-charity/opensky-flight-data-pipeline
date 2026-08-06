
    
    

with all_values as (

    select
        movement_status as value_field,
        count(*) as n_records

    from "opensky_flight_data"."silver"."state_vectors"
    group by movement_status

)

select *
from all_values
where value_field not in (
    'Parked','Taxiing','Takeoff/Landing','Cruising'
)


