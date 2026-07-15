import requests
from config import OPENSKY_BASE_URL


def get_all_state_vectors():
    url = f"{OPENSKY_BASE_URL}/states/all"

    print(f"Requesting: {url}")

    response = requests.get(url, timeout=30)

    print(f"Status Code: {response.status_code}")

    response.raise_for_status()

    return response.json()