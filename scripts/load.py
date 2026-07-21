from datetime import datetime, timezone
from sqlalchemy import text
from scripts.db_config import get_db_engine

def load_state_vectors(state_vectors):
    engine = get_db_engine()

    snapshot_time = datetime.fromtimestamp(state_vectors["time"], tz=timezone.utc)

    insert_query = text("""
        INSERT INTO bronze.all_state_vectors (
            snapshot_time,
            icao24,
            callsign,
            origin_country,
            time_position,
            last_contact,
            longitude,
            latitude,
            baro_altitude,
            on_ground,
            velocity,
            true_track,
            vertical_rate,
            sensors,
            geo_altitude,
            squawk,
            spi,
            position_source,
            category
        )
        VALUES (
            :snapshot_time,
            :icao24,
            :callsign,
            :origin_country,
            :time_position,
            :last_contact,
            :longitude,
            :latitude,
            :baro_altitude,
            :on_ground,
            :velocity,
            :true_track,
            :vertical_rate,
            :sensors,
            :geo_altitude,
            :squawk,
            :spi,
            :position_source,
            :category
        )
    """)
    for state_vector in state_vectors["states"]:
        if len(state_vector) != 18:
            print(f"Found state vector with {len(state_vector)} fields:")
            print(state_vector)
            break
    
    with engine.begin() as connection:
        for state_vector in state_vectors["states"]:
            state_vector = state_vector + [None] * (18 - len(state_vector))  # Pad with None if fewer than 18 fields

            connection.execute(insert_query, {
                "snapshot_time": snapshot_time,
                "icao24": state_vector[0],
                "callsign": state_vector[1],
                "origin_country": state_vector[2],
                "time_position": (
                    datetime.fromtimestamp(state_vector[3], tz=timezone.utc)
                    if state_vector[3] is not None else None),
                "last_contact": (
                    datetime.fromtimestamp(state_vector[4], tz=timezone.utc)
                    if state_vector[4] is not None else None),
                "longitude": state_vector[5],
                "latitude": state_vector[6],
                "baro_altitude": state_vector[7],
                "on_ground": state_vector[8],
                "velocity": state_vector[9],
                "true_track": state_vector[10],
                "vertical_rate": state_vector[11],
                "sensors": state_vector[12],
                "geo_altitude": state_vector[13],
                "squawk": state_vector[14],
                "spi": state_vector[15],
                "position_source": state_vector[16],
                "category": state_vector[17]
            })
    print(f"Inserted {len(state_vectors['states'])} state vectors into the database.")



