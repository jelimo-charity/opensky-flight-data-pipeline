# OpenSky Flight Data Pipeline

An end-to-end **data engineering** project that ingests live aircraft data from the [OpenSky Network API](https://opensky-network.org/), stores it in PostgreSQL, and orchestrates the workflow with Apache Airflow.

Built as a portfolio project to demonstrate real-world ETL skills: API extraction, authentication, database loading, medallion architecture, and containerized orchestration.

---

## What this project does

Every few minutes, the pipeline:

1. **Extracts** current aircraft positions (state vectors) from the OpenSky API  
2. **Transforms** raw API fields into structured rows (timestamps, null handling, field padding)  
3. **Loads** the data into a PostgreSQL `bronze` schema for historical storage  
4. **Orchestrates** the full run with an Airflow DAG on a schedule  

The goal is to turn free, real-time aviation data into a reliable warehouse foundation that can later power analytics, dashboards, and SQL modeling (silver/gold layers).

---

## Why OpenSky?

The OpenSky Network provides free access to live ADS-B flight data worldwide. That makes it a strong public dataset for learning production-style pipelines:

| Challenge | How this project handles it |
|-----------|-----------------------------|
| External API dependency | Timeouts, status checks, retries via Airflow |
| Auth for restricted endpoints | OAuth2 client credentials with auto token refresh |
| High-volume snapshots | Bulk insert of thousands of aircraft per run |
| Scheduling & reliability | Airflow DAG every 5 minutes with retries |
| Reproducible environment | Docker Compose for Airflow, Redis, PostgreSQL |

---

## Architecture

```
OpenSky Network API
        │
        ▼
┌───────────────────┐
│  Python Extract   │  scripts/extract.py
│  (+ OAuth tokens) │  scripts/auth.py
└─────────┬─────────┘
          │
          ▼
┌───────────────────┐
│  Python Load      │  scripts/load.py
│  SQLAlchemy       │
└─────────┬─────────┘
          │
          ▼
┌───────────────────┐
│  PostgreSQL       │  bronze.all_state_vectors
│  (Bronze layer)   │
└─────────┬─────────┘
          │
          ▼
┌───────────────────┐
│  Apache Airflow   │  dags/opensky_state_ingestion.py
│  (every 5 min)    │  pipelines/state_vector_pipeline.py
└───────────────────┘
```

### Medallion layers (data modeling approach)

| Layer | Status | Purpose |
|-------|--------|---------|
| **Bronze** | ✅ Implemented | Raw-ish structured landings of each API snapshot |
| **Silver** | 🔜 Planned | Cleaned, validated, deduplicated flight data |
| **Gold** | 🔜 Planned | Analytics-ready tables/views (dbt + BI tools) |

---

## Tech stack

| Area | Tools |
|------|--------|
| Language | Python 3 |
| API / HTTP | `requests` |
| Data handling | Pandas, SQLAlchemy |
| Database | PostgreSQL |
| Orchestration | Apache Airflow 3 (CeleryExecutor) |
| Messaging | Redis |
| Containers | Docker & Docker Compose |
| Config / secrets | `.env` + `python-dotenv` |
| Version control | Git & GitHub |

---

## Project structure

```
opensky-flight-data-pipeline/
├── dags/
│   └── opensky_state_ingestion.py   # Airflow DAG (schedule + task)
├── pipelines/
│   └── state_vector_pipeline.py     # Orchestrates extract → load
├── scripts/
│   ├── auth.py                      # OAuth2 token manager
│   ├── config.py                    # Env-based configuration
│   ├── db_config.py                 # SQLAlchemy engine
│   ├── extract.py                   # OpenSky API calls
│   ├── load.py                      # Insert into bronze table
│   ├── main.py                      # Manual run entrypoint
│   └── utils.py
├── config/                          # Airflow config
├── logs/                            # Airflow task logs
├── docker-compose.yaml              # Airflow + Postgres + Redis
├── requirements.txt
├── .env                             # Secrets (not committed)
└── README.md
```

---

## Data: what is a state vector?

A **state vector** is a snapshot of one aircraft at a point in time. Examples of fields stored in `bronze.all_state_vectors`:

- `icao24` — unique aircraft identifier  
- `callsign` — flight callsign  
- `origin_country`  
- `longitude` / `latitude`  
- `baro_altitude` / `geo_altitude`  
- `velocity`, `true_track`, `vertical_rate`  
- `on_ground`, `squawk`, `category`  
- `snapshot_time` — when this batch was captured  

Each DAG run inserts one full worldwide snapshot (often thousands of rows).

---

## Getting started

### Prerequisites

- Python 3.10+  
- Docker Desktop (for Airflow)  
- PostgreSQL (local or via Docker)  
- An [OpenSky Network](https://opensky-network.org/) account (for authenticated endpoints)  

### 1. Clone the repo

```bash
git clone https://github.com/<your-username>/opensky-flight-data-pipeline.git
cd opensky-flight-data-pipeline
```

### 2. Create a virtual environment

**Windows (PowerShell):**

```powershell
python -m venv venv
.\venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

**macOS / Linux:**

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 3. Configure environment variables

Create a `.env` file in the project root:

```env
# PostgreSQL
DB_HOST=localhost
DB_PORT=5432
DB_NAME=opensky_flight_data
DB_USER=postgres
DB_PASSWORD=your_password

# OpenSky API
opensky_base_url=https://opensky-network.org/api
clientId=your_client_id
clientSecret=your_client_secret
token_url=https://auth.opensky-network.org/auth/realms/opensky-network/protocol/openid-connect/token

# Airflow (optional / as needed by docker-compose)
FERNET_KEY=your_fernet_key
AIRFLOW__API_AUTH__JWT_SECRET=your_jwt_secret
```

> Never commit `.env`. Keep credentials out of Git.

### 4. Prepare the database

Create the database and bronze table (example):

```sql
CREATE DATABASE opensky_flight_data;

CREATE SCHEMA IF NOT EXISTS bronze;

CREATE TABLE IF NOT EXISTS bronze.all_state_vectors (
    snapshot_time   TIMESTAMPTZ,
    icao24          TEXT,
    callsign        TEXT,
    origin_country  TEXT,
    time_position   TIMESTAMPTZ,
    last_contact    TIMESTAMPTZ,
    longitude       DOUBLE PRECISION,
    latitude        DOUBLE PRECISION,
    baro_altitude   DOUBLE PRECISION,
    on_ground       BOOLEAN,
    velocity        DOUBLE PRECISION,
    true_track      DOUBLE PRECISION,
    vertical_rate   DOUBLE PRECISION,
    sensors         TEXT,
    geo_altitude    DOUBLE PRECISION,
    squawk          TEXT,
    spi             BOOLEAN,
    position_source INTEGER,
    category        INTEGER
);
```

### 5. Run ingestion manually (without Airflow)

Useful for testing extract + load:

```bash
python -m scripts.main
```

You should see a successful DB connection, a row count from the API, and inserts into `bronze.all_state_vectors`.

### 6. Run with Airflow (Docker)

```bash
docker compose up -d
```

Then open the Airflow UI:

- URL: [http://localhost:8080](http://localhost:8080)  
- Default login (from compose setup): `airflow` / `airflow`  

Unpause the DAG **`opensky_state_ingestion`**. It runs every **5 minutes**, retries twice on failure, and calls `ingest_state_vectors()`.

---

## Pipeline flow (code path)

```
Airflow DAG
  └─ task: ingest_state_vectors
       └─ pipelines/state_vector_pipeline.py
            ├─ extract.get_all_state_vectors()   → OpenSky /states/all
            └─ load.load_state_vectors(...)      → PostgreSQL bronze
```

You can also call authenticated endpoints (example already sketched in code):

- Flights by aircraft (`/flights/aircraft`) using Bearer tokens from `scripts/auth.py`

---

## Skills demonstrated

This project is designed to show portfolio-ready data engineering practice:

- Designing an **ETL pipeline** from a live public API  
- Managing **OAuth2 authentication** and token refresh  
- Loading structured data into **PostgreSQL** with SQLAlchemy  
- Applying a **medallion (bronze → silver → gold)** mindset  
- Orchestrating jobs with **Apache Airflow** (schedule, retries, logging)  
- Running services with **Docker Compose**  
- Separating config/secrets with **environment variables**  
- Writing modular Python (`extract` / `load` / `pipeline` / `dag`)

---

## Roadmap

Planned next steps for a fuller analytics platform:

- [ ] Silver layer: cleaning, null rules, duplicate control  
- [ ] Gold layer with **dbt** (facts, dimensions, aggregations)  
- [ ] Incremental loads / upserts to avoid reprocessing noise  
- [ ] Data quality tests (dbt tests or custom checks)  
- [ ] Dashboard in **Power BI** or **Metabase** (traffic by country, altitude, on-ground ratio, etc.)  
- [ ] Additional OpenSky endpoints (arrivals, departures, tracks)

---

## Useful OpenSky endpoints (reference)

| Endpoint idea | Use |
|---------------|-----|
| All state vectors | Live global aircraft positions (current focus) |
| Flights by aircraft | History for one `icao24` in a time window |
| Arrivals / departures by airport | Airport traffic analytics |
| Track by aircraft | Path of a single flight |

---

## License

This project is for learning and portfolio use. OpenSky data usage should follow the [OpenSky Network terms](https://opensky-network.org/).

---

## Author

**Charity Jelimo Kipruto** — Data Engineering portfolio project.
