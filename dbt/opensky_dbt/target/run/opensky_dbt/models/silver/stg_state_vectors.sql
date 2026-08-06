
  
    

  create  table "opensky_flight_data"."silver"."stg_state_vectors__dbt_tmp"
  
  
    as
  
  (
    

-- ============================================================================
-- Model: stg_state_vectors
-- Layer: Silver (Staging)
--
-- Purpose:
-- Cleans and standardizes the raw OpenSky state vector data from the Bronze
-- layer. This model serves as the foundation for all downstream Silver models.
--
-- Transformations:
-- - Removes duplicate records
-- - Trims whitespace from text fields
-- - Converts empty strings to NULL
-- - Standardizes country names to uppercase
-- - Casts columns to appropriate data types
-- - Filters invalid latitude and longitude values
-- ============================================================================

with source_data as (

    -- Read raw aircraft state vectors from the Bronze layer
    select *
    from "opensky_flight_data"."bronze"."all_state_vectors"

),

cleaned_data as (

    select

        -- Unique record identifier
        cast(id as bigint) as id,

        -- Aircraft identifier (ICAO 24-bit address)
        cast(icao24 as varchar) as icao24,

        -- Snapshot timestamp
        cast(snapshot_time as timestamp) as snapshot_time,

        -- Remove extra spaces and convert blank callsigns to NULL
        nullif(trim(callsign), '') as callsign,

        -- Standardize country names
        upper(trim(origin_country)) as origin_country,

        -- Position timestamps
        cast(time_position as timestamp) as time_position,
        cast(last_contact as timestamp) as last_contact,

        -- Geographic coordinates
        cast(longitude as numeric(9,6)) as longitude,
        cast(latitude as numeric(9,6)) as latitude,

        -- Flight measurements
        cast(baro_altitude as numeric(10,2)) as baro_altitude,
        cast(geo_altitude as numeric(10,2)) as geo_altitude,
        cast(velocity as numeric(10,2)) as velocity,
        cast(true_track as numeric(6,2)) as true_track,
        cast(vertical_rate as numeric(10,2)) as vertical_rate,

        -- Aircraft status
        cast(on_ground as boolean) as on_ground,
        cast(spi as boolean) as spi,

        -- Additional aircraft information
        nullif(trim(squawk), '') as squawk,
        sensors,
        cast(position_source as integer) as position_source,
        cast(category as integer) as category,

        -- Metadata
        cast(created_at as timestamp) as created_at

    from source_data

),

validated_data as (

    -- Remove records with invalid coordinates
    select *
    from cleaned_data
    where
        (latitude between -90 and 90 or latitude is null)
        and
        (longitude between -180 and 180 or longitude is null)

),

deduplicated as (

    /*
        Remove duplicate aircraft snapshots.

        If multiple records exist for the same aircraft at the same
        snapshot time, keep the newest record based on created_at.
    */

    select *
    from (

        select
            *,
            row_number() over (
                partition by icao24, snapshot_time
                order by created_at desc
            ) as rn

        from validated_data

    ) ranked

    where rn = 1

)

-- Final cleaned dataset
select

    id,
    snapshot_time,
    icao24,
    callsign,
    origin_country,
    time_position,
    last_contact,
    longitude,
    latitude,
    baro_altitude,
    geo_altitude,
    velocity,
    true_track,
    vertical_rate,
    on_ground,
    sensors,
    squawk,
    spi,
    position_source,
    category,
    created_at

from deduplicated
  );
  