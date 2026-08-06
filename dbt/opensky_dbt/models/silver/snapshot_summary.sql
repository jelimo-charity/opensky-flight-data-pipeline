{{ config(materialized='table') }}

-- ============================================================================
-- Model: silver_snapshot_summary
-- Layer: Silver
--
-- Purpose:
-- Summarizes each snapshot by calculating fleet-level metrics, including
-- aircraft counts, flight status distribution, average speed, average
-- altitude, and the number of reporting countries.
--
-- This model provides one record per snapshot and is intended for
-- monitoring overall air traffic activity over time.
-- ============================================================================

select

    -- =========================================================================
    -- Snapshot Information
    -- =========================================================================
    snapshot_time,
    snapshot_date,
    snapshot_hour,

    -- =========================================================================
    -- Fleet Counts
    -- =========================================================================
    count(*) as total_aircraft,

    count(*) filter (
        where flight_status = 'Airborne'
    ) as airborne_aircraft,

    count(*) filter (
        where flight_status = 'Ground'
    ) as grounded_aircraft,

    -- =========================================================================
    -- Speed Metrics
    -- =========================================================================
    round(avg(speed_kmh), 2) as average_speed_kmh,

    max(speed_kmh) as maximum_speed_kmh,

    min(speed_kmh) as minimum_speed_kmh,

    -- =========================================================================
    -- Altitude Metrics
    -- =========================================================================
    round(avg(geo_altitude_ft), 2) as average_altitude_ft,

    max(geo_altitude_ft) as maximum_altitude_ft,

    min(geo_altitude_ft) as minimum_altitude_ft,

    -- =========================================================================
    -- Geographic Coverage
    -- =========================================================================
    count(distinct origin_country) as reporting_countries,

    -- =========================================================================
    -- Aircraft Activity
    -- =========================================================================
    count(distinct icao24) as unique_aircraft,

    count(distinct callsign) as unique_callsigns

from {{ ref('state_vectors') }}

group by

    snapshot_time,
    snapshot_date,
    snapshot_hour

order by snapshot_time