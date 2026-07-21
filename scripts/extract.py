import requests

from config import OPENSKY_BASE_URL
from auth import tokens


def get_all_state_vectors():
    url = f"{OPENSKY_BASE_URL}/states/all"

    print(f"Requesting: {url}")

    response = requests.get(url, timeout=30)

    print(f"Status Code: {response.status_code}")

    response.raise_for_status()

    return response.json()


def get_flights_by_aircraft(icao24, begin, end):
    url = f"{OPENSKY_BASE_URL}/flights/aircraft"

    params = {
        "icao24": icao24,
        "begin": begin,
        "end": end,
    }

    print(f"Requesting: {url}")
    print(f"Parameters: {params}")

    response = requests.get(
        url,
        headers=tokens.headers(),
        params=params,
        timeout=30,
    )

    print(f"Status Code: {response.status_code}")

    response.raise_for_status()

    return response.json()




