
    
    

select
    id as unique_field,
    count(*) as n_records

from "opensky_flight_data"."silver"."stg_state_vectors"
where id is not null
group by id
having count(*) > 1


