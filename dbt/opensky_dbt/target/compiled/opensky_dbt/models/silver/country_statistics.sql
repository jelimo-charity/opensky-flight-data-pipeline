

-- ============================================================================
-- Model: country_statistics
-- Layer: Silver
--
-- Purpose:
-- Aggregates aircraft activity by origin country, providing summary
-- statistics for fleet size, flight status, speed, and altitude.
--
-- This model supports country-level reporting and comparative analysis.
-- ============================================================================

select

    -- =========================================================================
    -- Country Information
    -- =========================================================================
    origin_country,

    -- =========================================================================
    -- Aircraft Counts
    -- =========================================================================
    count(*) as total_aircraft,

    count(*) filter (
        where flight_status = 'Airborne'
    ) as airborne_aircraft,

    count(*) filter (
        where flight_status = 'Ground'
    ) as grounded_aircraft,

    count(distinct icao24) as unique_aircraft,

    -- =========================================================================
    -- Speed Metrics
    -- =========================================================================
    round(avg(speed_kmh), 2) as average_speed_kmh,

    max(speed_kmh) as maximum_speed_kmh,

    -- =========================================================================
    -- Altitude Metrics
    -- =========================================================================
    round(avg(geo_altitude_ft), 2) as average_altitude_ft,

    max(geo_altitude_ft) as maximum_altitude_ft

from "opensky_flight_data"."silver"."state_vectors"

group by origin_country

order by total_aircraft desc