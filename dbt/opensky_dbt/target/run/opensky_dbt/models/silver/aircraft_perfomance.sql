
  
    

  create  table "opensky_flight_data"."silver"."aircraft_perfomance__dbt_tmp"
  
  
    as
  
  (
    

-- ============================================================================
-- Model: silver_aircraft_performance
-- Layer: Silver
--
-- Purpose:
-- Provides aircraft performance metrics for analyzing flight behavior,
-- including speed, altitude, climb/descent rate, and heading.
--
-- This model is built from silver_state_vectors and contains only the
-- performance-related attributes required for downstream analytics.
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
    -- Speed Metrics
    -- =========================================================================
    velocity,
    speed_kmh,
    speed_knots,

    -- =========================================================================
    -- Altitude Metrics
    -- =========================================================================
    baro_altitude,
    geo_altitude,
    baro_altitude_ft,
    geo_altitude_ft,

    -- =========================================================================
    -- Vertical Movement
    -- =========================================================================
    vertical_rate,
    vertical_rate_ft_min,

    -- =========================================================================
    -- Direction
    -- =========================================================================
    true_track,
    heading,

    -- =========================================================================
    -- Flight Classification
    -- =========================================================================
    flight_status,
    movement_status,

    -- =========================================================================
    -- Time Dimensions
    -- =========================================================================
    snapshot_date,
    snapshot_hour

from "opensky_flight_data"."silver"."state_vectors"
  );
  