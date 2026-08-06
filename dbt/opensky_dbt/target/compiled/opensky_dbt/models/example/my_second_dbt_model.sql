-- Use the `ref` function to select from other models

select *
from "opensky_flight_data"."silver"."my_first_dbt_model"
where id = 1