{{ config(materialized='table') }}

-- ============================================================================
-- Model: silver_aircraft_status
-- Layer: Silver
--
-- Purpose:
-- Captures the operational state of each aircraft, including flight status,
-- movement classification, squawk code, and other operational indicators.
--
-- This model is built from silver_state_vectors and contains only
-- status-related attributes for operational monitoring and reporting.
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
    -- Operational Status
    -- =========================================================================
    flight_status,
    movement_status,
    on_ground,

    -- =========================================================================
    -- Flight Tracking
    -- =========================================================================
    squawk,
    spi,
    category,
    position_source,

    -- =========================================================================
    -- Position Freshness
    -- =========================================================================
    position_age_seconds,
    last_contact_age_seconds,

    -- =========================================================================
    -- Time Dimensions
    -- =========================================================================
    snapshot_date,
    snapshot_hour

from {{ ref('state_vectors') }}