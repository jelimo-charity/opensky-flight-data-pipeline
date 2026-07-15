CREATE TABLE IF NOT EXISTS bronze.all_state_vectors (
    id BIGSERIAL PRIMARY KEY,

    -- Snapshot timestamp from the API response ("time")
    snapshot_time TIMESTAMPTZ NOT NULL,

    -- State vector fields
    icao24 VARCHAR(6) NOT NULL,
    callsign VARCHAR(8),
    origin_country TEXT,
    time_position TIMESTAMPTZ,
    last_contact TIMESTAMPTZ,
    longitude DOUBLE PRECISION,
    latitude DOUBLE PRECISION,
    baro_altitude DOUBLE PRECISION,
    on_ground BOOLEAN,
    velocity DOUBLE PRECISION,
    true_track DOUBLE PRECISION,
    vertical_rate DOUBLE PRECISION,
    sensors INTEGER[],
    geo_altitude DOUBLE PRECISION,
    squawk VARCHAR(10),
    spi BOOLEAN,
    position_source SMALLINT,
    category SMALLINT,

    -- Ingestion metadata
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);