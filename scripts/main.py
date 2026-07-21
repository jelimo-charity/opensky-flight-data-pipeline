
from scripts.extract import get_all_state_vectors
from scripts.load import load_state_vectors
from scripts.db_config import get_db_engine
from sqlalchemy import text

engine = get_db_engine()
with engine.connect() as connection:
    result = connection.execute(text("SELECT 1"))
    print(f"Database connection test result: {result.scalar()}")


def main():
    try:
        # Get all state vectors from the OpenSky API
        state_vectors = get_all_state_vectors()
        load_state_vectors(state_vectors)
        
        # Print the number of state vectors retrieved
        print(f"Retrieved {len(state_vectors['states'])} state vectors.")
        print(state_vectors['states'][0])  # Print the first state vector for reference

    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    main()