
  
    

  create  table "opensky_flight_data"."silver"."latest_aircraft__dbt_tmp"
  
  
    as
  
  (
    

-- ============================================================================
-- Model: silver_aircraft_latest
-- Layer: Silver
--
-- Purpose:
-- Maintains the most recent snapshot for each aircraft by selecting the latest
-- available record based on snapshot_time. This model is optimized for
-- real-time monitoring, current fleet status, and live dashboards.
--
-- ============================================================================

with ranked_aircraft as (

    select

        *,

        row_number() over (
            partition by icao24
            order by snapshot_time desc
        ) as row_num

    from "opensky_flight_data"."silver"."state_vectors"

)

select

    -- =========================================================================
    -- Aircraft Information
    -- =========================================================================
    snapshot_time,
    icao24,
    callsign,
    origin_country,

    -- =========================================================================
    -- Position
    -- =========================================================================
    latitude,
    longitude,

    -- =========================================================================
    -- Performance
    -- =========================================================================
    speed_kmh,
    speed_knots,

    baro_altitude_ft,
    geo_altitude_ft,

    vertical_rate_ft_min,

    heading,

    -- =========================================================================
    -- Flight Status
    -- =========================================================================
    flight_status,
    movement_status,

    -- =========================================================================
    -- Position Freshness
    -- =========================================================================
    position_age_seconds,
    last_contact_age_seconds,

    -- =========================================================================
    -- Metadata
    -- =========================================================================
    snapshot_date,
    snapshot_hour,
    position_source,
    category

from ranked_aircraft

where row_num = 1
  );
  