

-- ============================================================================
-- Model: airport_surface_activity
-- Layer: Silver
--
-- Purpose:
-- Contains only aircraft that are currently on the ground.
--
-- This model supports airport surface operations, congestion analysis,
-- and ground movement monitoring.
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
    -- Ground Activity
    -- =========================================================================
    speed_kmh,
    heading,
    movement_status,
    squawk,

    -- =========================================================================
    -- Operational Status
    -- =========================================================================
    flight_status,
    on_ground,

    -- =========================================================================
    -- Time Dimensions
    -- =========================================================================
    snapshot_date,
    snapshot_hour

from "opensky_flight_data"."silver"."state_vectors"

where flight_status = 'Ground'