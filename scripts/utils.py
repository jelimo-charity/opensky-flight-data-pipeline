from sqlalchemy import text
from db_config import get_db_engine


def get_distinct_aircraft(limit=200):
    """
    Retrieve distinct ICAO24 aircraft identifiers from Bronze.
    """

    engine = get_db_engine()

    query = text("""
        SELECT DISTINCT icao24
        FROM bronze.all_state_vectors
        WHERE
            icao24 IS NOT NULL
            AND callsign IS NOT NULL
            AND longitude IS NOT NULL
            AND latitude IS NOT NULL
        LIMIT :limit
    """)

    with engine.connect() as connection:
        result = connection.execute(query, {"limit": limit})

        return [row.icao24 for row in result]