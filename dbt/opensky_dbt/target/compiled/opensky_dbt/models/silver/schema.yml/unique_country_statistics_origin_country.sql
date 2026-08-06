
    
    

select
    origin_country as unique_field,
    count(*) as n_records

from "opensky_flight_data"."silver"."country_statistics"
where origin_country is not null
group by origin_country
having count(*) > 1


