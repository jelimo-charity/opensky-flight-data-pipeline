
  
    

  create  table "opensky_flight_data"."silver"."aircraft_location__dbt_tmp"
  
  
    as
  
  (
    

-- ============================================================================
-- Model: silver_aircraft_location
-- Layer: Silver
--
-- Purpose:
-- Stores aircraft geographic and positional information to support mapping,
-- trajectory visualization, and spatial analysis.
--
-- This model is built from silver_state_vectors and contains only
-- location-related attributes.
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
    -- Geographic Coordinates
    -- =========================================================================
    latitude,
    longitude,

    -- =========================================================================
    -- Position Timestamps
    -- =========================================================================
    time_position,
    last_contact,

    -- =========================================================================
    -- Position Freshness
    -- =========================================================================
    position_age_seconds,
    last_contact_age_seconds,

    -- =========================================================================
    -- Position Metadata
    -- =========================================================================
    position_source,

    -- =========================================================================
    -- Time Dimensions
    -- =========================================================================
    snapshot_date,
    snapshot_hour

from "opensky_flight_data"."silver"."state_vectors"
  );
  