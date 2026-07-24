{{config(materialized='table')}}
SELECT
    snapshot_time,
    icao24,
    TRIM(callsign) AS callsign,
    UPPER(origin_country) AS origin_country,

    longitude,
    latitude,

    velocity,
    true_track,

    baro_altitude,
    geo_altitude,

    on_ground,

    CASE
        WHEN on_ground THEN 'Ground'
        ELSE 'Airborne'
    END AS flight_status,

    DATE(snapshot_time) AS snapshot_date,

    EXTRACT(HOUR FROM snapshot_time) AS snapshot_hour

FROM {{ source('bronze', 'all_state_vectors') }}

WHERE
    latitude BETWEEN -90 AND 90
    AND longitude BETWEEN -180 AND 180