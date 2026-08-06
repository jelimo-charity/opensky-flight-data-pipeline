

-- ============================================================================
-- Model: silver_state_vectors
-- Layer: Silver
--
-- Purpose:
-- Enriches the cleaned aircraft state vectors by adding derived metrics,
-- classifications, and time-based attributes for analytics and reporting.
--
-- Transformations:
-- - Converts speed from m/s to km/h and knots
-- - Converts altitude from meters to feet
-- - Converts vertical rate from m/s to ft/min
-- - Creates flight status and movement status
-- - Classifies aircraft heading into compass directions
-- - Calculates position freshness
-- - Extracts snapshot date and hour
-- ============================================================================

with state_vectors as (

    select *
    from "opensky_flight_data"."silver"."stg_state_vectors"

)

select

    -- =========================================================================
    -- Aircraft Information
    -- =========================================================================
    id,
    snapshot_time,
    icao24,
    callsign,
    origin_country,

    -- =========================================================================
    -- Position
    -- =========================================================================
    longitude,
    latitude,

    -- =========================================================================
    -- Raw Flight Measurements
    -- =========================================================================
    velocity,
    true_track,
    baro_altitude,
    geo_altitude,
    vertical_rate,
    on_ground,

    -- =========================================================================
    -- Speed Conversions
    -- =========================================================================

    -- meters/second → kilometers/hour
    round(velocity * 3.6, 2) as speed_kmh,

    -- meters/second → knots
    round(velocity * 1.94384, 2) as speed_knots,

    -- =========================================================================
    -- Altitude Conversions
    -- =========================================================================

    -- meters → feet
    round(baro_altitude * 3.28084, 2) as baro_altitude_ft,

    round(geo_altitude * 3.28084, 2) as geo_altitude_ft,

    -- =========================================================================
    -- Vertical Speed
    -- =========================================================================

    -- meters/sec → feet/min
    round(vertical_rate * 196.85, 2) as vertical_rate_ft_min,

    -- =========================================================================
    -- Flight Status
    -- =========================================================================

    case
        when on_ground then 'Ground'
        else 'Airborne'
    end as flight_status,

    -- =========================================================================
    -- Movement Classification
    -- =========================================================================

    case

        when on_ground and coalesce(velocity,0) < 5
            then 'Parked'

        when on_ground and coalesce(velocity,0) >= 5
            then 'Taxiing'

        when not on_ground and geo_altitude < 1000
            then 'Takeoff/Landing'

        else 'Cruising'

    end as movement_status,

    -- =========================================================================
    -- Heading
    -- =========================================================================

    case

        when true_track >= 337.5 or true_track < 22.5 then 'N'
        when true_track < 67.5 then 'NE'
        when true_track < 112.5 then 'E'
        when true_track < 157.5 then 'SE'
        when true_track < 202.5 then 'S'
        when true_track < 247.5 then 'SW'
        when true_track < 292.5 then 'W'
        when true_track < 337.5 then 'NW'

        else null

    end as heading,

    -- =========================================================================
    -- Position Freshness
    -- =========================================================================

    extract(epoch from (snapshot_time - time_position))
        as position_age_seconds,

    extract(epoch from (snapshot_time - last_contact))
        as last_contact_age_seconds,

    -- =========================================================================
    -- Time Dimensions
    -- =========================================================================

    cast(snapshot_time as date) as snapshot_date,

    extract(hour from snapshot_time) as snapshot_hour,
    
    -- =========================================================================
-- Position Timestamps
-- =========================================================================
time_position,
last_contact,
    -- =========================================================================
    -- Metadata
    -- =========================================================================

    sensors,
    squawk,
    spi,
    position_source,
    category,
    created_at

from state_vectors