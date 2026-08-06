
  
    

  create  table "opensky_flight_data"."silver"."airborne_flights__dbt_tmp"
  
  
    as
  
  (
    

-- ============================================================================
-- Model: airborne_flights
-- Layer: Silver
--
-- Purpose:
-- Contains only aircraft that are currently airborne.
--
-- This model supports flight monitoring, route analysis, and
-- in-flight performance reporting.
-- ============================================================================

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
    -- Flight Performance
    -- =========================================================================
    speed_kmh,
    speed_knots,
    geo_altitude_ft,
    vertical_rate_ft_min,
    heading,

    -- =========================================================================
    -- Flight Status
    -- =========================================================================
    flight_status,
    movement_status,

    -- =========================================================================
    -- Time Dimensions
    -- =========================================================================
    snapshot_date,
    snapshot_hour

from "opensky_flight_data"."silver"."state_vectors"

where flight_status = 'Airborne'
  );
  