from scripts.extract import get_all_state_vectors
from scripts.load import load_state_vectors


def ingest_state_vectors():
    print("Starting OpenSky ingestion...")

    state_vectors = get_all_state_vectors()

    print(f"Retrieved {len(state_vectors['states'])} state vectors")

    load_state_vectors(state_vectors)

    print("Finished ingestion.")